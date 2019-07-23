using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Experimental.PlayerLoop;
using XLua.Cast;

public static class Util
{
    public static bool IsNull(this Object obj)
    {
        return (obj == null);
    }

    public static object GetNull(this object obj)
    {
        Debug.Log(obj);
        Debug.Log(null);
        return null;
    }

}

public delegate void MessageDelivery(KeyValue kv);

public class KeyValue
{
    public string Key;
    public Object Value;
    
}