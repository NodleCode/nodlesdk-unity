using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;




#if UNITY_ANDROID
using UnityEngine.Android;
#endif

public class SamplePermissionsMobile: MonoBehaviour
{


#if UNITY_IOS
    [SerializeField]
    private string SendEvents = "";


    [SerializeField]
    private string PermissionsEvents = "";
#endif
    private bool Initiated = false;


#if UNITY_IOS
    [DllImport("__Internal")]
    private static extern int _RequestPermissionsBluetooth();

    [DllImport("__Internal")]
    private static extern int _RequestPermissionsLocation();

    [DllImport("__Internal")]
    private static extern int _InitPermissionsPlugin(string sendEvents, string permissionsEvents);

#endif

    internal void PermissionCallbacks_PermissionDeniedAndDontAskAgain(string permissionName)
    {
        Debug.Log($"{permissionName} PermissionDeniedAndDontAskAgain");
    }

    internal void PermissionCallbacks_PermissionGranted(string permissionName)
    {
        Debug.Log($"{permissionName} PermissionCallbacks_PermissionGranted");
    }

    internal void PermissionCallbacks_PermissionDenied(string permissionName)
    {
        Debug.Log($"{permissionName} PermissionCallbacks_PermissionDenied");
    }


    public void RequestInit() {
        if (Initiated) return;


#if UNITY_IPHONE
        _InitPermissionsPlugin(SendEvents, PermissionsEvents);
        Initiated = true;
#endif
#if UNITY_ANDROID
        Initiated = true;
#endif

    }
    public void RequestBluetooth()
    {
        RequestInit();
#if UNITY_IPHONE
        _RequestPermissionsBluetooth();
#endif

#if UNITY_ANDROID
        requestPermission("android.permission.BLUETOOTH", "requested_bluetooth");
        requestPermission("android.permission.BLUETOOTH_ADMIN", "requested_bluetooth");
        requestPermission("android.permission.BLUETOOTH_SCAN", "requested_bluetooth");
        requestPermission("android.permission.BLUETOOTH_ADVERTISE", "requested_bluetooth");
        requestPermission("android.permission.BLUETOOTH_CONNECT", "requested_bluetooth");
#endif

    }

    public void RequestLocation()
    {
        RequestInit();
#if UNITY_IPHONE
        _RequestPermissionsLocation();
#endif
#if UNITY_ANDROID
        requestPermission(Permission.CoarseLocation, "requested_location");
        requestPermission(Permission.FineLocation, "requested_location");
#endif
    }

#if UNITY_ANDROID
    private void requestPermission(string perm, string success) 
    { 

        if (Permission.HasUserAuthorizedPermission(perm))
        {
            // The user authorized use of the microphone.
            this.gameObject.SendMessage("callBack", success);
        }
        else
        {
            bool useCallbacks = false;
            if (!useCallbacks)
            {
                Permission.RequestUserPermission(perm);
            }
            else
            {
                var callbacks = new PermissionCallbacks();
                callbacks.PermissionDenied += PermissionCallbacks_PermissionDenied;
                callbacks.PermissionGranted += PermissionCallbacks_PermissionGranted;
                callbacks.PermissionDeniedAndDontAskAgain += PermissionCallbacks_PermissionDeniedAndDontAskAgain;
                Permission.RequestUserPermission(perm, callbacks);
            }
        }

    }
#endif
}