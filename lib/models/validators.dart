class Validators {
  static String? validateEmail({required String email}) {
    // ignore: unnecessary_null_comparison
    if (email == null) {
      return null;
    }

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'Email tidak boleh kosong!';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Masukkan email sesuai dengan format!';
    }

    return null;
  }
}
