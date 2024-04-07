package kz.khan.littlebrazil

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("c4427810-f5e5-4156-9999-099a4b85ce22") // Yandex API key
        super.configureFlutterEngine(flutterEngine)
    }
}
