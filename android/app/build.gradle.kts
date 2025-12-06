plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.section_routine"
    compileSdk = flutter.compileSdkVersion

    // FIX NDK VERSION MISMATCH
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID
        applicationId = "com.example.section_routine"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use release signing config if you have your keystore
            // signingConfig = signingConfigs.getByName("release")

            // If you don't have a release key yet, use debug (temporary)
            signingConfig = signingConfigs.getByName("debug")

            // Enable ProGuard/R8 for shrinking and obfuscating the code
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // Optional: enable view binding if needed
    buildFeatures {
        viewBinding = true
    }
}

flutter {
    source = "../.."
}
