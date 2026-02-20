class Attachment {
  String? name;
  String? url;

  bool get isFile {
    if(url == null){
      return false;
    }
    return url!.lastIndexOf('/') < url!.lastIndexOf('.');
  }
}
