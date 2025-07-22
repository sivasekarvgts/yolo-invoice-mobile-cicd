import 'dart:io';
import '../../locator.dart';

class AppConfig {
  String? appName;
  String? baseApiUrl;
  String? organizationApiUrl;
  String? oneSignal;
  Sentry? sentry;
  MixPanel? mixPanel;
  Dashboard? dashboard;
  AppUrl? appUrl;
  String? accountUrl;
  AppUpdate? appUpdate;
  OtherLinks? otherLinks;
  TestFlight? testFlight;
  ApiVersioningVersions? apiVersioningVersions;
  AppMaintenance? appMaintenance;

  AppConfig({required this.appName, required this.baseApiUrl});

  AppConfig.fromJson(Map<String, dynamic> json) {
    appName = json['AppName'];
    baseApiUrl = json['BaseApiUrl'];
    organizationApiUrl = json['OrganizationApiUrl'];
    oneSignal = json['oneSignal'];
    accountUrl = json['AccountUrl'];
    sentry = json['Sentry'] != null ? new Sentry.fromJson(json['Sentry']) : null;
    mixPanel = json['MixPanel'] != null ? new MixPanel.fromJson(json['MixPanel']) : null;
    dashboard = json['Dashboard'] != null ? new Dashboard.fromJson(json['Dashboard']) : null;
    appUrl = json['AppUrl'] != null ? new AppUrl.fromJson(json['AppUrl']) : null;
    appUpdate = json['AppUpdate'] != null ? new AppUpdate.fromJson(json['AppUpdate']) : null;
    otherLinks = json['OtherLinks'] != null ? new OtherLinks.fromJson(json['OtherLinks']) : null;
    testFlight = json['TestFlight'] != null ? new TestFlight.fromJson(json['TestFlight']) : null;
    apiVersioningVersions = json['ApiVersioningVersions'] != null ? new ApiVersioningVersions.fromJson(json['ApiVersioningVersions']) : null;
    if (apiVersioningVersions != null) {
      String? latestAppVersion = Platform.isIOS ? apiVersioningVersions?.showVersionsAndBelow : apiVersioningVersions?.showVersionsAndBelow;
      if (latestAppVersion != null) {
        if (appConfigService.appVersion.replaceAll(".", "") != latestAppVersion.replaceAll(".", "")) {
          baseApiUrl = apiVersioningVersions?.baseApiUrl ?? json['BaseApiUrl'];
        }
      }
    }

    if (testFlight != null) {
      String? appVersion = Platform.isIOS ? testFlight?.iOSAppVersion : testFlight?.androidAppVersion;
      if (appVersion != null) {
        if (appConfigService.appVersion.replaceAll(".", "") == appVersion.replaceAll(".", "")) {
          baseApiUrl = testFlight?.baseURL ?? json['BaseApiUrl'];
        }
      }
    }
    appMaintenance = json['App_Maintenance'] != null ? new AppMaintenance.fromJson(json['App_Maintenance']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AppName'] = this.appName;
    data['BaseApiUrl'] = this.baseApiUrl;
    data['oneSignal'] = this.oneSignal;
    if (this.sentry != null) {
      data['Sentry'] = this.sentry!.toJson();
    }
    if (this.mixPanel != null) {
      data['MixPanel'] = this.mixPanel!.toJson();
    }
    if (this.dashboard != null) {
      data['Dashboard'] = this.dashboard!.toJson();
    }
    if (this.appUrl != null) {
      data['AppUrl'] = this.appUrl!.toJson();
    }
    if (this.appUpdate != null) {
      data['AppUpdate'] = this.appUpdate!.toJson();
    }
    if (this.otherLinks != null) {
      data['OtherLinks'] = this.otherLinks!.toJson();
    }
    if (this.testFlight != null) {
      data['TestFlight'] = this.testFlight!.toJson();
    }
    if (this.apiVersioningVersions != null) {
      data['ApiVersioningVersions'] = this.apiVersioningVersions!.toJson();
    }
    if (this.appMaintenance != null) {
      data['App_Maintenance'] = this.appMaintenance!.toJson();
    }
    return data;
  }
}

class Sentry {
  String? devdsn;
  String? dsn;

  Sentry({this.devdsn, this.dsn});

  Sentry.fromJson(Map<String, dynamic> json) {
    devdsn = json['devdsn'];
    dsn = json['dsn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['devdsn'] = this.devdsn;
    data['dsn'] = this.dsn;
    return data;
  }
}

class MixPanel {
  String? mixPanelProdkey;
  String? mixPanelDevkey;

  MixPanel({this.mixPanelProdkey, this.mixPanelDevkey});

  MixPanel.fromJson(Map<String, dynamic> json) {
    mixPanelProdkey = json['mixPanelProdkey'];
    mixPanelDevkey = json['mixPanelDevkey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mixPanelProdkey'] = this.mixPanelProdkey;
    data['mixPanelDevkey'] = this.mixPanelDevkey;
    return data;
  }
}

class Dashboard {
  List<Elements>? elements;

  Dashboard({this.elements});

