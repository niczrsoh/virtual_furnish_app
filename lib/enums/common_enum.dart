
// ignore_for_file: constant_identifier_names

enum FontFamily{
  Poppins,
  Roboto,
}

extension FontFamilyExtension on FontFamily{
  String get value{
    switch(this){
      case FontFamily.Poppins:
        return 'Poppins';
      case FontFamily.Roboto:
        return 'Roboto';
      default:
        return 'Poppins';
    }
  }
}