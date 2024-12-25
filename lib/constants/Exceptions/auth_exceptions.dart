// login exceptions

class UserNotFoundException implements Exception {}

class UserDisabledException implements Exception {}

class WrongPasswordException implements Exception {}

class InvalidCredentialException implements Exception {}

// register exceptions

class EmailAlreadyInUseException implements Exception {}

class WeakPasswordException implements Exception {}

//login and register exception

class UserTokenExpiredException implements Exception {}

class OperationNotAllowedException implements Exception {}

class NetworkException implements Exception {}

class TooManyRequestsException implements Exception {}

class InvalidEmailException implements Exception {}

// generic exceptions

class GenericRegistrationException implements Exception {}

class GenericLoginException implements Exception {}
