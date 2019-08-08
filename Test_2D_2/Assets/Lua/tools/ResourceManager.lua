--[[
    管理资源加载
--]]

local PathMgr = require("PathManager")
local MC = require("MessageCenter")

local ResourceManager={}

function ResourceManager:Init()

    ---AB包缓存 path - 封装后的ab包
    self.AssetBundleCacheMap={}
    ---AB包依赖缓存
    self.AssetBundleIndependenceMap={}
    ---Asset缓存 path - asset
    self.AssetCacheMap={}
    ---在用的物体的缓存 gameobject - path (此顺序是为了方便回收时快速在ObjectPool找到相应table)
    self.GameObjectMap={}
    ---未使用物体的缓存池 path - table<gameobject>
    self.ObjectPool={}
    ---池中物体所放置的位置(是通过将物体移动到看不到的地方以实现destroy的效果)
    self.placePoint = UE.Vector3(5000, 5000, 5000)
    ---manifest的路径
    self.manifestPath = UE.Application.streamingAssetsPath.."/StreamingAssets"
    ---初始化manifest
    self.manifest = self:InitManifest()

    ---因为这些监听会持续到游戏关闭，所以没有remove
    MC:AddListener(Enum_MessageType.ChangeScene, self.OnChangeScene)
    MC:AddListener(Enum_MessageType.LateChangeScene , self.OnLateChangeScene)
end

--------------------------------- 常用外部接口 ---------------------------
---获取实例化的物体
---path: StreamingAssets下或Resources下的路径
---name: 若路径为ab包, 所需资源的名称
function ResourceManager:GetGameObject(path, name, parentTransform, position, positionRelativeTo, rotation, rotationRelativeTo)
    local go, CachePath, isNew
    if IS_RELEASE_MODE then
        CachePath = self:GetFullABAssetPath(path, name)
    else
        CachePath = path
    end
    if self.ObjectPool[CachePath] ~= nil then
        if #self.ObjectPool[CachePath] > 0 then
            go = table.remove(self.ObjectPool[CachePath])
            local transf = go:GetComponent("Transform")
            transf:SetParent(parentTransform)

            if positionRelativeTo == UE.Space.World then
                transf.position = position or UE.Vector3.zero
            else
                transf.localPosition = position or UE.Vector3.zero
            end

            if rotation then
                transf:Rotate(rotation.eulerAngles, rotationRelativeTo or UE.Space.World)
            end
            isNew = false
        end
    end
    ---如果池中没有就新实例化一个
    if not go then
        local asset = self:Load(path, name)
        go = self:Instantiate(asset, parentTransform, position, positionRelativeTo, rotation, rotationRelativeTo)
        isNew = true
    end
    self.GameObjectMap[go] = CachePath
    return go, isNew
end

function ResourceManager:GetGameObjectAsync(path, name, parentTransform, position, positionRelativeTo, rotation, rotationRelativeTo, callback)
    local go, CachePath, isNew
    if IS_RELEASE_MODE then
        CachePath = self:GetFullABAssetPath(path, name)
    else
        CachePath = path
    end
    if self.ObjectPool[CachePath] ~= nil then
        if #self.ObjectPool[CachePath] > 0 then
            go = table.remove(self.ObjectPool[CachePath])
            local transf = go:GetComponent("Transform")
            transf:SetParent(parentTransform)

            if positionRelativeTo == UE.Space.Self then
                transf.localPosition = position or UE.Vector3.zero
            else
                transf.position = position or UE.Vector3.zero
            end

            if rotation then
                transf:Rotate(rotation.eulerAngles, rotationRelativeTo or UE.Space.World)
            end
            isNew = false
        end
    end
    ---如果池中没有就新实例化一个
    if not go then
        isNew = true
        coroutine.yield(self:LoadAsync(path, name, function (asset)
            local go = self:Instantiate(asset, parentTransform, position, positionRelativeTo, rotation, rotationRelativeTo)
            if go then
                self.GameObjectMap[go] = CachePath
            end
            if callback and go then
                callback(go, true)
            end
        end))
    end
end

