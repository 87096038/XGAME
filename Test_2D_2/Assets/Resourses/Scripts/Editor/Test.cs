using System.IO;
using UnityEngine;
using UnityEditor;
public class Test : Editor
{
    [MenuItem("资源工具/AB打包", priority = 40)]
    public static void Build()
    {
        //Directory.Delete(Application.streamingAssetsPath+"/prefabs");
        AssetDatabase.Refresh();
        BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath, BuildAssetBundleOptions.None, BuildTarget.StandaloneOSX);
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
        string projectPath = Directory.GetParent(Application.dataPath).FullName;
        //string shellRootPath = projectPath  + "/Tools/Shell";
        //string luaPath = projectPath + "/Assets/Developer/Lua/protocol/";
        //EditorUtility.DisplayDialog(protocolPath, projectPath, "OK");
        //用于做测试 shell传递参数需要用下面方法
        string shell = projectPath +"/ShellCmd/expeortprotoc.sh"; 
        string luaPath =  projectPath + "/Assets/StreamingAssets/Lua/protocol/";
        string protocolPath =  Application.dataPath + "/StreamingAssets/lua";
        string argss =  shell +" "+ luaPath +" " + protocolPath;
        System.Diagnostics.Process.Start("/bin/bash", argss);
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
