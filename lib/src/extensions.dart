extension on String{
  String removeUpToColonAndTrim(){
    String s = this;
    int colonIndex = s.indexOf(':');
    s = s.substring(0, colonIndex + 1);
    return s.trim();
  }

  String removeFileExtension(){
    String s = this;
    int dotIndex = s.lastIndexOf('.');
    return s.substring(dotIndex + 1, s.length - 1);
  }
}

extension on double{
  double? parseOrReturnNull(String s){
    return double.tryParse(s.replaceAll('.', ','));
  }
}