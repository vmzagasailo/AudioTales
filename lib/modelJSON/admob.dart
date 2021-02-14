import 'dart:io';

import 'package:audiotales/widgets/audioTales/audio_tale_details.dart';
import 'package:firebase_admob/firebase_admob.dart';

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-8323348147242911~4635001279';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-8323348147242911~5935446980';
  }
  return null;
}

//load admob

 const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: testDevice != null ? <String>[testDevice] : null,
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  childDirected: true,
  nonPersonalizedAds: true,
);

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-8323348147242911/1981679824';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-5790875057771465/4761727113';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-8323348147242911/5393654684';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-5790875057771465/5745288685';
  }
  return null;
}


