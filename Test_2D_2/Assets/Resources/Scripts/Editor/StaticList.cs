﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;
using XLua;
using UnityEngine.SceneManagement;

public static class StaticList
{
    [LuaCallCSharp]
    public static List<Type> module_lua_call_cs_list = new List<Type>()
    {
        typeof(UnityEngine.Object),
        typeof(UnityEngine.GameObject),
        typeof(Transform),
        typeof(AssetBundle),
        typeof(AssetBundleManifest),
        typeof(Vector2),
        typeof(Vector3),
        typeof(Space),
        typeof(Stack),
        typeof(TextAsset),
        typeof(Camera),
        typeof(WaitForSeconds),
        typeof(WWW),
        typeof(UnityWebRequest),
        typeof(byte),
        typeof(UnityEngine.UI.Image),
        
        typeof(ExtendedMethods),
        typeof(SceneManager),
        typeof(Util),
        typeof(MessageDelivery),
        typeof(KeyValue),
        typeof(Collision),
    };
    
    [CSharpCallLua]
    public static List<Type> module_cs_call_lua_list = new List<Type>()
    {
        typeof(NetManager.Receive),
        //typeof(XLua.Cast.IEnumerator),
        //typeof(System.Collections.IEnumerator)
    };

    [Hotfix]
    public static List<Type> module_hotfix_list = new List<Type>()
    {

    };

}
