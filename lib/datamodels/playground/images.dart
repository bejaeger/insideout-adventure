import 'package:freezed_annotation/freezed_annotation.dart';

part 'images.freezed.dart';
part 'images.g.dart';

@freezed
class Images with _$Images {
  factory Images({

    // this is mostly used together with a check of appConfigProvide.isARAvailable!
    required List<String> imageUrls,

    // Switch to make completed quests visible/invisible
    // (only done for search quests at the moment
    // as hike quests can ALWAYS be redone))
  }) = _Images;

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);
}
