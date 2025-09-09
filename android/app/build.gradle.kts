plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.project_plant_app"
    compileSdk = 36 // 33–34 ปลอดภัยกว่า 36 ที่อาจยังไม่เสถียร

    defaultConfig {
        applicationId = "com.example.project_plant_app"
        minSdk = 23
        targetSdk = 33
        versionCode = 1
        versionName = "1.0.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = "11" }

    buildTypes {
        getByName("release") {
            // ชั่วคราวเพื่อให้ build ผ่าน
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter { source = "../.." }
