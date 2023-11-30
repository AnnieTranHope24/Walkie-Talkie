String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  }

  if (value.length < 8) {
    return "Your password must be at least 8 characters";
  }

  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Your password must contain an uppercase character";
  }

  return null;
}

String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a username';
  }
  if (RegExp(r'^[\w\s_\-0-9]+$').hasMatch(value)) {
    return null;
  }
  return "Usernames may include alphabetical characters, underscores '_', hyphens '-', or numerical characters";
}

String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  if (RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
    return null;
  }
  return "Names may not be anything other than spaces and alphabetic characters";
}

String? phonenumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a phone number';
  }

  if (!RegExp(r'\d{10}').hasMatch(value)) {
    return "Invalid phone number format";
  }

  return null;
}
