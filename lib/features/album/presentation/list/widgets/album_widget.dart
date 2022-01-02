part of '../albums_screen.dart';

/// 显示[相册]信息的小部件。
class AlbumWidget extends StatelessWidget {
  final Album album;

  @visibleForTesting
  const AlbumWidget({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('监听专辑信息: ${album}');
    print('监听专辑信息 TO JSON: ${AlbumDetailQueryDto.fromAlbum(album).toJson()}');
    void onPressed() {
      // 跳转到专辑详情页面
      context.pushNamed(
        AppRouter.albumDetail,
        queryParams: AlbumDetailQueryDto.fromAlbum(album).toJson(),
      );
    }

    return Card(
      shape: const BeveledRectangleBorder(),
      child: InkWell(
        // 触摸点击跳转到专辑详情页面
        onTap: onPressed,
        child: Column(
          children: [
            // 扩展小部件
            Expanded(child: _AlbumImage(images: album.images)),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: Text(
                  album.name,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 专辑图像小部件
class _AlbumImage extends StatelessWidget {
  final Images images;

  const _AlbumImage({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeHolder = Icon(Icons.album, size: 80);
    return images.large.fold(
      () => placeHolder,
      (image) => CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: image.url,
        placeholder: (_, __) => placeHolder,
        errorWidget: (_, __, ___) => placeHolder,
      ),
    );
  }
}
