class FirebaseErrorCodeExceptions {

  static String emailInUse = "Este correo electrónico ya está en uso.";
  static String wrongPassword = "Contraseña incorrecta.";
  static String userNotFount = "Este correo no está registrado.";
  static String userDisabled = "Correo bloquedo.";
  static String manyRequest = "Demasiados intentos.";
  static String serverError = "Error en el servidor. Intentalo otra vez.";
  static String invalidEmail = "Correo no válido";
  static String defaultError = "Algo salió mal :c";


  static String getMessageFromErrorCode(errorCode) {

    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return emailInUse;


      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return wrongPassword;


      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return userNotFount;


      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return userDisabled;
        

      case "ERROR_TOO_MANY_REQUESTS":
      case "too-many-requests":
        return manyRequest;
        

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return serverError;
        

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return invalidEmail;
        

      default:
        return defaultError;
        

    }
  }


}