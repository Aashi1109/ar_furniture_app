# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }

# Cloud Firestore rules
-keep class com.google.firebase.firestore.** { *; }
-dontwarn com.google.firebase.firestore.**

# Firebase Auth rules
-keep class com.google.firebase.auth.** { *; }
-dontwarn com.google.firebase.auth.**

# Firebase Core rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Firebase Storage rules
-keep class com.google.firebase.storage.** { *; }
-dontwarn com.google.firebase.storage.**

# Google Sign-In rules
-keep class com.google.android.gms.auth.** { *; }
-dontwarn com.google.android.gms.auth.**
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.common.**
-keep class com.google.android.gms.internal.** { *; }
-dontwarn com.google.android.gms.internal.**

# Image Picker rules
-keep class com.imagepicker.** { *; }
-dontwarn com.imagepicker.**

# Provider rules
-keep class com.example.provider.** { *; }
-dontwarn com.example.provider.**

# Shared Preferences rules
-keep class androidx.preference.** { *; }
-dontwarn androidx.preference.**

# Ar Flutter Plugin rules
-keep class com.difrancescogianmarco.arcore_flutter_plugin.** { *; }
-dontwarn com.difrancescogianmarco.arcore_flutter_plugin.**
