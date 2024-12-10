package com.bedict.bedict

import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

// COMPLETE: Import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)

    }

    override fun onPostResume() {
       super.onPostResume() 
       WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
