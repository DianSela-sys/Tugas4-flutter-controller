import 'package:flute/model/user_model.dart';
import 'package:flute/repositories/firestore_repository.dart';
import 'package:get/get.dart';

class EditUserController extends GetxController {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();
  var isLoading = false.obs;

  /// Fungsi untuk memperbarui data pengguna
  Future<void> updateUser(User user, String name, String email) async {
    isLoading.value = true;
    try {
      // Memperbarui data di Firestore dengan mengirimkan id dan data baru
      await _firestoreRepository.updateUser(user.id, {
        'name': name,
        'email': email,
      });
      Get.snackbar("Berhasil", "Data berhasil diperbarui!");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui data: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
