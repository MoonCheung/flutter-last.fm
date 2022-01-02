import 'package:equatable/equatable.dart';

import '../../../shared/models/image.dart';

/// 艺术家名单。
typedef Artists = List<Artist>;

class Artist extends Equatable {
  final String name;
  final Images images;
  final int listenersCount;

  const Artist({
    required this.name,
    required this.images,
    required this.listenersCount,
  });

  @override
  List<Object?> get props => [name, images, listenersCount];
}