---回收物体入池
function ResourceManager:DestroyObject(gameObject, isTruly)

    if isTruly then
        UE.GameObject.Destroy(gameObject)
    else
        local path =  self.GameObjectMap[gameObject]

        local trans =  gameObject:GetComponent("Transform")
        trans:SetParent(nil)
        trans:Translate(self.placePoint)
        if self.ObjectPool[path] == nil then
            self.ObjectPool[path] = {gameObject}
        else
            table.insert(self.ObjectPool[path], gameObject)
        end
        self.GameObjectMap[gameObject] = nil
    end

end

---------------------------------- 不常用外部接口 -----------------------------

---Load，返回Asset(name: 如果是AB包则为其资源的名称)
function ResourceManager:Load(path, name)

    local asset
    if IS_RELEASE_MODE then
        local ab = self:LoadAssetBundle(path)
        asset = self:LoadAsset(ab, path, name)
    else
        asset = self:LoadResource(path)
    end
    return asset
end

function ResourceManager:LoadAsync(path, name, callback)
    local asset
    if IS_RELEASE_MODE then
        self:LoadAssetBundleAsync(path, function (ab)
            coroutine.yield(self:LoadAssetAsync(ab, path, name, callback))
        end)
    else
        coroutine.yield(self:LoadResourceAsync(path, callback))
    end
end

---实例化
function ResourceManager:Instantiate(original, parentTransform, position, positionRelativeTo, rotation, rotationRelativeTo)
    --[[
    在Instantiate中，是先setParent再setPosition的，因此在有parentTransform的情况下传position也是set的世界坐标
    --]]
    if not original then
        print("the original is nil!")
        return nil
    end
    local go
    if parentTransform then
        if(CS.Util.IsNull(parentTransform.gameObject))then
            print("the parent gameobject is null!")
            return nil
        else
            go = UE.Object.Instantiate(original, parentTransform)
            local transf = go:GetComponent("Transform")
            if positionRelativeTo == UE.Space.World then
                transf.position = position or UE.Vector3.zero
            else
                transf.localPosition = position or UE.Vector3.zero
            end
            if rotation then
                transf:Rotate(rotation.eulerAngles, rotationRelativeTo or UE.Space.World)
            end
        end
    else
        go = UE.Object.Instantiate(original, position or UE.Vector3.zero, rotation or UE.Quaternion.identity)
    end
    return go
end

---更改池的位置
function ResourceManager:SetPlacePoint(x, y, z)
    self.placePoint.x = x or self.placePoint.x
    self.placePoint.y = y or self.placePoint.y
    self.placePoint.z = z or self.placePoint.z
end

------------------------------------ 内部使用 ---------------------------------
---初始化manifest依赖， 返回manifest
function ResourceManager:InitManifest()
    local manifestAB = UE.AssetBundle.LoadFromFile(self.manifestPath)
    local manifest = manifestAB:LoadAsset("AssetBundleManifest");
    return manifest
end

---通过AB包路径 和 要加载的资源名，生成一个唯一的资源路径(这个路径并不实际存在)
function ResourceManager:GetFullABAssetPath(path, name)
    local pre, suffix = PathMgr:RemoveSuffix(path)
    return pre.."/"..name..suffix
end

---path: AB包的路径(StreamingAssets下)
---返回: 封装后的AB(包含一个ab包 和一个引用计数)
function ResourceManager:LoadAssetBundle(path)

    local Path = UE.Application.streamingAssetsPath.."/"..path
    local ab = self.AssetBundleCacheMap[path]
    if ab then
        ab.refCount = ab.refCount + 1
    else
        local cache = UE.AssetBundle.LoadFromFile(Path)
        ab = {assetBundle=cache, refCount=1}
        self.AssetBundleCacheMap[path]=ab
    end

    return ab
end

function ResourceManager:LoadAssetBundleAsync(path, callback)
    local Path = UE.Application.streamingAssetsPath.."/"..path
    local ab = self.AssetBundleCacheMap[path]
    if ab then
        ab.refCount = ab.refCount + 1
    else
        local request = UE.AssetBundle.LoadFromFileAsync(Path)
        coroutine.yield(request)
        if request.assetBundle then
            ab = {assetBundle=request.assetBundle, refCount=1}
            self.AssetBundleCacheMap[path]=ab
        else
            print("LoadAssetBundleAsync Error: connot request the assetbundle!")
        end
    end
    if callback and ab then
        callback(ab)
    end
