import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Prodify/components/TextFieldCreate.dart';
import 'package:Prodify/controller/AuthController.dart';

class Login extends StatelessWidget {
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  "lib/images/login-photo.png",
                  width: 300,
                  height: 300,
                ),
              ),
              const Text(
                'Login',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Username',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              TextFieldCreate(
                name: 'Username',
                onChanged: (value) => controller.username.value = value,
              ),
              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 5),
              TextFieldCreate(
                name: 'Password',
                onChanged: (value) => controller.password.value = value,
                obscureText: true,
              ),
              const SizedBox(height: 50),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF80CBC4),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              controller.login();
                            },
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text("Login"),
                    ),
                  )),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    text: "Belum memiliki akun? ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Register",
                        style: const TextStyle(
                          color: Color(0xFF80CBC4),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/register');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
