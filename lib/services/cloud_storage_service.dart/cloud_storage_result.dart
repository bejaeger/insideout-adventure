class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;
  final String? errorMessage;

  CloudStorageResult(
      {this.errorMessage, required this.imageUrl, required this.imageFileName});
  CloudStorageResult.error({this.errorMessage})
      : imageUrl = "",
        imageFileName = "";

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
}
