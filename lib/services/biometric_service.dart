import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication auth =
      LocalAuthentication();

  static Future<bool> authenticate() async {
    try {
      bool canCheck =
          await auth.canCheckBiometrics;

      bool isSupported =
          await auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        return false;
      }

      return await auth.authenticate(
        localizedReason:
            'Login menggunakan sidik jari',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}