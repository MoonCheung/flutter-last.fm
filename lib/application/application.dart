import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../config/config.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;
    return MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        // 全局Material默认的文本方向
        GlobalMaterialLocalizations.delegate,
        // 全局widget默认的文本方向
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      // 如果非空，则调用此回调函数以生成应用程序的标题字符串，否则使用标题
      onGenerateTitle: (context) => context.l10n.appName,
      // 根据手机系统的语言改变而改变
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationParser: router.routeInformationParser,
    );
  }
}
