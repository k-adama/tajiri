import 'package:tajiri_pos_mobile/app/services/app_validators.service.dart';

class LoginEntity {
  final String? email;
  final String? password;

  LoginEntity({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    AppValidatorsService.isValidEmail(email ?? "")
        ? (map['email'] = email)
        : (map['phone'] = email);
    map['password'] = password;
    return map;
  }
}
