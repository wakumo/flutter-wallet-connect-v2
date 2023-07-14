-keep class com.walletconnect.android.** { *; }
-keep interface com.walletconnect.** { *; }
-keep class kotlinx.coroutines.** { *; }
-keepnames class com.walletconnect.** { *; }
-keepnames interface com.walletconnect.** { *; }

-dontwarn kotlinx.coroutines.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**
-dontwarn okhttp3.internal.platform.**

-repackageclasses 'com.walletconnect'
-allowaccessmodification
-keeppackagenames doNotKeepAThing