import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webviewtube_web/src/web_webviewtube_controller.dart';

/// An implementation of [WebViewPlatform] using Flutter for Web API.
class WebWebviewtubePlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) {
    return WebWebviewtubeController(params);
  }

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) {
    return WebviewtubeWeb(params);
  }

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) {
    return WebNavigationDelegate(params);
  }

  /// Gets called when the plugin is registered.
  static void registerWith(Registrar registrar) {
    WebViewPlatform.instance = WebWebviewtubePlatform();
  }
}

/// An implementation of [PlatformNavigationDelegate] using Flutter for Web API.
class WebNavigationDelegate extends PlatformNavigationDelegate {
  /// Creates a new [WebNavigationDelegate] instance.
  WebNavigationDelegate(super.params) : super.implementation();

  @override
  Future<void> setOnNavigationRequest(
    NavigationRequestCallback onNavigationRequest,
  ) async {}

  @override
  Future<void> setOnWebResourceError(
    WebResourceErrorCallback onWebResourceError,
  ) async {}
}
