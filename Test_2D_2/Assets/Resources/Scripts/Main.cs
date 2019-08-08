using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;
using System.Net;
using System.Text;

//程序入口
public class Main : MonoBehaviour
{
    public GameObject UIRoot;
    public LuaEnv luaEnv;

    private UnityEngine.Object asset;
    //单例
    private static Main _instance = null;
    public static Main Instance
    {
        get
        {
            if (_instance == null)
            {
                GameObject go = GameObject.Find("Main");
                if (go == null)
                {
                    go = new GameObject("Main");
                    _instance = go.AddComponent<Main>();
                }
                else
                {
                    _instance = go.GetComponent<Main>();
                    if (_instance == null)
                        _instance = go.AddComponent<Main>();
                }
            }
            return _instance;
        }
    }

    [LuaCallCSharp]
    private Action Init;
    [LuaCallCSharp]
    private Action Loop;
    [LuaCallCSharp]
    private Action Quit;
    private void Awake()
    {
        if (_instance == null)
            _instance = this;
    }

    void Start()
    {
        DontDestroyOnLoad(this.gameObject);
        DontDestroyOnLoad(UIRoot);

        luaEnv = new LuaEnv();
        //GameObject go = new GameObject("123");
        //UnityWebRequest a;
        //Server.Instance.StartListen();
        //Quaternion b = Quaternion.identity;
        //gameObject.AddComponent<AudioSource>();
        //gameObject.GetComponent(typeof(AudioSource));
        
        //a.Rotate(b.eulerAngles);
        //a.LoadAsset();
        //a.Translate();
        //System.IO.Directory.CreateDirectory(@"/Users/xiejiahong/Library/Application Support/DefaultCompany/Test_2D_2/resources/123");
        //Camera.main.ScreenToWorldPoint(Input.mousePosition)
        luaEnv.AddLoader(InitLoader);
        luaEnv.DoString("require'Main'");
        luaEnv.Global.Get("Init", out Init);
        luaEnv.Global.Get("MainLoop", out Loop);
        luaEnv.Global.Get("Quit", out Quit);
        Init();
        //AudioSource asr = gameObject.GetComponent(typeof(AudioSource)) as AudioSource;
        //UnityEngine.UI.Image img = UIRoot.transform.Find("BeginImgs").GetChild(0).GetComponent<UnityEngine.UI.Image>();
        //img.color = new Color(15, 12, 11, 0.5f);
        //StartCoroutine(BeginImgFade(UIRoot.transform.Find("BeginImgs"), 0.02f, 2));
    }

    private IEnumerator BeginImgFade(Transform parent, float step, int keepTime)
    {
        float stepTmp = step;
        int childCount = parent.childCount;
        UnityEngine.UI.Image currentImg;
        Color color = new Color(0, 0, 0, 1);
        WaitForSeconds keep = new WaitForSeconds(keepTime);
        WaitForSeconds interval = new WaitForSeconds(0.01f);
        
        for (int i = 0; i < childCount; i++)
        {
            parent.GetChild(i).gameObject.SetActive(true);
            stepTmp = step;
            currentImg = parent.GetChild(i).GetComponent<UnityEngine.UI.Image>();
            color = currentImg.color;
            color.a = 0.005f;
            while (color.a > 0)
            {
                Debug.Log(color.a);
                color.a += stepTmp;
                currentImg.color = color;
                yield return interval;
                if (color.a >= 1)
                {
                    yield return keep;
                    stepTmp = -stepTmp;
                }
            }
            parent.GetChild(i).gameObject.SetActive(false);
        }
    }

    private void Update()
    {
        if (luaEnv != null)
        {
            luaEnv.Tick();
            Loop();
        }
    }
    private void OnDestroy()
    {
        Quit();
        Init = null;
        Loop = null;
        Quit = null;
        if(luaEnv != null)
           luaEnv.Dispose();
    }

    byte[] InitLoader(ref string path)
    {
        if (File.Exists(Application.dataPath + "/lua/" + path + ".lua"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.dataPath + "/lua/" + path + ".lua"));
        else if (File.Exists(Application.dataPath + "/lua/tools/" + path + ".lua"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.dataPath + "/lua/tools/" + path + ".lua"));
        else if (File.Exists(Application.dataPath + "/lua/protobuf/" + path + ".lua"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.dataPath + "/lua/protobuf/" + path + ".lua"));
        else if (File.Exists(Application.dataPath + "/lua/logic/" + path + ".lua"))
            return Encoding.UTF8.GetBytes(File.ReadAllText(Application.dataPath + "/lua/logic/" + path + ".lua"));
        return null;
    }
}
