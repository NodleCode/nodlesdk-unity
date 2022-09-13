package com.proxy42.plugin.unity.nodle;
public interface PluginCallback {
    public void onSuccess(String message);
    public void onEvent(String message);//, String device, String  type, String rssi, byte[] bytes );
    public void onError(String errorMessage);
}