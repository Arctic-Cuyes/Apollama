import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:provider/provider.dart';
import 'package:zona_hub/src/providers/filters_provider.dart';
import '../firebase_options.dart';
import 'package:zona_hub/src/app.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kReleaseMode || kProfileMode) {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
    }
  }

  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider (create: (context) => FilterProvider(),),
        //ThemeMode provider
      ],
      child: MyApp()
    )
  );
}
