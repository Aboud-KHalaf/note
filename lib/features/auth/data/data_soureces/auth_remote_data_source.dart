import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/helpers/providers/supabase_provider.dart';
import 'package:note/core/secrets/supabase_secrets.dart';
import 'package:note/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Session? get currentUserSisstion;

  Future<bool> get isUserLoggedIn;

  //

  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  //

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  //

  Future<UserModel?> getUserData();

  //

  Future<Unit> googleSignIn();

  //

  Future<Unit> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  //

  @override
  Session? get currentUserSisstion => supabaseClient.auth.currentSession;

  //

  @override
  Future<UserModel?> getUserData() async {
    try {
      if (currentUserSisstion != null) {
        final userData = await supabaseClient
            .from(SupabaseProvider.profilesTable)
            .select()
            .eq(SupabaseProvider.idFiled, currentUserSisstion!.user.id);

        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSisstion!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  ///

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _handleAuth(
      authAction: () => supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      ),
    );
  }

  ///

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _handleAuth(
      authAction: () => supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      ),
    );
  }

  ///

  Future<UserModel> _handleAuth({
    required Future<AuthResponse> Function() authAction,
  }) async {
    try {
      final response = await authAction();

      if (response.user == null) {
        throw const UserNotFoundFailure();
      }

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<bool> get isUserLoggedIn async {
    final user = supabaseClient.auth.currentUser;
    return user != null;
  }

  @override
  Future<Unit> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: SupabaseSecrets.iosClientId,
        serverClientId: SupabaseSecrets.webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const ServerException('No Access Token found.');
      }
      if (idToken == null) {
        throw const ServerException('No ID Token found.');
      }

      supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return unit;
    } on AuthException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<Unit> signOut() async {
    try {
      await supabaseClient.auth.signOut();

      return unit;
    } on AuthException catch (e) {
      throw ServerException(e.toString());
    } catch (e) {
      throw const UnknownFailure();
    }
  }
}