end

---ab: AB包 AB包的路径 name:资源名
---返回: 相应Asset
function ResourceManager:LoadAsset(ab, path, name)
    local Path = self:GetFullABAssetPath(path, name)
    local asset = self.AssetCacheMap[Path]
    if not asset then
        local dependences = self.AssetBundleIndependenceMap[Path]
        if not dependences then
            dependences = self.manifest:GetAllDependencies(path)
            self.AssetBundleIndependenceMap[Path] = dependences
        end
        for i=0, dependences.Length-1, 1 do
            self:LoadAssetBundle(dependences[i])
        end
        asset = ab.assetBundle:LoadAsset(name)
        self.AssetCacheMap[Path] = asset
    end
    return asset
end

function ResourceManager:LoadAssetAsync(ab, path, name, callback)
    local Path = self:GetFullABAssetPath(path, name)
    local asset = self.AssetCacheMap[Path]
    if not asset then
        local dependences = self.AssetBundleIndependenceMap[Path]
        if not dependences then
            dependences = self.manifest:GetAllDependencies(path)
            self.AssetBundleIndependenceMap[Path] = dependences
        end
        print(dependences.Length)
        for i=0, dependences.Length-1, 1 do
            coroutine.yield(self:LoadAssetBundleAsync(dependences[i]))
        end
        local request = ab.assetBundle:LoadAssetAsync(name)
        coroutine.yield(request)
        if request.asset then
            asset = request.asset
            self.AssetCacheMap[Path] = asset
        else
            print("LoadAssetAsync Error: connot request the asset!")
        end
    end
    if callback and asset then
        callback(asset)
    end
end

---path: Resources下的路径
---返回: 相应Asset
function ResourceManager:LoadResource(path)
    local asset = self.AssetCacheMap[path]
    if not asset then
        asset = UE.Resources.Load(path)
        self.AssetCacheMap[path] = asset
    end
    return asset
end

function ResourceManager:LoadResourceAsync(path, callback)
    local asset = self.AssetCacheMap[path]
    if not asset then
        local request = UE.Resources.LoadAsync(path)
        coroutine.yield(request)
        if request.asset then
            asset = request.asset
            self.AssetCacheMap[path] = asset
        else
            print("LoadResourceAsync Error: connot request the asset!")
        end
    end
    if callback and asset then
        callback(asset)
    end
end

---释放AB包
function ResourceManager:ReleaseAssetBundle(path)
    local ab = self.AssetBundleCacheMap[path]
    if ab then
        ab.refCount = ab.refCount - 1
        if ab.refCount <= 0 then
            ab.assetBundle:Unload(false)
            self.assetBundleCacheMap[path] = nil
        end
        local dependences = self.AssetBundleIndependenceMap[path]
        for _, v in ipairs(dependences) do
            self:ReleaseAssetBundle(v)
        end
    end
end

---释放Asset
function ResourceManager:ReleaseAsset(path)
    if self.AssetCacheMap[path] then
        UE.Object.Destroy(self.AssetCacheMap[path])
    end
end

---释放所有Asset
function ResourceManager:ReleaseAsset()
    self.AssetCacheMap = {}
    ---UE.Resources.UnloadUnusedAssets()
end

---释放物品池
function ResourceManager:ReleaseGameObjectPool()
    for _, t in pairs(self.ObjectPool) do
        for _, go in pairs(t)do
            if go then
                UE.GameObject.Destroy(go)
            end
        end
    end
    self.ObjectPool={}
end

---消息回调
function ResourceManager:OnChangeScene(kv)
    self.ObjectPool={}
    self.AssetCacheMap = {}
end

function ResourceManager:OnLateChangeScene()
    collectgarbage("collect")
    UE.Resources.UnloadUnusedAssets()
end

ResourceManager:Init()

return ResourceManager