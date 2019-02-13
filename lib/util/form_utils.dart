bool isPasswordValid(String value) {
  return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,20}$')
      .hasMatch(value ?? '');
}

bool isMobileNumberValid(String value) {
  return RegExp(r'\d{11}').hasMatch(value ?? '');
}

bool isLandlineNumberValid(String value) {
  return RegExp(r'0\d{2}\d?-\d+').hasMatch(value ?? '');
}

bool isEmailValid(String value) {
  return RegExp(r'''^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)])$''')
      .hasMatch(value ?? '');
}

bool isIdCardNumberValid(String value) {
  return RegExp(r'^\d{17}(\d|x|X)$').hasMatch(value ?? '');
}