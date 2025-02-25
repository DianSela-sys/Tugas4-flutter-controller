import 'package:flute/repositories/firestore_repository.dart';
import 'package:flute/screens/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


class AddUserController extends GetxController{
  final FirestoreRepository _firestoreRepository = FirestoreRepository();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> addUser() async {
    // User input buat nama sama email
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    if(name.isEmpty || email.isEmpty){
      Get.snackbar("Salah", "Nama atau email tidak boleh kosong!",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // buat generate user id
    String userId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await _firestoreRepository.createUser(userId, name, email);
      Get.snackbar("Success", "Data berhasil ditambahkan!");
      Get.off(() => HomeScreen());
    } catch (e) {
      Get.snackbar("Error", "Gagal menambahkan data: $e");
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}