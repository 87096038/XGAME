﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
using System.Text;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

//程序入口
public class Main : MonoBehaviour
{
    public GameObject UIRoot;
    public LuaEnv luaEnv;
 
    //这段的功能为 使Main.cs在整体中只有一份
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
        print("c#loop");
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
        else if (File.Exists(Application.streamingAssetsPath + "/lua/tools/" + path + ".lua.txt"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.streamingAssetsPath + "/lua/tools/" + path + ".lua.txt"));
        else if (File.Exists(Application.streamingAssetsPath + "/lua/protobuf/" + path + ".lua.txt"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.streamingAssetsPath + "/lua/protobuf/" + path + ".lua.txt"));
        else if (File.Exists(Application.streamingAssetsPath + "/lua/logic/" + path + ".lua.txt"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.streamingAssetsPath + "/lua/logic/" + path + ".lua.txt"));
        return null;
    }
}
