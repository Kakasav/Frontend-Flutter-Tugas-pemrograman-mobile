import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/umkm_model.dart';

class UmkmController extends GetxController {
  // Variabel state untuk loading dan menyimpan daftar data UMKM
  var isLoading = true.obs;
  var umkmList = <Umkm>[].obs;

  // URL API Backend CI4
  // CATATAN PENTING:
  // - Jika kamu menjalankan (Run) Flutter di Web Browser (Chrome/Edge) atau Windows Desktop, biarkan 'localhost'.
  // - Jika kamu menjalankan di Emulator Android, ubah 'localhost' menjadi '10.0.2.2'.
  final String baseUrl = 'http://localhost:8080/api/umkm';

  @override
  void onInit() {
    fetchUmkm(); // Panggil data saat aplikasi pertama kali dibuka
    super.onInit();
  }

  // METHOD GET: Mengambil data UMKM dari database
  Future<void> fetchUmkm() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var data = jsonResponse['data'] as List;
        // Konversi dari JSON ke List of Umkm (Model)
        umkmList.value = data.map((e) => Umkm.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Gagal mengambil data: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Koneksi Error', 'Pastikan server CI4 menyala. Error: $e');
    } finally {
      isLoading(false);
    }
  }

  // METHOD POST: Menambahkan data UMKM baru
  Future<bool> addUmkm(Umkm umkm) async {
    try {
      final response = await http.post(Uri.parse(baseUrl), body: umkm.toJson());
      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchUmkm(); // Refresh daftar data di layar
        return true;
      }
    } catch (e) {
      print('Error POST: $e');
    }
    return false;
  }

  // METHOD PUT: Mengubah data UMKM berdasarkan ID
  Future<bool> updateUmkm(String id, Umkm umkm) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        body: umkm.toJson(), // Data yang diperbarui
      );
      if (response.statusCode == 200) {
        fetchUmkm(); // Refresh daftar data di layar
        return true;
      }
    } catch (e) {
      print('Error PUT: $e');
    }
    return false;
  }

  // METHOD DELETE: Menghapus data UMKM berdasarkan ID
  Future<bool> deleteUmkm(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        fetchUmkm(); // Refresh daftar data di layar
        return true;
      }
    } catch (e) {
      print('Error DELETE: $e');
    }
    return false;
  }
}
