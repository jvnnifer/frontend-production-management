import 'package:get/get.dart';
import 'package:jago_app/components/HomeMenuItem.dart';

class SidebarController extends GetxController {
  var isCollapsed = true.obs;
  var selectedRoute = "/home".obs;
  var menus = <HomeMenuItem>[].obs;

  void toggleSidebar() {
    isCollapsed.value = !isCollapsed.value;
  }

  void handleMenuTap(String route) {
    isCollapsed.value = true;

    if (selectedRoute.value != route) {
      selectedRoute.value = route;
      Get.toNamed(route);
    }
  }
}
