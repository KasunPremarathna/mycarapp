# ProGuard/R8 rules to handle missing classes from optional dependencies
-dontwarn com.fasterxml.jackson.**
-dontwarn com.google.auto.value.**
-dontwarn io.opentelemetry.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
-dontwarn com.google.errorprone.annotations.**

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# OneSignal
-keep class com.onesignal.** { *; }
-dontwarn com.onesignal.**

# Flutter and related
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugins.** { *; }

# Play Core and Internal GMS (Fix for R8 failure)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.internal.**
-dontwarn com.google.firebase.messaging.cpp.RegistrationIntentService
-dontwarn com.google.firebase.messaging.cpp.ListenerService
-dontwarn com.google.firebase.messaging.cpp.MessageForwardingService
-dontwarn com.google.firebase.auth.api.internal.**
