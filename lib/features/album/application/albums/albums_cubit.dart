import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../album.dart';

part 'albums_state.dart';

/// 负责[相册]相关功能的cubit
@injectable
class AlbumsCubit extends Cubit<AlbumsState> {
  final AlbumRepository _albumRepository;
  StreamSubscription? _streamSubscription;

  AlbumsCubit(this._albumRepository) : super(const AlbumsInitial());

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await super.close();
  }

  ///从[_albumRepository]中删除所有[Albums]并发出
  ///[AllAlbumsLoaded]状态为空相册列表。
  Future<void> deleteAllAlbums() async {
    await _albumRepository.deleteAllAlbums();
    emit(const AllAlbumsLoaded([]));
  }

  ///从[_albumRepository]获取所有[Albums]并发出[AllAlbumsLoaded]
  ///用相册列表说明。
  ///
  ///此外，在加载相册时，还会发出[AlbumsLoading]状态。
  Future<void> loadAllAlbums() async {
    emit(const AlbumsLoading());
    final response = await _albumRepository.findAll();
    emit(AllAlbumsLoaded(response));
  }

  ///从中获取具有给定[name]的艺术家的顶级[Albums]
  ///[[u]。一旦找到相册，它就会发出
  ///[TopAlbumsLoaded]状态。
  ///
  ///此外，在播放顶级专辑时，还会发出[AlbumsLoading]状态
  ///上膛了。
  Future<void> loadTopAlbumsByArtistName(String name) async {
    emit(const AlbumsLoading());
    final response = await _albumRepository.findTopAlbumsByArtistName(name);
    emit(TopAlbumsLoaded(response));
  }

  ///监视[_albumRepository]中的任何更新的[AlbumDetails]，以及
  ///与所有相册列表一起发出[AllAlbumsLoaded]状态。
  ///
  ///在观看任何更新之前，它将通过调用
  ///[loadAllAlbums]方法。
  Future<void> watchAllAlbums() async {
    await loadAllAlbums();
    _streamSubscription ??= _albumRepository
        .watchAllAlbums()
        .map((albums) => AllAlbumsLoaded(albums))
        .listen(emit);
  }
}
