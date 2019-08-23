local Timer = require("Timer")
local CameraFollowing={}
local PathMgr = require("PathManager")
function CameraFollowing:Init()

    ---要跟随的物体的transform
    self.targetTansform = nil
    ---相机要去的postion
    self.targetPosition = UE.Vector3(0, 0, -5)

    self.gameobject = require("ResourceManager"):GetGameObject(PathMgr.ResourcePath.Camera_Main, PathMgr.NamePath.Camera_Main, nil, self.targetPosition)
    UE.GameObject.DontDestroyOnLoad(self.gameobject)

    self.camera = self.gameobject:GetComponent("Camera")

    self.transform = self.gameobject:GetComponent("Transform")

    ---相机距目标的高度
    self.height = 10
    self.LerpSpeed = 0.1
end

function CameraFollowing:BeginFollow(targetTansform)
    self.targetTansform = targetTansform
    self.gameobject.transform.position = targetTansform.position
    Timer:AddUpdateFuc(self, self.UpdateFollow)
end

function CameraFollowing:EndFollow()
    Timer:RemoveUpdateFuc(self.UpdateFollow)
end

function CameraFollowing:UpdateFollow()
    self.targetPosition = self.targetTansform.position
    self.targetPosition.z = -self.height
    self.transform.position = UE.Vector3.Lerp(self.transform.position, self.targetPosition, self.LerpSpeed)
end

CameraFollowing:Init()
return CameraFollowing