sealed class AppFailure {
  const AppFailure(this.message, {this.code});

  final String message;
  final String? code;
}

final class ConfigurationFailure extends AppFailure {
  const ConfigurationFailure(super.message, {super.code});
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, {super.code});
}

final class AuthenticationFailure extends AppFailure {
  const AuthenticationFailure(super.message, {super.code});
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, {super.code});
}
