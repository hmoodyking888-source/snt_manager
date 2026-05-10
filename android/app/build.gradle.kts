plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // حذفنا سطر google-services مؤقتاً لتجنب طلب البصمة الإجباري عند التشغيل
}

android {
    namespace = "com.sultan.stn_manager"
    compileSdk = 34 // عدنا للإصدار المستقر السابق

    defaultConfig {
        applicationId = "com.sultan.stn_manager"
        minSdk = 21
        targetSdk = 34
        versionCode = 4
        versionName = "1.0.3"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildTypes {
        getByName("release") {
            // استخدام إعدادات الديباج للتوقيع لتجنب مشاكل البصمة في Codemagic
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // تركنا المكتبات الأساسية فقط لضمان عمل الواجهات بدون انهيار
    implementation("androidx.multidex:multidex:2.0.1")
}