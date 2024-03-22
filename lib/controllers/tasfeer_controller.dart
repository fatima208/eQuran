import 'package:get/get.dart';

class TasfeerController extends GetxController{
  final name=''.obs;
  final index=0.obs;
  void updateName(String newValue, int index){
    name.value=newValue;
    this.index.value=index;

  }
}