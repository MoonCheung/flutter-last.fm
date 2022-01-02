import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../artist.dart';

typedef ArtistSearchResponse = Either<NetworkException<void>, Artists>;

///负责存储和检索[Artister]/s数据的存储库
///不同的数据源。
///
///实现依赖于[ArtisterMoteSource]发送和获取
///[艺术家]API的相关数据。
abstract class ArtistRepository {
  /// 返回与给定[名称]匹配的[艺术家]。
  Future<ArtistSearchResponse> findByName(String name);
}
