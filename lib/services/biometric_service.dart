import 'package:local_auth/local_auth.dart';

class BiometricService {

  static final LocalAuthentication auth =
      LocalAuthentication();

  static Future<bool> authenticate() async {

    try {

      return await auth.authenticate(
        localizedReason:
            'Scan fingerprint untuk login',
      );

    } catch (e) {

      return false;
    }
  }
}
