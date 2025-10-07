import 'package:get/get.dart';

class RadioController extends GetxController {
  var selected = "".obs;

  void setSelected(String value) {
    selected.value = value;
  }
}
