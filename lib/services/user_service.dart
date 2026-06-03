import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class UserService {

static Future<void> saveUser(
  String username,
  String email,
  String role,
) async {

  final prefs =
      await SharedPreferences.getInstance();
      

  await prefs.setString(
    'username',
    username,
  );

  await prefs.setString(
    'email',
    email,
  );

  await prefs.setString(
    'role',
    role,
  );
}
static Future<String?> getUsername() async {


final prefs =
    await SharedPreferences.getInstance();

return prefs.getString(
  'username',
);

}

static Future<String?> getEmail() async {


final prefs =
    await SharedPreferences.getInstance();

return prefs.getString(
  'email',
);


}

static Future<String> getRole() async {


final prefs =
    await SharedPreferences.getInstance();

return prefs.getString(
      'role',
    ) ??
    'user';


}

static Future<String?> getLoggedInUser() async {

final prefs =
    await SharedPreferences.getInstance();

return prefs.getString(
  'username',
);


}

static Future<void> updateProfile({
required String username,
required String email,
}) async {


final prefs =
    await SharedPreferences.getInstance();

await prefs.setString(
  'username',
  username,
);

await prefs.setString(
  'email',
  email,
);


}

static Future<void> saveProfile(
UserProfile profile) async {


final prefs =
    await SharedPreferences.getInstance();

await prefs.setString(
  "username",
  profile.username,
);

await prefs.setString(
  "email",
  profile.email,
);

await prefs.setString(
  "phone",
  profile.phone,
);

await prefs.setString(
  "address",
  profile.address,
);


}

static Future<UserProfile?> getProfile() async {


final prefs =
    await SharedPreferences.getInstance();

return UserProfile(
  username:
      prefs.getString(
            "username",
          ) ??
          "",
  email:
      prefs.getString(
            "email",
          ) ??
          "",
  phone:
      prefs.getString(
            "phone",
          ) ??
          "",
  address:
      prefs.getString(
            "address",
          ) ??
          "",
);


}
}