  Dashboard.fromJson(Map<String, dynamic> json) {
    if (json['Elements'] != null) {
      elements = <Elements>[];
      json['Elements'].forEach((v) {
        elements!.add(new Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.elements != null) {
      data['Elements'] = this.elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Elements {
  String? name;
  bool? hide;

  Elements({this.name, this.hide});

  Elements.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    hide = json['Hide'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Hide'] = this.hide;
    return data;
  }
}

class AppUrl {
  String? terms;
  String? privacy;
  String? refundPolicy;
  String? contactEmail;
  String? contactPhone;

  AppUrl({this.terms, this.privacy, this.refundPolicy, this.contactEmail, this.contactPhone});

  AppUrl.fromJson(Map<String, dynamic> json) {
    terms = json['terms'];
    privacy = json['privacy'];
    refundPolicy = json['refund_policy'];
    contactEmail = json['contact_email'];
    contactPhone = json['contact_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terms'] = this.terms;
    data['privacy'] = this.privacy;
    data['refund_policy'] = this.refundPolicy;
    data['contact_email'] = this.contactEmail;
    data['contact_phone'] = this.contactPhone;
    return data;
  }
}

class AppUpdate {
  AppUpdateDetails? android;
  AppUpdateDetails? iOS;

  AppUpdate({this.android, this.iOS});

  AppUpdate.fromJson(Map<String, dynamic> json) {
    android = json['Android'] != null ? AppUpdateDetails.fromJson(json['Android']) : null;
    iOS = json['IOS'] != null ? AppUpdateDetails.fromJson(json['IOS']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.android != null) {
      data['Android'] = this.android!.toJson();
    }
    if (this.iOS != null) {
      data['IOS'] = this.iOS!.toJson();
    }
    return data;
  }
}

class AppUpdateDetails {
  String? url;
  String? showVersionAndBelow;
  String? imageLink;
  String? updateMessage;

  AppUpdateDetails({this.url, this.showVersionAndBelow, this.imageLink, this.updateMessage});

  AppUpdateDetails.fromJson(Map<String, dynamic> json) {
    url = json['Url'];
    showVersionAndBelow = json['ShowVersionAndBelow'];
    imageLink = json['ImageLink'];
    updateMessage = json['UpdateMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Url'] = this.url;
    data['ShowVersionAndBelow'] = this.showVersionAndBelow;
    data['ImageLink'] = this.imageLink;
    data['UpdateMessage'] = this.updateMessage;
    return data;
  }
}

class OtherLinks {
  String? websiteLINK;
  String? termsAndCondition;
  String? privacyPolicy;

  OtherLinks({this.websiteLINK});

  OtherLinks.fromJson(Map<String, dynamic> json) {
    websiteLINK = json['WebsiteLINK'];
    termsAndCondition = json['TermsAndConditions'];
    privacyPolicy = json['PrivacyPolicy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['WebsiteLINK'] = this.websiteLINK;
    data['TermsAndConditions'] = termsAndCondition;
    data['PrivacyPolicy'] = privacyPolicy;
    return data;
  }
}

class TestFlight {
  String? baseURL;
  String? baseUrlWeb;
  String? iOSAppVersion;
  String? androidAppVersion;

  TestFlight({this.baseURL, this.baseUrlWeb, this.iOSAppVersion, this.androidAppVersion});

  TestFlight.fromJson(Map<String, dynamic> json) {
    baseURL = json['BaseURL'];
    baseUrlWeb = json['BaseUrlWeb'];
    iOSAppVersion = json['IOSAppVersion'];
    androidAppVersion = json['AndroidAppVersion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BaseURL'] = this.baseURL;
    data['BaseUrlWeb'] = this.baseUrlWeb;
    data['IOSAppVersion'] = this.iOSAppVersion;
    data['AndroidAppVersion'] = this.androidAppVersion;
    return data;
  }
}

class ApiVersioningVersions {
  String? showVersionsAndBelow;
  String? baseApiUrl;

  ApiVersioningVersions({this.showVersionsAndBelow, this.baseApiUrl});

  ApiVersioningVersions.fromJson(Map<String, dynamic> json) {
    showVersionsAndBelow = json['ShowVersionsAndBelow'];
    baseApiUrl = json['BaseApiUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShowVersionsAndBelow'] = this.showVersionsAndBelow;
    data['BaseApiUrl'] = this.baseApiUrl;
    return data;
  }
}

class AppMaintenance {
  bool? enableMaintenanceOnIos;
  bool? enableMaintenanceOnAndroid;
  String? serverDownMaintenanceLink;
  String? customMaintenanceLink;
  String? showVersionAndBelow;
  String? imageLink;
  String? updateMessage;
  bool? showButton;
  String? externalUrl;

  AppMaintenance(
      {this.enableMaintenanceOnIos, this.enableMaintenanceOnAndroid, this.serverDownMaintenanceLink, this.customMaintenanceLink, this.showVersionAndBelow, this.imageLink, this.updateMessage, this.showButton, this.externalUrl});

  AppMaintenance.fromJson(Map<String, dynamic> json) {
    enableMaintenanceOnIos = json['EnableMaintenanceOnIos'];
    enableMaintenanceOnAndroid = json['EnableMaintenanceOnAndroid'];
    serverDownMaintenanceLink = json['ServerDownMaintenanceLink'];
    customMaintenanceLink = json['CustomMaintenanceLink'];
    showVersionAndBelow = json['ShowVersionAndBelow'];
    imageLink = json['ImageLink'];
    updateMessage = json['UpdateMessage'];
    showButton = json['show_button'];
    externalUrl = json['external_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EnableMaintenanceOnIos'] = this.enableMaintenanceOnIos;
    data['EnableMaintenanceOnAndroid'] = this.enableMaintenanceOnAndroid;
    data['ServerDownMaintenanceLink'] = this.serverDownMaintenanceLink;
    data['CustomMaintenanceLink'] = this.customMaintenanceLink;
    data['ShowVersionAndBelow'] = this.showVersionAndBelow;
    data['ImageLink'] = this.imageLink;
    data['UpdateMessage'] = this.updateMessage;
    data['show_button'] = this.showButton;
    data['external_url'] = this.externalUrl;
    return data;
  }
}
