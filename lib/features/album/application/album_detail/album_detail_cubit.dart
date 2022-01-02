import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../album.dart';

part 'album_detail_state.dart';

/// 负责[AlbumDetail]相关功能的cubit
@injectable
class AlbumDetailCubit extends Cubit<AlbumDetailState> {
  final AlbumRepository _albumRepository;

  AlbumDetailCubit(this._albumRepository) : super(const AlbumDetailInitial());

  ///从[_albumRepository]删除相册。
  ///
  ///在调用此方法之前，必须先输入当前的[state]
  ///[AlbumDetailLoaded]。否则，调用此方法将不起任何作用。
  Future<void> deleteAlbum() async {
    if (state is AlbumDetailLoaded) {
      final response = (state as AlbumDetailLoaded).response;
      if (response is Right<AlbumDetailNetworkError, AlbumDetail>) {
        await _deleteAlbum(response.value);
      }
    }
  }

  ///从[_albumRepository]获取相册详细信息并发出
  ///[AlbumDetailLoaded]与相册一起显示状态。
  Future<void> loadAlbumDetail(AlbumDetailQuery query) async {
    emit(const AlbumDetailLoading());
    final response = await _albumRepository.findAlbumDetail(query);
    emit(AlbumDetailLoaded(response));
  }

  Future<void> _deleteAlbum(AlbumDetail album) async {
    final request = AlbumDetailQuery.fromAlbum(album);
    await _albumRepository.deleteAlbum(request);
    emit(const AlbumDetailDeleted());
  }
}
