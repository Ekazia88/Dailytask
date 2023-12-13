class validation{
  static String? validationEmail(String? value){
    if(value == null || value.isEmpty ){
      return 'Tidak boleh kosong';
    }
    final isEmailformat = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    if(!isEmailformat.hasMatch(value)){
      return 'Alamat Email valid';
    }
    return null;
  }
 static String? validationUsername(String? value){
    if(value == null || value.isEmpty ){
      return ' username Tidak boleh kosong';
    }
 }
  static String? validatePassword(String? value){
     if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }

  if (value.length < 6) {
    return 'Password harus terdiri dari minimal 6 karakter';
  }

  // Memeriksa keberadaan huruf besar (uppercase) dalam password
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Password harus mengandung minimal satu huruf besar (uppercase)';
  }

  // Memeriksa keberadaan angka dalam password
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password harus mengandung minimal satu angka';
  }

   if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'Password harus mengandung minimal satu karakter khusus';
  }
  // Jika semua persyaratan terpenuhi, kembalikan null (tidak ada pesan kesalahan)
  return null;
  }
}