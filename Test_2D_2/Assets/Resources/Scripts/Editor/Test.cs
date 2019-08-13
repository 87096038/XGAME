using System.IO;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEditor;
using UnityEditor.VersionControl;

public class Test : Editor
{
    [MenuItem("资源工具/自动设置AB名称", priority = 35)]
    public static void SetBundleName()
    {
        string path = Application.dataPath + "/Resources/Prefabs";
        DirectoryInfo dir = new DirectoryInfo (path);
        SetName(dir);
    }
    public static void SetName(DirectoryInfo dir)
    {
        foreach (var file in dir.GetFiles())
        {
            string assetPath = file.FullName.Replace(Application.dataPath, "Assets");
            string ABPath = assetPath.Replace("Assets/Resources/", "assetbundles/").ToLower();
            //string pattern = @"((\S)+)\.";
            string pattern = @"\.((\w)+)$";
            if (Regex.Match(ABPath, pattern).ToString() != ".meta")
            {
                string result = Regex.Replace(ABPath, pattern, ".ab");
                AssetImporter ai = AssetImporter.GetAtPath(assetPath);
                ai.assetBundleName = result;
            }
        }
        foreach (var _dir in dir.GetDirectories())
        {
            SetName(_dir);
        }
    }
    
    [MenuItem("资源工具/列出所有AB包路径", priority = 36)]
    public static void GetAllABName()
    {
        string _str = "";
        string[] strs = AssetDatabase.GetAllAssetBundleNames();
        foreach (var str in strs)
        {
            _str += str + "\n";
        }
        
        EditorUtility.DisplayDialog("", _str, "ok");
    }

    [MenuItem("资源工具/AB打包", priority = 40)]
    public static void Build()
    {
        string path = Application.streamingAssetsPath;// + "/assetbundles";
        DirectoryInfo dir = new DirectoryInfo (path);
        DelFiles(dir);
        AssetDatabase.Refresh();
        BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath, BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
    }

    public static void DelFiles(DirectoryInfo dir)
    {
        foreach (var _dir in dir.GetDirectories())
        {
            DelFiles(_dir);
            _dir.Delete();
        }
        foreach (var file in dir.GetFiles())
        {
            file.Delete();
        }
    }


    [MenuItem("资源工具/更新协议(暂不能用)",priority = 45)]
    static void UpdateProtocol()
    {
        //配置表目录
        //string protocolPath = AssetsConfig.GetAbsPathByKey("ProtocolPath");
        //if (!ToolHelper.GitUpdate(protocolPath))
        //    return;

        //bool error = false;
        //string errorMsg = "";
        //string projectPath = Directory.GetParent(Application.dataPath).FullName;
        //string shellRootPath = projectPath  + "/Tools/Shell";
        //string luaPath = projectPath + "/Assets/Developer/Lua/protocol/";
        //EditorUtility.DisplayDialog(protocolPath, projectPath, "OK");
        //用于做测试 shell传递参数需要用下面方法
        //string shell = projectPath +"/ShellCmd/expeortprotoc.sh"; 
        //string luaPath =  projectPath + "/Assets/StreamingAssets/Lua/protocol/";
        //string protocolPath =  Application.dataPath + "/StreamingAssets/lua";
        //string argss =  shell +" "+ luaPath +" " + protocolPath;
        //System.Diagnostics.Process.Start("/bin/bash", argss);
        
        //shell.sh里面内容很简单。#!/bin/bash  echo $1 >> $2 
        //就是把第一个命令参数的值拷贝到第二个参数/test.log文件里
        //ToolHelper.RunCommond("/bin/bash", shellRootPath + "/exportprotoc.sh " + luaPath, protocolPath, null, (msg) => {
        //    errorMsg = msg;
        //    error = true;
        //});
        //if (error)
        //{
        //    EditorUtility.DisplayDialog("更新protocol", "Error:" + errorMsg, "确定");
        //}
        //else
        //{
        //    EditorUtility.DisplayDialog("更新protocol", "更新protocol成功", "确定");
        //}
    }
}
