package com.follow.clash;

import android.app.Application
import android.content.Context;
import io.flutter.Log

class FlClashApplication : Application() {
    companion object {
        private lateinit var instance: FlClashApplication
        fun getAppContext(): Context {
            return instance.applicationContext
        }
    }

    override fun onCreate() {
        super.onCreate()
        Log.setLogLevel(android.util.Log.VERBOSE)
        instance = this
    }
}
