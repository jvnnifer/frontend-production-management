import 'package:get/get.dart';
import 'package:Prodify/api_services/ApiService.dart';

class ChartController extends GetxController {
  var monthlyData = <int, int>{}.obs;
  var yearlyData = <int, int>{}.obs;
  var selectedMode = 0.obs;
  var isLoading = false.obs;

  final api = ApiService();
  @override
  void onInit() {
    super.onInit();
    fetchMonthlyData();
  }

  void fetchMonthlyData() async {
    try {
      isLoading.value = true;
      int currentYear = DateTime.now().year;
      Map<int, int> data = await api.getPreparationOrderPerMonth(currentYear);
      monthlyData.value = data;
    } catch (e) {
      print("Error fetching chart data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchYearlyData() async {
    try {
      isLoading.value = true;
      Map<int, int> data = await api.getPreparationOrderPerYear();
      yearlyData.assignAll(data);
    } catch (e) {
      print("Error fetching yearly chart data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleMode(int index) {
    selectedMode.value = index;
    if (index == 0) {
      fetchMonthlyData();
    } else {
      fetchYearlyData();
    }
  }
}
