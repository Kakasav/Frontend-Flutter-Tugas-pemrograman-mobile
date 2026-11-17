class Umkm {
  final String? id;
  final String namaUmkm;
  final String? pemilik;
  final String? alamat;
  final String? kategori;
  final String? kontak;

  Umkm({
    this.id,
    required this.namaUmkm,
    this.pemilik,
    this.alamat,
    this.kategori,
    this.kontak,
  });

  // Mengubah JSON dari API menjadi Object Flutter
  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: json['id'].toString(), // Pastikan id terbaca sebagai String
      namaUmkm: json['nama_umkm'] ?? '',
      pemilik: json['pemilik'] ?? '',
      alamat: json['alamat'] ?? '',
      kategori: json['kategori'] ?? '',
      kontak: json['kontak'] ?? '',
    );
  }

  // Mengubah Object Flutter menjadi JSON untuk dikirim ke API
  Map<String, dynamic> toJson() {
    return {
      'nama_umkm': namaUmkm,
      'pemilik': pemilik,
      'alamat': alamat,
      'kategori': kategori,
      'kontak': kontak,
    };
  }
}
