//pattern para validar un email
bool _isPatEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

//formato de password valido (Firebase)
bool _isValPass(String pass) {
  return pass.length >= 6 ? true : false;
}

//valida el email y devulve respuesta
valEmail(String email) {
  if (email.isNotEmpty) {
    if (_isPatEmail(email)) {
      return null;
    } else {
      return "Email inválido";
    }
  } else {
    return "El campo email no puede estar vacio";
  }
}

//valida la password y devulve respuesta
valPass(String pass) {
  if (pass.isNotEmpty) {
    if (_isValPass(pass)) {
      return null;
    } else {
      return "La contraseña debe tener mas de 6 caracteres";
    }
  } else {
    return "El campo contraseña no puede estar vacio";
  }
}
