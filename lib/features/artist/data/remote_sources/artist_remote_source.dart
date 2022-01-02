import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../data.dart';

typedef ArtistSearchRemoteResponse
    = Either<NetworkException<void>, ArtistDtoList>;

/// 一个类负责使用Http调用从后台API获取艺术家数据。
abstract class ArtistRemoteSource {
  /// 返回与给定[名称]匹配的艺术家
  Future<ArtistSearchRemoteResponse> findByName(String name);
}

@Injectable(as: ArtistRemoteSource)
class ArtistRemoteSourceImpl implements ArtistRemoteSource {
  final Dio _dio;

  const ArtistRemoteSourceImpl(this._dio);

  @override
  Future<ArtistSearchRemoteResponse> findByName(String name) async {
    try {
      final query = <String, String>{'method': 'artist.search', 'artist': name};
      final response = await _dio.get<Map>('/', queryParameters: query);
      final Map results = response.data!['results'];
      final Map artistMatches = results['artistmatches'];
      final List matches = artistMatches['artist'];
      final artists = matches.map((json) => ArtistDto.fromJson(json)).toList();
      return right(artists);
    } on DioError catch (error) {
      return left(error.toNetWorkErrorOrThrow());
    }
  }
}
