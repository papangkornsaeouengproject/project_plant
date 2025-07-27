plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ เพิ่ม Google Services Plugin
}

android {
    namespace = "com.example.project_plant_app"
    compileSdk = 36  // ✅ กำหนด SDK ให้เป็นเลขแทนที่ตัวแปร

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

   defaultConfig {
    applicationId = "com.example.project_plant_app"
    minSdk = 23               // ✅ แก้จาก 21 เป็น 23
    targetSdk = 33
    versionCode = 1
    versionName = "1.0.0"
}

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
