using System.Collections;
using System.Collections.Generic;
using UnityEngine;
class AndroidPluginCallback : AndroidJavaProxy
{
    GameObject goSendMessage;

    public AndroidPluginCallback(GameObject goSendMessage) : base("com.proxy42.plugin.unity.nodle.PluginCallback") { this.goSendMessage = goSendMessage; }

    public void onSuccess(string message)
    {
        Debug.Log("ENTER callback onSuccess: " + message);
        Dispatcher.RunOnMainThread(() => 
        goSendMessage.SendMessage("callBack", message));
    }
    public void onEvent(string message)//, string device, string type, string rssi)
    {
        Debug.Log("ENTER callback onEvent: " + message);

        /*NodleEvent nodleEvent = new NodleEvent();
        nodleEvent.type = type;
        nodleEvent.rssi = rssi;
        nodleEvent.device = device;
        nodleEvent.message = message;
       */
        Dispatcher.RunOnMainThread(() =>
        goSendMessage.SendMessage("callBack", message));

    }



    public void onError(string errorMessage)
    {
        goSendMessage.SendMessage(errorMessage);
        Dispatcher.RunOnMainThread(() =>
     Debug.Log("ENTER callback onError: " + errorMessage));
    }

   
}