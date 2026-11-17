import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/umkm_controller.dart';
import '../models/umkm_model.dart';

class UmkmView extends StatelessWidget {
  UmkmView({super.key});

  final UmkmController controller = Get.put(UmkmController());

  // Color Palette Biru - Hijau (Ocean Blue & Emerald Teal)
  final Color primaryBlue = const Color(0xFF0284C7);
  final Color primaryTeal = const Color(0xFF0D9488);
  final Color accentMint = const Color(0xFFCCFBF1);
  final Color bgSurface = const Color(0xFFF0FDFA);
  final Color darkSlate = const Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSurface,
      body: Column(
        children: [
          // 1. Header Gradasi Biru-Hijau & Ringkasan Data
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBlue, primaryTeal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryTeal.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Direktori UMKM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Kelola data usaha mikro, kecil & menengah',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => controller.fetchUmkm(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: const EdgeInsets.all(12),
                      ),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                      ),
                      tooltip: 'Refresh Data',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Kartu Statistik Cepat
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.storefront_rounded,
                            color: primaryTeal,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total UMKM Terdaftar',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '${controller.umkmList.length} Unit Usaha',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Daftar Kartu UMKM
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: primaryTeal),
                );
              }

              if (controller.umkmList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store_mall_directory_outlined,
                        size: 72,
                        color: primaryTeal.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada data UMKM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: darkSlate.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Klik tombol "+ Tambah UMKM" di kanan bawah',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                itemCount: controller.umkmList.length,
                itemBuilder: (context, index) {
                  final umkm = controller.umkmList[index];
                  return _buildUmkmCard(context, umkm);
                },
              );
            }),
          ),
        ],
      ),

      // 3. Tombol Tambah Data (Floating Action Button Gradasi)
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [primaryBlue, primaryTeal]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryTeal.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showFormDialog(context, null),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add_business_rounded, color: Colors.white),
          label: const Text(
            'Tambah UMKM',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // Widget Kartu Item UMKM
  Widget _buildUmkmCard(BuildContext context, Umkm umkm) {
    final kategori = (umkm.kategori != null && umkm.kategori!.isNotEmpty)
        ? umkm.kategori!
        : 'Umum';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryTeal.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris Atas: Avatar Inisial, Nama UMKM, Badge Kategori & Tombol Aksi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryBlue.withOpacity(0.85), primaryTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    umkm.namaUmkm.isNotEmpty
                        ? umkm.namaUmkm[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        umkm.namaUmkm,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: darkSlate,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: accentMint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          kategori,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: primaryTeal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Edit & Delete
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _showFormDialog(context, umkm),
                      style: IconButton.styleFrom(
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: Icon(
                        Icons.edit_rounded,
                        size: 18,
                        color: primaryBlue,
                      ),
                      tooltip: 'Edit UMKM',
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      onPressed: () => _confirmDelete(context, umkm),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.1),
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                      tooltip: 'Hapus UMKM',
                    ),
                  ],
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, thickness: 0.8),
            ),
            // Informasi Detail: Pemilik, Alamat, Kontak
            _buildInfoRow(
              Icons.person_outline_rounded,
              'Pemilik',
              umkm.pemilik,
            ),
            const SizedBox(height: 6),
            _buildInfoRow(Icons.location_on_outlined, 'Alamat', umkm.alamat),
            const SizedBox(height: 6),
            _buildInfoRow(Icons.phone_outlined, 'Kontak', umkm.kontak),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    final displayValue = (value != null && value.isNotEmpty) ? value : '-';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: primaryTeal),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            displayValue,
            style: TextStyle(
              fontSize: 13,
              color: darkSlate,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Dialog Modal Form Tambah / Edit UMKM
  void _showFormDialog(BuildContext context, Umkm? umkm) {
    final isEdit = umkm != null;
    final namaC = TextEditingController(text: umkm?.namaUmkm ?? '');
    final pemilikC = TextEditingController(text: umkm?.pemilik ?? '');
    final kategoriC = TextEditingController(text: umkm?.kategori ?? '');
    final alamatC = TextEditingController(text: umkm?.alamat ?? '');
    final kontakC = TextEditingController(text: umkm?.kontak ?? '');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Form
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryBlue, primaryTeal],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isEdit
                            ? Icons.edit_note_rounded
                            : Icons.add_business_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEdit ? 'Edit Data UMKM' : 'Tambah UMKM Baru',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: darkSlate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(namaC, 'Nama UMKM *', Icons.storefront_rounded),
                const SizedBox(height: 12),
                _buildTextField(
                  pemilikC,
                  'Nama Pemilik',
                  Icons.person_outline_rounded,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  kategoriC,
                  'Kategori (Kuliner / Kerajinan / Jasa)',
                  Icons.category_outlined,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  alamatC,
                  'Alamat Lengkap',
                  Icons.location_on_outlined,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  kontakC,
                  'Nomor Kontak / HP',
                  Icons.phone_outlined,
                ),
                const SizedBox(height: 24),
                // Tombol Batal & Simpan
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Batal',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (namaC.text.trim().length < 3) {
                          Get.snackbar(
                            'Validasi Gagal',
                            'Nama UMKM wajib diisi minimal 3 karakter',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        final dataUmkm = Umkm(
                          id: umkm?.id,
                          namaUmkm: namaC.text.trim(),
                          pemilik: pemilikC.text.trim(),
                          kategori: kategoriC.text.trim(),
                          alamat: alamatC.text.trim(),
                          kontak: kontakC.text.trim(),
                        );

                        bool success;
                        if (isEdit) {
                          success = await controller.updateUmkm(
                            umkm.id!,
                            dataUmkm,
                          );
                        } else {
                          success = await controller.addUmkm(dataUmkm);
                        }

                        if (success) {
                          Get.back();
                          Get.snackbar(
                            'Berhasil',
                            isEdit
                                ? 'Data UMKM berhasil diperbarui'
                                : 'Data UMKM baru berhasil ditambahkan',
                            backgroundColor: primaryTeal,
                            colorText: Colors.white,
                          );
                        } else {
                          Get.snackbar(
                            'Gagal',
                            'Terjadi kesalahan saat menyimpan data UMKM',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Data'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryTeal, size: 20),
        filled: true,
        fillColor: bgSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryTeal.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryTeal.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primaryBlue, width: 1.8),
        ),
      ),
    );
  }

  // Dialog Konfirmasi Hapus
  void _confirmDelete(BuildContext context, Umkm umkm) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Hapus UMKM', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${umkm.namaUmkm}" dari daftar UMKM?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final success = await controller.deleteUmkm(umkm.id!);
              Get.back();
              if (success) {
                Get.snackbar(
                  'Terhapus',
                  'Data "${umkm.namaUmkm}" berhasil dihapus',
                  backgroundColor: primaryTeal,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }
}
