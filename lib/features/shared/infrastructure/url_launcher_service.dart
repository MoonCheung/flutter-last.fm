// coverage:ignore-file
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

///负责打开web URL的类。
///
///该实现基于“url_launcher”包
abstract class UrlLauncherService {
  Future<void> openUrl(String url);
}

@Injectable(as: UrlLauncherService)
class UrlLauncherServiceImpl implements UrlLauncherService {
  @override
  Future<void> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
