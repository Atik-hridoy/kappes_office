import 'package:canuck_mall/app/localization/langs/en_us.dart';
import 'package:canuck_mall/app/localization/langs/fr_FR.dart';
import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': enUSLanguages,
    'fr_FR': frFRLanguages,
  };
}
