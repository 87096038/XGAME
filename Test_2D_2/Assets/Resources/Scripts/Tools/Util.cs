﻿
using UnityEngine;
using XLua;

public static class Util
{
    public static bool IsNull(Object obj)
    {
        return (obj == null);
    }
    
    public static byte[] Int32ToBytes(int i) {
        byte[] result = new byte[4];  
        // 由高位到低位  
        result[0] = (byte) ((i >> 24) & 0xFF);  
        result[1] = (byte) ((i >> 16) & 0xFF);  
        result[2] = (byte) ((i >> 8) & 0xFF);  
        result[3] = (byte) (i & 0xFF);
        return result;
    }
    public static int BytesToInt32(byte[] bytes) {
        int value = 0;  
        // 由高位到低位  
        for (int i = 0; i < 4; i++) {  
            int shift = (4 - 1 - i) * 8;  
            value += (bytes[i] & 0x000000FF) << shift;// 往高位游  
        }  
        return value;  
    }
}

//用于信息发送
public delegate void MessageDelivery(KeyValue kv);

public class KeyValue
{
    public string Key;
    public object Value;
    
}