import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../album.dart';

///在本地存储器中存储和检索[AlbumDto]。
///
///该实现使用[Hive]数据库。
abstract class AlbumLocalSource {
  ///从与给定[query]匹配的本地存储中删除相册。
  Future<void> deleteAlbum(AlbumDetailQueryDto query);

  ///从本地存储中删除所有相册。
  Future<void> deleteAllAlbums();

  ///返回与给定[query]匹配的唱片集详细信息。
  Future<AlbumDetailDto?> findAlbumDetail(AlbumDetailQueryDto query);

  ///返回存储在本地存储器中的所有相册。
  Future<List<AlbumDetailDto>> findAllAlbums();

  ///将[album]存储到本地存储器并返回相同的[album]
  Future<AlbumDetailDto> saveAlbum(AlbumDetailDto album);

  ///返回存储在本地存储器中的[AlbumDto]列表流。
  ///
  ///每当[AlbumDto]被更新、删除时，就会发出一个新事件，
  ///或者存储新的[AlbumDto]。
  Stream<List<AlbumDetailDto>> watchAllAlbums();
}

@Injectable(as: AlbumLocalSource)
class AlbumLocalSourceImpl implements AlbumLocalSource {
  final Box<AlbumDetailDto> _albumBox;

  const AlbumLocalSourceImpl(@Named('albumBox') this._albumBox);

  @override
  Future<void> deleteAlbum(AlbumDetailQueryDto query) {
    return _albumBox.delete(query.toId());
  }

  @override
  Future<void> deleteAllAlbums() => _albumBox.clear();

  @override
  Future<AlbumDetailDto?> findAlbumDetail(AlbumDetailQueryDto query) async {
    return _albumBox.get(query.toId());
  }

  @override
  Future<List<AlbumDetailDto>> findAllAlbums() async {
    return _albumBox.values.toList();
  }

  @override
  Future<AlbumDetailDto> saveAlbum(AlbumDetailDto album) async {
    await _albumBox.put(album.toId(), album);
    return album;
  }

  @override
  Stream<List<AlbumDetailDto>> watchAllAlbums() {
    return _albumBox.watch().map((_) => _albumBox.values.toList());
  }
}

extension on AlbumDetailQueryDto {
  String toId() => '$artist-$album';
}

extension on AlbumDetailDto {
  String toId() => '$artist-$name';
}
