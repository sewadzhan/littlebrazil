import android.app.Application

import com.yandex.mapkit.MapKitFactory

class FlutterApplication: Application() {
  override fun onCreate() {
    super.onCreate()
    MapKitFactory.setApiKey("c4427810-f5e5-4156-9999-099a4b85ce22") // Yandex API key
  }
}