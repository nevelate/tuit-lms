class Attachment {
  String? name;
  String? url;

  bool get isFile {
    if(name == null){
      return false;
    }
    return name!.lastIndexOf('\\') < name!.lastIndexOf('.');
  }
}
