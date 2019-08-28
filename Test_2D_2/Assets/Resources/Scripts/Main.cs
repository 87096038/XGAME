using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
using System.Net;
using System.Text;
using UnityEngine.Assertions.Must;
using UnityEngine.EventSystems; 
using UnityEngine.SceneManagement;
using UnityEngine.U2D;
using UnityEngine.UI;

//程序入口
public class Main : MonoBehaviour
{
    public GameObject UIRoot;
    public GameObject EventSystem;
    public LuaEnv luaEnv;
    
    //单例
    private static Main _instance = null;
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
        DontDestroyOnLoad(this.gameObject);
        DontDestroyOnLoad(UIRoot);
        DontDestroyOnLoad(EventSystem);

        luaEnv = new LuaEnv();

        luaEnv.AddLoader(InitLoader);
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

    private void OnDisable()
    {
        Quit();
        Init = null;
        Loop = null;
        Quit = null;
        if(luaEnv != null)
            luaEnv.Dispose();
    }

    private void OnDestroy()
    {
        
    }

    byte[] InitLoader(ref string path)
    {
        DirectoryInfo TheFolder=new DirectoryInfo(Application.dataPath+ "/lua");
        return GetLuaBytes(TheFolder, path);
    }

    private byte[] GetLuaBytes(DirectoryInfo folder, string path)
    {
        byte[] data = null;
        if(File.Exists(folder + "/" + path + ".lua"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(folder + "/" + path + ".lua"));
        foreach (DirectoryInfo NextFolder in folder.GetDirectories())
        {
            data = GetLuaBytes(NextFolder, path);
            if (data != null)
                return data;
        }
        return data;
    }
}
