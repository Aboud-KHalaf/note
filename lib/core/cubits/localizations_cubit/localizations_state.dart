part of 'localizations_cubit.dart';

abstract class LocalizationsState {}

class LocalizationsInitial extends LocalizationsState {}

class LanguageLoaded extends LocalizationsState {
  final Locale locale;

  LanguageLoaded(this.locale);
}

class LocalizationsError extends LocalizationsState {
  final String message;

  LocalizationsError(this.message);
}
