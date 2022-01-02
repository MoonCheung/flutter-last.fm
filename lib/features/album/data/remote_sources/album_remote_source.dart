import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../album.dart';

typedef AlbumDetailRemoteResponse
    = Either<AlbumDetailNetworkError, AlbumDetailDto>;
typedef TopAlbumsRemoteResponse = Either<TopAlbumsNetworkError, List<AlbumDto>>;

///一个类，负责使用
///Http呼叫。
abstract class AlbumRemoteSource {
  ///通过使用[query]从API获取[AlbumDetailDto]，返回[AlbumDetailDto]
  Future<AlbumDetailRemoteResponse> findAlbumDetail(AlbumDetailQueryDto query);

  ///通过使用从后端API获取[AlbumDto]的列表，返回该列表
  ///将[artistName]作为查询。
  Future<TopAlbumsRemoteResponse> findTopAlbumsByArtistName(String artistName);
}

@Injectable(as: AlbumRemoteSource)
class AlbumRemoteSourceImpl implements AlbumRemoteSource {
  final Dio _dio;

  const AlbumRemoteSourceImpl(this._dio);

  @override
  Future<AlbumDetailRemoteResponse> findAlbumDetail(
      AlbumDetailQueryDto query) async {
    try {
      final queryParams = {'method': 'album.getinfo', ...query.toJson()};
      final response = await _dio.get('/', queryParameters: queryParams);
      final Map data = response.data!;
      return right(AlbumDetailDto.fromJson(data['album']));
    } on DioError catch (error) {
      return left(
        error.toNetWorkError(onResponse: _mapAlbumDetailResponseError),
      );
    }
  }

  @override
  Future<TopAlbumsRemoteResponse> findTopAlbumsByArtistName(
      String artistName) async {
    try {
      final query = {'method': 'artist.gettopalbums', 'artist': artistName};
      final response = await _dio.get<Map>('/', queryParameters: query);
      final Map data = response.data!;
      if (data.containsKey('topalbums')) {
        final Map topAlbums = data['topalbums'];
        final List albums = topAlbums['album'];
        return right(albums.map((json) => AlbumDto.fromJson(json)).toList());
      } else {
        return const Left(NetworkException.api(TopAlbumsError.artistNotFound));
      }
    } on DioError catch (error) {
      return left(error.toNetWorkErrorOrThrow());
    }
  }

  AlbumDetailNetworkError _mapAlbumDetailResponseError(Response response) {
    return response.statusCode == 404
        ? const NetworkException.api(AlbumDetailError.albumNotFound)
        : const NetworkException.server();
  }
}
