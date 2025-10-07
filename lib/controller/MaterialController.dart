import 'package:get/get.dart';
import 'package:jago_app/entity/RawMaterial.dart';

class MaterialController extends GetxController {
  var selectedMaterial = <RawMaterial>[].obs;

  void setSelectedMaterial(List<RawMaterial> material) {
    selectedMaterial.value = material;
  }

  void removeMaterial(RawMaterial material) {
    selectedMaterial.remove(material);
  }
}
