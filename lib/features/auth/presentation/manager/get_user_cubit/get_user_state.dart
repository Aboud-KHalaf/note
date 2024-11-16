part of 'get_user_cubit.dart';

@immutable
sealed class GetUserState {}

final class GetUserInitial extends GetUserState {}

final class GetUserLoading extends GetUserState {}

final class GetUserFailuer extends GetUserState {
  final String errMessage;

  GetUserFailuer({required this.errMessage});
}

final class GetUserSuccess extends GetUserState {
  final UserEntity user;

  GetUserSuccess({required this.user});
}
