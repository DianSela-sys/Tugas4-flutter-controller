import 'package:flute/model/user_model.dart';
import 'package:flute/repositories/firestore_repository.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirestoreRepository _firestoreRepository = FirestoreRepository();

  var users = <User>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() {
    isLoading.value = true;
    _firestoreRepository.getUsers().listen(
          (snapshot) {
        users.value = snapshot.docs
            .map((doc) => User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        isLoading.value = false;
      },
      onError: (error) {
        isLoading.value = false;
        Get.snackbar("Error", "Gagal mengambil data: $error");
      },
    );
  }

  /// Fungsi untuk menghapus data pengguna
  Future<void> deleteUser(String id) async {
    try {
      await _firestoreRepository.deleteUser(id);
      Get.snackbar("Berhasil", "Data berhasil dihapus!");
      // Hapus data dari list users secara lokal
      users.removeWhere((user) => user.id == id);
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus data: $e");
    }
  }

  /// Fungsi untuk mengedit data pengguna
  Future<void> editUser(User updatedUser) async {
    try {
      // Mengirimkan dua parameter: id dan objek user yang diperbarui.
      await _firestoreRepository.updateUser(updatedUser.id, updatedUser as Map<String, dynamic>);
      Get.snackbar("Berhasil", "Data berhasil diupdate!");
      // Update data pada list users secara lokal
      int index = users.indexWhere((user) => user.id == updatedUser.id);
      if (index != -1) {
        users[index] = updatedUser;
        users.refresh();
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengupdate data: $e");
    }
  }
}
