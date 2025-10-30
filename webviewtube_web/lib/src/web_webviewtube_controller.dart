import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:ui_web';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:web/web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'content_type.dart';
import 'http_request_factory.dart';

/// An implementation of [PlatformWebViewControllerCreationParams] using Flutter
/// for Web API.
@immutable
class WebWebviewtubeControllerCreationParams
    extends PlatformWebViewControllerCreationParams {
  /// Creates a new [WebWebviewtubeControllerCreationParams] instance.
  WebWebviewtubeControllerCreationParams({
    this.httpRequestFactory = const HttpRequestFactory(),
  }) : super();

  /// Creates a [WebWebviewtubeControllerCreationParams] instance based on [PlatformWebViewControllerCreationParams].
  WebWebviewtubeControllerCreationParams.fromPlatformWebViewControllerCreationParams(
    // Recommended placeholder to prevent being broken by platform interface.
    // ignore: avoid_unused_constructor_parameters
    PlatformWebViewControllerCreationParams params, {
    HttpRequestFactory httpRequestFactory = const HttpRequestFactory(),
  }) : this(httpRequestFactory: httpRequestFactory);

  /// Handles creating and sending URL requests.
  final HttpRequestFactory httpRequestFactory;

  static int _nextIFrameId = 0;

  /// The underlying element used as the WebView.
  @visibleForTesting
  final WebviewtubeElement webviewtubeIframe =
      WebviewtubeElement(id: _nextIFrameId++)..credentialless = true;
}

/// An implementation of [PlatformWebViewController] using Flutter for Web API.
class WebWebviewtubeController extends PlatformWebViewController {
  /// Constructs a [WebWebviewtubeController].
  WebWebviewtubeController(
    PlatformWebViewControllerCreationParams params,
  ) : super.implementation(
          params is WebWebviewtubeControllerCreationParams
              ? params
              : WebWebviewtubeControllerCreationParams
                  .fromPlatformWebViewControllerCreationParams(params),
        );

  WebWebviewtubeControllerCreationParams get _params {
    return params as WebWebviewtubeControllerCreationParams;
  }

  JavaScriptChannelParams? _javaScriptChannelParams;

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) {
    _params.webviewtubeIframe.srcdoc = html;
    return SynchronousFuture(null);
  }

  @override
  Future<void> runJavaScript(String javaScript) {
    _params.webviewtubeIframe.runFunction(javaScript.replaceAll('"', '<<quote>>'));
    return SynchronousFuture(null);
  }

  @override
  Future<String> runJavaScriptReturningResult(String javaScript) async {
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    final function = javaScript.replaceAll('"', '<<quote>>');

    final completer = Completer<String>();
    final subscription = window.onMessage.listen(
      (event) {
        final data = jsonDecode(event.data.dartify() as String);

        if (data is Map && data.containsKey(key)) {
          completer.complete(data[key].toString());
        }
      },
    );

    _params.webviewtubeIframe.runFunction(function, key: key);

    final result = await completer.future;
    subscription.cancel();

    return result;
  }

  @override
  Future<void> addJavaScriptChannel(
    JavaScriptChannelParams javaScriptChannelParams,
  ) {
    _javaScriptChannelParams = javaScriptChannelParams;
    return SynchronousFuture(null);
  }

  @override
  Future<void> removeJavaScriptChannel(String javaScriptChannelName) {
    return SynchronousFuture(null);
  }

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    // no-op
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    // no-op
  }

  @override
  Future<void> setUserAgent(String? userAgent) async {
    // no-op
  }

  @override
  Future<void> enableZoom(bool enabled) async {
    // no-op
  }

  @override
  Future<void> setBackgroundColor(Color color) async {
    // no-op
  }

  @override
  Future<void> loadRequest(LoadRequestParams params) async {
    if (!params.uri.hasScheme) {
      throw ArgumentError(
          'LoadRequestParams#uri is required to have a scheme.');
    }

    if (params.headers.isEmpty &&
        (params.body == null || params.body!.isEmpty) &&
        params.method == LoadRequestMethod.get) {
      _params.webviewtubeIframe.src = params.uri.toString();
    } else {
      await _updateIFrameFromXhr(params);
    }
  }

  @override
  Future<void> reload() async {
    _params.webviewtubeIframe.reload();
  }

  /// Performs an AJAX request defined by [params].
  Future<void> _updateIFrameFromXhr(LoadRequestParams params) async {
    final response = await _params.httpRequestFactory.request(
      params.uri,
      method: params.method,
      headers: params.headers,
      data: params.body,
    );

    final header = response.headers.get('content-type') ?? 'text/html';
    final contentType = ContentType.parse(header);
    final encoding = Encoding.getByName(contentType.charset) ?? utf8;

    final responseText = await response.text().toDart;

    _params.webviewtubeIframe.src = Uri.dataFromString(
      responseText.toDart,
      mimeType: contentType.mimeType,
      encoding: encoding,
    ).toString();
  }
}

/// An implementation of [PlatformWebViewWidget] using Flutter the for Web API.
class WebviewtubeWeb extends PlatformWebViewWidget {
  /// Constructs a [WebviewtubeWeb].
  WebviewtubeWeb(super.params)
      : _controller = params.controller as WebWebviewtubeController,
        super.implementation() {
    platformViewRegistry.registerViewFactory(
      _controller._params.webviewtubeIframe.id,
      (int viewId) => _controller._params.webviewtubeIframe,
    );
  }

  final WebWebviewtubeController _controller;

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      key: params.key,
      viewType: (params.controller as WebWebviewtubeController)
          ._params
          .webviewtubeIframe
          .id,
      onPlatformViewCreated: (_) {
        final channelParams = _controller._javaScriptChannelParams;

        if (channelParams != null) {
          window.onMessage.listen(
            (event) {
              channelParams.onMessageReceived(
                JavaScriptMessage(message: event.data.dartify() as String),
              );
            },
          );
        }
      },
    );
  }
}

extension type WebviewtubeElement._(HTMLIFrameElement element) {
  /// A class that represents a webviewtube iframe element.
  WebviewtubeElement({required int id})
      : element = HTMLIFrameElement()
          ..id = 'webviewtube-$id'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.border = 'none'
          ..allow = 'autoplay;fullscreen';

  /// The underlying [HTMLIFrameElement] used by the [WebviewtubeElement].
  String get id => element.id;

  /// The URL of the page that the iframe will display.
  set src(String value) => element.src = value;

  /// The content of the page that the iframe will display.
  set srcdoc(String value) {
    element.srcdoc = value.toJS;

    // Fallback for browser that doesn't support srcdoc.
    element.src = Uri.dataFromString(
      value,
      mimeType: 'text/html',
      encoding: utf8,
    ).toString();
  }

  /// Provides a mechanism for developers to load third-party resources in [HTMLIFrameElement]s using a new, ephemeral context.
  /// This allows the third-party resources to be loaded without cookies, storage, or access to the parent frame.
  ///
  /// See more at:
  /// - [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/Security/IFrame_credentialless)
  /// - [Chrome Developers](https://developer.chrome.com/blog/anonymous-iframe-origin-trial)
  set credentialless(bool value) {
    element['credentialless'] = value.toJS;
  }

  /// Reloads the iframe content.
  void reload() {
    final currentSrc = element.src;
    element.src = 'about:blank';
    element.src = currentSrc;
  }

  /// Runs a function in the [HTMLIFrameElement] using postMessage.
  void runFunction(String function, {String? key}) {
    element.contentWindow?.postMessage(
      '{"key": "$key", "function": "$function"}'.toJS,
      '*'.toJS,
    );
  }
}
