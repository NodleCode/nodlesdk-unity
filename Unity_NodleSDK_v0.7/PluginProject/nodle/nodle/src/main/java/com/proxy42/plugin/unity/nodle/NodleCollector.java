package com.proxy42.plugin.unity.nodle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.gson.FieldNamingPolicy;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.json.JSONException;
import org.json.JSONObject;

import io.nodle.sdk.NodleEvent;
import io.nodle.sdk.core.actions.events.NodleBluetoothRecord;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlinx.coroutines.flow.FlowCollector;

public class NodleCollector implements FlowCollector<NodleEvent> {

    private PluginCallback _javaCallback;

    NodleCollector(PluginCallback javaCallback) {
        _javaCallback=javaCallback;
    }

    @Nullable
    @Override
    public Object emit(NodleEvent nodleEvent, @NonNull Continuation<? super Unit> continuation) {
        NodleBluetoothRecord payload;
        switch (nodleEvent.getType()) {
            case BlePayloadEvent:
                payload = (NodleBluetoothRecord) nodleEvent;
                System.out.println("Bluetooth payload available-s: " + payload.getDevice());
                _javaCallback.onSuccess(toJSON(payload));
                break;
            case BleStartSearching:
                System.out.println("Bluetooth started searching");
                _javaCallback.onSuccess(toJSON(nodleEvent));
                break;
            case BleStopSearching:
                System.out.println("Bluetooth stop searching");
                _javaCallback.onSuccess(toJSON(nodleEvent));
                break;
        }
        return nodleEvent;
    }
    private String toJSON(NodleEvent nodleEvent) {
        JSONObject jsonObject= new JSONObject();
        try {
            jsonObject.put("type_id", nodleEvent.getType().getId());
            jsonObject.put("type_name", nodleEvent.getType().name());

            return jsonObject.toString();
        } catch (JSONException e) {
            e.printStackTrace();
            return "";
        }

    }
    private String toJSON(NodleBluetoothRecord payload) {

        JSONObject jsonObject= new JSONObject();
            try {
                jsonObject.put("device", payload.getDevice());
                jsonObject.put("bytes", payload.getBytes());
                jsonObject.put("rssi", payload.getRssi());
                jsonObject.put("type_id", payload.getType().getId());
                jsonObject.put("type_name", payload.getType().name());

                return jsonObject.toString();
            } catch (JSONException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
                return "";
            }

    }
}