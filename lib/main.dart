import 'package:flutter/material.dart';

void main() => runApp(const FormBiodataApp());

class FormBiodataApp extends StatelessWidget {
  const FormBiodataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Form Biodata',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const FormBiodataPage(),
    );
  }
}

// StatefulWidget agar tampilan (checkbox) bisa berubah lewat setState.
class FormBiodataPage extends StatefulWidget {
  const FormBiodataPage({super.key});

  @override
  State<FormBiodataPage> createState() => _FormBiodataPageState();
}

class _FormBiodataPageState extends State<FormBiodataPage> {
  // Praktikum D & E: GlobalKey untuk mengelola Form
  final _formKey = GlobalKey<FormState>();

  // Praktikum A & E: controller untuk membaca isi input
  final namaCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final hpCtrl = TextEditingController();

  // Praktikum C: pola value + onChanged
  bool setuju = false;

  // Troubleshooting: controller harus di-dispose agar tidak memory leak
  @override
  void dispose() {
    namaCtrl.dispose();
    emailCtrl.dispose();
    hpCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    // Praktikum D: panggil validate() saat submit
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Checkbox "setuju" wajib dicentang sebelum data disimpan
    if (!setuju) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui syarat & ketentuan'),
        ),
      );
      return;
    }

    // Praktikum E: umpan balik lewat SnackBar (berisi ringkasan data)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(
          'Data tersimpan!\n'
              'Nama: ${namaCtrl.text.trim()}\n'
              'Email: ${emailCtrl.text.trim()}\n'
              'No. HP: ${hpCtrl.text.trim()}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Biodata')),
      // Troubleshooting: SingleChildScrollView agar keyboard tidak menutupi input
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Nama
                  TextFormField(
                    controller: namaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // 2. Email
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!v.contains('@')) {
                        return 'Format email salah (harus mengandung @)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // 3. No. HP
                  TextFormField(
                    controller: hpCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'No. HP',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'No. HP wajib diisi';
                      }
                      final hp = v.trim();
                      if (!RegExp(r'^[0-9]+$').hasMatch(hp)) {
                        return 'No. HP hanya boleh berisi angka';
                      }
                      if (hp.length < 10) {
                        return 'No. HP minimal 10 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Checkbox "setuju syarat"
                  CheckboxListTile(
                    title: const Text('Setuju syarat & ketentuan'),
                    value: setuju,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) => setState(() => setuju = v!),
                  ),
                  const SizedBox(height: 16),

                  // Tombol Simpan
                  ElevatedButton.icon(
                    onPressed: _simpan,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}