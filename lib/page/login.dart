import 'package:caleg/page/home.dart';
import 'package:caleg/service/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    String baseKey = getBaseKey();

    final TextEditingController nomorHp = TextEditingController();
    final TextEditingController kodeOtp = TextEditingController();

    bool otpFieldVisibility = false;
    var receivedID = '';

    Future<void> getUser() async {
      loadingData();

      var request = await http.get(Uri.parse(
          "${ApiStatus.baseUrl}/api/get-user?key=$baseKey&uidKey=${auth.currentUser?.uid}&hpKey=${auth.currentUser?.phoneNumber}"));

      if (request.statusCode == 200) {
        Get.off(() => const HomePage());
      } else {
        hapusLoader();
        errorPesan("Terjadi kegagalan koneksi, silahkan ulangi kembali.");
      }
    }

    verifyUserPhoneNumber() {
      auth.verifyPhoneNumber(
        phoneNumber: "+62${nomorHp.text}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth
              .signInWithCredential(credential)
              .then((value) => getUser());
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            EasyLoading.showError('Nomor HP yang Anda masukkan tidak valid');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          receivedID = verificationId;

          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: receivedID,
            smsCode: '123123',
          );

          await auth
              .signInWithCredential(credential)
              .then((value) => getUser());

          // setState(() {
          //   otpFieldVisibility = true;
          // });
        },
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (String verificationId) {
          EasyLoading.showError('TimeOut');
        },
      );
    }

    verifyOTPCode() async {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: receivedID,
        smsCode: kodeOtp.text,
      );

      await auth
          .signInWithCredential(credential)
          .then((value) => Get.off(() => const HomePage()));
    }

    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        Get.off(() => const HomePage());
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (!otpFieldVisibility) ...[
                      const Text(
                        "MASUKKAN NOMOR HP ANDA :",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: nomorHp,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == "") {
                            return "Error";
                          }
                          return null;
                        },
                      ),
                    ],
                    if (otpFieldVisibility) ...[
                      const Text('Kode OTP'),
                      TextField(
                        controller: kodeOtp,
                        keyboardType: TextInputType.number,
                      )
                    ],
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        label: Text(otpFieldVisibility ? 'Kirim OTP' : 'LOGIN'),
                        icon: const Icon(Icons.key),
                        onPressed: () {
                          if (otpFieldVisibility) {
                            verifyOTPCode();
                          } else {
                            verifyUserPhoneNumber();
                          }
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "© 2023 MultiMAXIMA",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
