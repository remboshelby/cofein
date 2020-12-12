package sber.hackathon.cofein

import androidx.annotation.NonNull
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("73d7d42a-5ca8-47a6-b61b-38bcd7fff2a9")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}
