package com.proxy42.plugin.unity.nodle;

import io.nodle.sdk.NodleEvent;
import io.nodle.sdk.NodleEventType;
import io.nodle.sdk.android.Nodle;

import android.annotation.SuppressLint;
import android.content.Context;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import kotlin.PublishedApi;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.GlobalScope;
import java.time.Instant;
import java.time.format.DateTimeFormatter;


public class NodlePlugin {
    private static final NodlePlugin ourInstance = new NodlePlugin();
    private static final String LOGTAG = "Proxy42";
    private long startTime;
    private Context _context;

    public static NodlePlugin getInstance() {
        return ourInstance;
    }

    private String _sendEvents;

    private String _key = "";

    public PluginCallback _javaCallback;

    private NodlePlugin() {
        Log.i(LOGTAG, "Created NodlePlugin");
        startTime = System.currentTimeMillis();
    }

    public double getElapsedTime() {
        return (System.currentTimeMillis() - startTime) / 1000f;
    }
    public boolean _isStarted() {
        Boolean status=Nodle.Nodle().isStarted();
        String statusMessage =toJSON("is_started", -6, "",(status ? "true": "false"));
        _javaCallback.onSuccess(statusMessage);
        return status;
    }
    public boolean _isScanning() {
        Boolean status=Nodle.Nodle().isScanning();
        String statusMessage = toJSON("is_scanning", -7, "",(status ? "true": "false"));
        _javaCallback.onSuccess(statusMessage);
        return status;
    }
    public void _stop() {
         Nodle.Nodle().stop();
        _javaCallback.onSuccess(toJSON("stop", -5,"", ""));
    }
    public void _start(String key) {
        _key = key;
        Nodle.Nodle().start(key);
        _javaCallback.onSuccess(toJSON("started", -4,"",""));
    }
    public String _getVersion() {
        String sVer=Nodle.Nodle().getVersion();
        _javaCallback.onSuccess(toJSON("version", -3,sVer,""));
        return sVer;
    }


@SuppressLint("UnsafeOptInUsageError")
public void _getEvents() {
    BuildersKt.launch(GlobalScope.INSTANCE, (CoroutineContext) Dispatchers.getMain(), CoroutineStart.DEFAULT,
            (Function2<CoroutineScope, Continuation<? super Unit>, Unit>) (coroutineScope, continuation) -> {
                // start collecting events
                Nodle.Nodle().getEvents().collect(new NodleCollector(_javaCallback), new NodleContinuation());
                return Unit.INSTANCE;
            }
    );
}
    public int _setCallback(PluginCallback callback) {
        _javaCallback = callback;
        _javaCallback.onSuccess(toJSON("callback_ready", -2,"",""));
        return 1;
    }

    public int _initPlugin(  Context context) {
        _context = context;
        Nodle.init(context);
        _javaCallback.onSuccess(toJSON("initiated", -1,"",""));
        return 1;
    }

    private String toJSON(String stringEvent, Integer typeId, String version, String status) {
        JSONObject jsonObject= new JSONObject();
        try {
            jsonObject.put("type_id", typeId);
            jsonObject.put("type_name", stringEvent);
            if (!status.equals("")) jsonObject.put("status", status);
            if (!version.equals("")) jsonObject.put("version", version);

            return jsonObject.toString();
        } catch (JSONException e) {
            e.printStackTrace();
            return "";
        }

    }
}
