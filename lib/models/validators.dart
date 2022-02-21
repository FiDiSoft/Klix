class Validators {
  static String? validateEmail({required String email}) {
    // ignore: unnecessary_null_comparison
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email cannot be empty!';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter the email according to the format!';
    }

    return null;
  }
}
