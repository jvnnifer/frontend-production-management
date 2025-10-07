import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jago_app/components/TextFieldCreate.dart';
import 'package:jago_app/components/dropdown/DropdownWidget.dart';
import 'package:jago_app/controller/AuthController.dart';

class Register extends StatelessWidget {
  Register({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(25),
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
              Text(
                'Register',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              SizedBox(height: 40),

              // Username
              Text("Username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 5),
              TextFieldCreate(
                name: 'Username',
                onChanged: (value) => controller.username.value = value,
              ),
              SizedBox(height: 20),

              // Password
              Text("Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 5),
              TextFieldCreate(
                name: 'Password',
                onChanged: (value) => controller.password.value = value,
                obscureText: true,
              ),
              SizedBox(height: 20),
              Text("Role",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 5),
              Obx(
                () => DropdownWidget(
                  label: "",
                  items: controller.roles
                      .map((role) => role['roleName'] as String)
                      .toList(),
                  initialValue: controller.selectedRoleId.value.isEmpty
                      ? null
                      : controller.roles.firstWhere(
                          (r) => r['id'] == controller.selectedRoleId.value,
                        )['roleName'],
                  onChanged: (value) {
                    if (value != null) {
                      final selected = controller.roles
                          .firstWhere((r) => r['roleName'] == value);
                      controller.selectedRoleId.value = selected['id'];
                    }
                  },
                ),
              ),

              SizedBox(height: 50),

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
                              controller.register();
                            },
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : const Text("Register"),
                    ),
                  )),
              SizedBox(height: 10),

              Align(
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    text: "Sudah punya akun? ",
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Color(0xFF80CBC4),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed('/login');
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
