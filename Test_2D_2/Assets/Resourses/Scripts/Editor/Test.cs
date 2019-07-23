using System.IO;
using UnityEngine;
using UnityEditor;
public class Test : Editor
{
    [MenuItem("AB/BuildAB")]
    public static void Build()
    {
        //Directory.Delete(Application.streamingAssetsPath+"/prefabs");
        AssetDatabase.Refresh();
        BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath, BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
    }
}
