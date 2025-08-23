plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:34.1.0"))

  // Add the dependencies for Firebase products you want to use
  implementation("com.google.firebase:firebase-analytics")

  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "com.example.insta_food"
    compileSdk = flutter.compileSdkVersion

    // Pin NDK to the highest required version by plugins (backward compatible)
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.insta_food"
        // firebase_core requires at least 23
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Apply Google Services plugin only when google-services.json exists to allow
// building the app without Firebase configured in local dev.
if (file("google-services.json").exists()) {
    apply(plugin = "com.google.gms.google-services")
    println("Google Services plugin applied.")
} else {
    println("google-services.json not found; skipping Google Services plugin for this build.")
}

flutter {
    source = "../.."
}
