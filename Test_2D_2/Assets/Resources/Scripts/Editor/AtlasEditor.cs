using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.U2D;
using System.Collections.Generic;
using System;

public class AtlasEditor
{
    public const string SpriteAtlasMapPath = "Assets/Resources/Sprite/Atlas/SpriteAtlasMap.txt";

    [MenuItem("资源工具/图集/生成图集索引文件(.txt)", priority = 20)]
    public static void LoadSpriteAtlas()
    {
        string atlasPath = "Assets/Resources/Sprite/Atlas/";
        string[] atlasFileList = Directory.GetFiles(atlasPath, "*.spriteatlas", SearchOption.AllDirectories);
        
        System.Text.StringBuilder sb = new System.Text.StringBuilder();
        for (int i = 0; i < atlasFileList.Length; i++)
        {
            string filePath = atlasFileList[i];
            SpriteAtlas spriteAtlas = AssetDatabase.LoadAssetAtPath<SpriteAtlas>(filePath);
            int spriteCount = spriteAtlas.spriteCount;
            Sprite[] spriteArray = new Sprite[spriteCount];
            spriteAtlas.GetSprites(spriteArray);
            string atlasAssetPath = AssetDatabase.GetAssetPath(spriteAtlas);
            for (int j = 0; j < spriteArray.Length; j++)
            {
                string spriteAssetPath = AssetDatabase.GetAssetPath(spriteArray[j].texture);
                sb.Append(spriteAssetPath);
                sb.Append(":");
                sb.Append(atlasAssetPath);
                sb.Append("\n");
            }
        }
        StreamWriter writer = new StreamWriter(SpriteAtlasMapPath, false);
        writer.Write(sb.ToString());
        writer.Close();
    }

    //[MenuItem("Tools/UI/Atlas/GetSpriteMap")]
    //public static Dictionary<string, string> GetSpriteMap()
//
    //{
    //    Dictionary<string, string> map = new Dictionary<string, string>();
    //    string text = FileUtils.SafeReadAllText(SpriteAtlasMapPath);
    //    string[] lines = text.Split(("\n").ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
    //    for (int i = 0; i < lines.Length; i++)
    //    {
    //        string line = lines[i];
    //        string[] paths = line.Split(("\t").ToCharArray(), StringSplitOptions.RemoveEmptyEntries);
    //        string assetPath = paths[0];
    //        string spriteAtlasPath = paths[1];
    //        map[assetPath] = spriteAtlasPath;
    //    }
    //    return map;
    //}
}