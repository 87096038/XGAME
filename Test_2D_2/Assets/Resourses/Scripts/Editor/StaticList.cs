using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using UnityEngine.SceneManagement;

public static class StaticList
{
    [LuaCallCSharp]
    public static List<Type> mymodule_lua_call_cs_list = new List<Type>()
    {
        typeof(UnityEngine.Object),
        typeof(UnityEngine.GameObject),
        typeof(Transform),
        typeof(AssetBundle),
        typeof(AssetBundleManifest),
        typeof(Vector3),
        typeof(Space),
        typeof(ExtendedMethods),
        typeof(SceneManager),
        typeof(Util),
        typeof(MessageDelivery),
        typeof(KeyValue),
        typeof(Dictionary<string, MessageDelivery>),
        typeof(Stack),
    };
}
