import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/features.dart';

class AppRouter {
  static const albums = 'albums';
  static const albumDetail = 'albumetail';

  static final GoRouter router = GoRouter(
    // 使用路由构建器和错误页面构建器配置GoRouter的默认构造函数。
    debugLogDiagnostics: kDebugMode,
    routes: [
      // 首页
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const MainScreen(),
        ),
      ),
      // 专辑
      GoRoute(
        name: albums,
        path: '/albums',
        pageBuilder: (context, state) {
          final artist = state.queryParams['artist'];
          return MaterialPage(
            key: state.pageKey,
            child: TopAlbumsScreen(artistName: artist!),
          );
        },
        routes: [
          // 专辑详情
          GoRoute(
            path: 'detail',
            name: albumDetail,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: AlbumDetailScreen(
                query:
                    AlbumDetailQueryDto.fromJson(state.queryParams).toModel(),
              ),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorScreen(error: state.error),
    ),
    // 使用路由构建器和错误页面构建器配置GoRouter的默认构造函数。
    redirect: (state) {
      if (state.location == '/albums') {
        final artist = state.queryParams['artist'];
        final top = state.queryParams['top']?.toLowerCase();
        final isTopAlbums = artist != null && top == 'true';
        if (!isTopAlbums) return '/';
      }
    },
  );

  const AppRouter._();

  static void setUrlPathStrategy() {
    GoRouter.setUrlPathStrategy(UrlPathStrategy.path);
  }
}

class ErrorScreen extends StatelessWidget {
  final Exception? error;

  const ErrorScreen({Key? key, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CloseButton()),
      body: const Center(
        child: Text('Something went wrong!'),
      ),
    );
  }
}
