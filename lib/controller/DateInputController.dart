import 'package:get/get.dart';

class DateController extends GetxController {
  var selectedDate = "".obs;

  void setDate(String date) {
    selectedDate.value = date;
  }
}
