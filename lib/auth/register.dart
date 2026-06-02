import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future register() async {
    // 1. Indikator pancingan untuk memastikan tombol merespons
    print("====== TOMBOL REGISTER BERHASIL DIKLIK ======");
    print("Data dikirim: ${username.text}, ${email.text}, ${password.text}");

    try {
      var url = Uri.parse("http://localhost/flutter_api/auth/register.php");

      var response = await http
          .post(
            url,
            body: {
              "username": username.text,
              "email": email.text,
              "password": password.text,
            },
          )
          .timeout(const Duration(seconds: 10)); // Batasi waktu tunggu 10 detik

      // 2. Cetak apa isi balasan mentah dari PHP Native di XAMPP
      print("Balasan mentah dari Server PHP: ${response.body}");

      var data = json.decode(response.body);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Proses selesai")),
        );
      }
    } catch (e) {
      // 3. Jika ada masalah jaringan/salah ketik PHP, dia bakal curhat di sini
      print("Terjadi Kesalahan (Error): $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal terhubung ke server: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          // Ditambah agar layar bisa di-scroll saat mengetik
          child: Column(
            children: [
              TextField(
                controller: username,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  register();
                },
                child: const Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
