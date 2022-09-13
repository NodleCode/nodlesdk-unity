package com.proxy42.plugin.unity.nodle;
import androidx.annotation.NonNull;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.EmptyCoroutineContext;

public class NodleContinuation implements Continuation {
    @NonNull
    @Override
    public CoroutineContext getContext() {
        // pass an empty instance or one that you need
        return EmptyCoroutineContext.INSTANCE;
    }

    @Override
    public void resumeWith(@NonNull Object o) {
        // provide a base implementation if you need
    }
}