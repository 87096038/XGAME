
using UnityEngine;
using XLua;

public static class Util
{
    public static bool IsNull(this Object obj)
    {
        return (obj == null);
    }
}

//用于
//public delegate void UpdateDelivery();

//用于信息发送
public delegate void MessageDelivery(KeyValue kv);

public class KeyValue
{
    public string Key;
    public Object Value;
    
}