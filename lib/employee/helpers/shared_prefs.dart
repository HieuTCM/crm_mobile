import 'package:crm_mobile/main.dart';

String getTokenAuthenFromSharedPrefs() {
  if (sharedPreferences.getString('Token') == null) {
    return '';
  }
  return sharedPreferences.getString('Token')!;
}

int getCuctomerIDFromSharedPrefs() {
  return sharedPreferences.getInt('UserID')!;
}
