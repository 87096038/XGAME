using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
using System.Text;
using UnityEngine.UI;

//程序入口
public class Main : MonoBehaviour
{
    public GameObject UIRoot; 
    public LuaEnv luaEnv;
 
    private static Main _instance= null;
    public static Main Instance
    {
        get
        {
            if (_instance == null)
            {
                GameObject go = GameObject.Find("Main");
                if (go == null)
                {
                    go = new GameObject("Main");
                    _instance = go.AddComponent<Main>();
                }
                else
                {
                    _instance = go.GetComponent<Main>();
                    if (_instance == null)
                        _instance = go.AddComponent<Main>();
                }
            }
            return _instance;
        }
    }

    private Button a;

    [LuaCallCSharp]
    private Action Init;
    [LuaCallCSharp]
    private Action Loop;
    [LuaCallCSharp]
    private Action Quit;
    
    private void Awake()
    {
        if (_instance == null)
            _instance = this;
    }

    void Start()
    {
        //Debug.Log(Application.streamingAssetsPath);
        //AssetBundleManifest a;
        //a.GetAllDependencies()
        DontDestroyOnLoad(this.gameObject);
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(InitLoader);
        //Stack a = new Stack();
        //Transform m;
        //m.SetParent(null);
        //m.Rotate();
        //Instantiate()
        //AssetBundle ab = AssetBundle.LoadFromFile(Application.streamingAssetsPath+"/assetbundle/prefabs/ui/title/bg.ab");
        //AssetBundleManifest a = ab.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
        //Debug.Log(ab.ToString());
        //AssetBundle a = AssetBundle.LoadFromFile(Application.streamingAssetsPath+"/StreamingAssets");
        //print(a);
        luaEnv.DoString("require'Main'");

        luaEnv.Global.Get("Init", out Init);
        luaEnv.Global.Get("MainLoop", out Loop);
        luaEnv.Global.Get("Quit", out Quit);
        Init();
    }

    private void Update()
    {
        if (luaEnv != null)
        {
            luaEnv.Tick();
            Loop();
        }
    }

    private void OnDestroy()
    {
        Quit();
        if(luaEnv != null)
           luaEnv.Dispose();
        
    }

    byte[] InitLoader(ref string path)
    {
        if (File.Exists(Application.streamingAssetsPath + "/lua/" + path + ".lua.txt"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.streamingAssetsPath + "/lua/" + path + ".lua.txt"));
        if (File.Exists(Application.streamingAssetsPath + "/lua/tools/" + path + ".lua.txt"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.streamingAssetsPath + "/lua/tools/" + path + ".lua.txt"));
        return null;
    }
}
