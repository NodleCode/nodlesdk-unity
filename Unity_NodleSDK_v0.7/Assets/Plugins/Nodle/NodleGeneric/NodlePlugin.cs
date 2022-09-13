using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;
#if UNITY_ANDROID
using UnityEngine.Android;
#endif

public class NodlePlugin : MonoBehaviour
{
#pragma warning disable CS0414
    [SerializeField]
    private string NodleKey = "ss58:";
    [SerializeField]
    private string NodleTag = "";
#pragma warning restore CS0414

    [SerializeField] private Text textDebug;
    [SerializeField] private GameObject goSendEvents = null;
    [SerializeField] private string goSendEventsMethod = "NodleEvent";

#if UNITY_IPHONE && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern int _initPlugin(string sendEvents, string nodleEvents = "NodleEvents");

    [DllImport("__Internal")]
    private static extern void _start(string key, string tag);

    [DllImport("__Internal")]
    private static extern void _stop();

    [DllImport("__Internal")]
    private static extern bool _isStarted();

    [DllImport("__Internal")]
    private static extern bool _isScanning();

    [DllImport("__Internal")]
    private static extern void _scheduleNodleBackgroundTask();

    [DllImport("__Internal")]
    private static extern void _registerNodleBackgroundTask();

    [DllImport("__Internal")]
    private static extern void _configBool(string key, bool  value);

    [DllImport("__Internal")]
    private static extern void _configString(string key, string value);

    [DllImport("__Internal")]
    private static extern void _configInt(string key, int value);

    [DllImport("__Internal")]
    private static extern string _getVersion();

    [DllImport("__Internal")]
    private static extern void _getEvents();

#endif
#if UNITY_ANDROID && !UNITY_EDITOR 
    const string pluginName = "com.proxy42.plugin.unity.nodle.NodlePlugin";

    static AndroidJavaClass _pluginClass;
    static AndroidJavaObject _pluginInstance;
    AndroidJavaObject _context;

    public static AndroidJavaClass PluginClass
    {
        get {
            if (_pluginClass == null) {
                _pluginClass = new AndroidJavaClass(pluginName);

            }
            return _pluginClass;
        }
    }

    public static AndroidJavaObject PluginInstance
    {
        get
        {
            if (_pluginInstance == null)
            {
                _pluginInstance = PluginClass.CallStatic<AndroidJavaObject>("getInstance");

            }
            return _pluginInstance;
        }
    }
#endif
    void Start()
    {
#if UNITY_ANDROID && !UNITY_EDITOR 

        AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        AndroidJavaObject activity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
        _context = activity.Call<AndroidJavaObject>("getApplicationContext");

        Debug.Log(PluginInstance.Call<int>("_setCallback", new AndroidPluginCallback(this.gameObject)));
#endif
    }

    // Update is called once per frame
    void Update()
    {

    }
    

    public void StartNodle()
    {
#if UNITY_ANDROID && !UNITY_EDITOR 
            PluginInstance.Call("_start", NodleKey);
#endif

#if UNITY_IPHONE && !UNITY_EDITOR 
        _start(NodleKey, NodleTag);
#endif
    }

    public string GetVersion()
    {
#if UNITY_IPHONE && !UNITY_EDITOR
        return _getVersion();
#endif
#if UNITY_ANDROID && !UNITY_EDITOR
        return PluginInstance.Call<string>("_getVersion");
#endif
#if UNITY_EDITOR
        return "editor";
#endif
    }

    public void GetVersionNoReturn()
    {
#if UNITY_IPHONE && !UNITY_EDITOR
        _getVersion();
#endif
#if UNITY_ANDROID && !UNITY_EDITOR 
        PluginInstance.Call<string>("_getVersion");
#endif
    }
    public void GetEventsNodle()
    {
#if UNITY_IPHONE && !UNITY_EDITOR 
        _getEvents();
#endif
#if UNITY_ANDROID && !UNITY_EDITOR 
        PluginInstance.Call("_getEvents");
#endif
    }


    public bool IsStartedNodle()
    {
#if UNITY_IPHONE && !UNITY_EDITOR
        bool result = _isStarted();
        return result;
#endif

#if UNITY_ANDROID && !UNITY_EDITOR
        return PluginInstance.Call<bool>("_isStarted");
#endif
#if UNITY_EDITOR
        return false;
#endif
    }
    public bool IsScanning()
    {
#if UNITY_IPHONE && !UNITY_EDITOR 
        bool result = _isScanning();
        return result;
#endif
#if UNITY_ANDROID && !UNITY_EDITOR 
        return PluginInstance.Call<bool>("_isScanning");
#endif
#if UNITY_EDITOR
        return false;
#endif
    }


    public void IsStartedNodleNoReturn()
    {
#if UNITY_IPHONE && !UNITY_EDITOR 
        bool result = _isStarted();
     
#endif

#if UNITY_ANDROID && !UNITY_EDITOR 
        bool result = PluginInstance.Call<bool>("_isStarted");
#endif

    }
    public void IsScanningNoReturn()
    {
#if UNITY_IPHONE && !UNITY_EDITOR
        bool result = _isScanning();
  
#endif
#if UNITY_ANDROID && !UNITY_EDITOR
        bool result = PluginInstance.Call<bool>("_isScanning");
#endif

    }


    public void StopNodle()
    {
#if UNITY_IPHONE && !UNITY_EDITOR
        _stop();
#endif
#if UNITY_ANDROID && !UNITY_EDITOR 
        PluginInstance.Call("_stop");
#endif
    }

    public void callBack(string msg) {

        if (textDebug)
            textDebug.text+='\n' + msg;

        if (goSendEvents)
            goSendEvents.SendMessage(goSendEventsMethod, NodleEvent.CreateFromJSON(msg));

        Debug.Log("############################ Message " + msg);
    
    }
  
    
    public void Init()
    {
#if UNITY_IPHONE && !UNITY_EDITOR 
        if (!goSendEvents) goSendEvents = this.gameObject;

                _initPlugin(this.name, "callBack");
#endif
#if UNITY_ANDROID && !UNITY_EDITOR 
        if (!goSendEvents) goSendEvents = this.gameObject;

            PluginInstance.Call<int>("_initPlugin", _context);
#endif
    }
}