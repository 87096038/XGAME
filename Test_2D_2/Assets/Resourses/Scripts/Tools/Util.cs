
using UnityEngine;
using XLua;

public static class Util
{
    public static bool IsNull(this Object obj)
    {
        return (obj == null);
    }
}

public delegate void MessageDelivery(KeyValue kv);

public class KeyValue
{
    public string Key;
    public Object Value;
    
}