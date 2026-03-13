# ==============================================================
# Flutter - قواعد أساسية لا يمكن إزالتها
# ==============================================================
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-dontwarn io.flutter.embedding.**

# ==============================================================
# Firebase Core + Auth + Google Sign-In
# ==============================================================
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep class com.google.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# ==============================================================
# Facebook Auth
# ==============================================================
-keep class com.facebook.** { *; }
-keep interface com.facebook.** { *; }
-keep enum com.facebook.** { *; }
-dontwarn com.facebook.**

# ==============================================================
# Dio / OkHttp / Retrofit
# ==============================================================
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ==============================================================
# Gson / JSON Serialization (flutter_json_annotation / freezed)
# ==============================================================
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# ==============================================================
# Keep all model classes (Freezed / JSON)
# data classes, DTOs
# ==============================================================
-keep class com.kareem.lms.** { *; }
-keep class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ==============================================================
# flutter_secure_storage
# ==============================================================
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.it_nomads.fluttersecurestorage.**

# ==============================================================
# shared_preferences
# ==============================================================
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ==============================================================
# WebView (webview_flutter)
# ==============================================================
-keep class com.pichillilorenzo.** { *; }
-dontwarn com.pichillilorenzo.**

# ==============================================================
# video_player / chewie / ExoPlayer
# ==============================================================
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# ==============================================================
# youtube_player_flutter
# ==============================================================
-keep class com.pierfrancescosoffritti.androidyoutubeplayer.** { *; }
-dontwarn com.pierfrancescosoffritti.**

# ==============================================================
# url_launcher
# ==============================================================
-keep class io.flutter.plugins.urllauncher.** { *; }

# ==============================================================
# device_info_plus
# ==============================================================
-keep class dev.fluttercommunity.plus.device_info.** { *; }

# ==============================================================
# flutter_svg
# ==============================================================
-keep class com.caverock.androidsvg.** { *; }
-dontwarn com.caverock.androidsvg.**

# ==============================================================
# Kotlin Coroutines
# ==============================================================
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}
-dontwarn kotlinx.coroutines.**

# ==============================================================
# AndroidX
# ==============================================================
-keep class androidx.lifecycle.** { *; }
-keep class androidx.browser.** { *; }
-dontwarn androidx.browser.**

# ==============================================================
# GetIt (Service Locator) - يعمل بـ Reflection
# ==============================================================
-keep class ** implements com.google.inject.** { *; }
-keepattributes *Annotation*

# ==============================================================
# عام - الحفاظ على كل الـ Enums
# ==============================================================
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ==============================================================
# عام - الحفاظ على Serializable
# ==============================================================
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# ==============================================================
# عام - الحفاظ على native methods
# ==============================================================
-keepclasseswithmembernames class * {
    native <methods>;
}

# ==============================================================
# تجنب تحذيرات غير ضرورية
# ==============================================================
-dontwarn sun.misc.**
-dontwarn java.lang.invoke.**
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
