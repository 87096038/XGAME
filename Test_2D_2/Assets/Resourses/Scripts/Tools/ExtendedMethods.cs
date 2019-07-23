using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public static class ExtendedMethods
{
    public static Dictionary<string, MessageDelivery> GetMessageCenterDictionary()
    {
        return new Dictionary<string, MessageDelivery>();
    }

    public static AssetBundleManifest LoadManifestAsset(string path)
    {
        return null;
    }
    
    public static AssetBundleManifest LoadManifestAsset(AssetBundle ab)
    {
        return null;//ab.LoadAsset<AssetBundleManifest>("AssetBundleManifest");
    }
}
