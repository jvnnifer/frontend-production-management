import 'package:get/get.dart';
import 'package:jago_app/api_services/ApiService.dart';

class DashboardController extends GetxController {
  var prepOrdersYearly = <int, int>{}.obs;
  var prepOrdersMonthly = <int, int>{}.obs;

  final ApiService api = ApiService();

  Future<void> loadPreparationOrderStats() async {
    int currentYear = DateTime.now().year;

    prepOrdersYearly.value = await api.getPreparationOrderPerYear();
    prepOrdersMonthly.value =
        await api.getPreparationOrderPerMonth(currentYear);
  }
}
