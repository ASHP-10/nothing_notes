// login exceptions

class UserNotFoundAuthException implements Exception {}

class UserDisabledAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

// register exceptions

class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

//login and register exception

class UserTokenExpiredAuthException implements Exception {}

class OperationNotAllowedAuthException implements Exception {}

class NetworkAuthException implements Exception {}

class TooManyRequestsAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericRegistrationAuthException implements Exception {}

class GenericLoginAuthException implements Exception {}
