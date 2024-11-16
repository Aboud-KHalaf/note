import 'package:note/core/services/shared_preferences_services.dart';
import 'package:note/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> insertUserDataLocaly({required UserModel userModel});
  Future<UserModel> fetchLocalUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferencesService sharedPreferencesService;

  AuthLocalDataSourceImpl({required this.sharedPreferencesService});
  @override
  Future<void> insertUserDataLocaly({required UserModel userModel}) async {
    await sharedPreferencesService.saveUserDetails(
      name: userModel.name,
      email: userModel.email,
      id: userModel.id,
    );
  }

  @override
  Future<UserModel> fetchLocalUserData() async {
    String? email = await sharedPreferencesService.getUserEmail();
    String? name = await sharedPreferencesService.getUserName();
    String? id = await sharedPreferencesService.getUserId();
    UserModel data = UserModel(id: id!, name: name!, email: email!);
    return data;
  }
}
