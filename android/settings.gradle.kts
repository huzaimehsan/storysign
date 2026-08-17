pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // AGP ko 8.7.0 se 8.11.1 (ya usse upar) karein
    id("com.android.application") version "8.11.1" apply false
    // Kotlin ko 2.0.0 se 2.2.20 (ya usse upar) karein
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
