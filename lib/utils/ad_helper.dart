import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // TEST AD IDs (Replace these with Real IDs before Publishing)
  
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android Test Banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS Test Banner
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android Test Interstitial
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // iOS Test Interstitial
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  // --- Banner Ad Logic ---
  static BannerAd loadBannerAd({required Function() onLoaded}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
           if (kDebugMode) print('Banner Ad Loaded');
           onLoaded();
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) print('Banner Ad Failed to Load: $err');
          ad.dispose();
        },
      ),
    );
  }

  // --- Interstitial Ad Logic ---
  static void loadInterstitialAd({required Function(InterstitialAd) onLoaded}) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) print('Interstitial Ad Loaded');
          onLoaded(ad);
        },
        onAdFailedToLoad: (err) {
          if (kDebugMode) print('Interstitial Ad Failed to Load: $err');
        },
      ),
    );
  }
}
