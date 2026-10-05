import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_rest_client/json_rest_client.dart' hide UserAgentProvider;
import 'package:rocketbot/models/pos_token_auth.dart';
import 'package:rocketbot/models/refresh_token.dart';
import 'package:rocketbot/models/signin_code.dart';
import 'package:rocketbot/models/signin_key.dart';
import 'package:rocketbot/support/app_services.dart';
import 'package:rocketbot/support/user_agent.dart';

export 'package:json_rest_client/json_rest_client.dart'
    show
        BadRequestException,
        ConflictDataException,
        DeserializationException,
        InvalidInputException,
        NetworkException,
        NotFoundException,
        RequestTimeoutException,
        RestClientException,
        ServerErrorException,
        UnauthorizedException;

class _SecureTokenStore implements TokenStore {
  const _SecureTokenStore();

  @override
  Future<String?> read(String key) => secureStore.read(key);
}

class RocketbotClient {
  static const String baseUrl = "https://app.rocketbot.pro/api/mobile/";
  static String posUrl = "https://mobileapp.rocketbot.pro/api/"; //TODO REFRESH TOKEN are separate!!!
  static String webURL = "https://mobileapp.rocketbot.pro/web/v1";
  static String mobileLaunchUrl = "https://rocket.art/api/api/v1";
  static const String token = "token";
  static const String posToken = "posToken";
  static const String tokenRefresh = "refreshToken";
  static const String posTokenRefresh = "posRefreshToken";

  static const _SecureTokenStore _tokenStore = _SecureTokenStore();

  static final JsonRestClient _mainClient = JsonRestClient(
    baseUrl: baseUrl,
    tokenStore: _tokenStore,
    authScheme: 'Bearer',
    authTokenKey: token,
    timeout: const Duration(seconds: 120),
    userAgentProvider: UserAgentProvider.get,
    onUnauthorized: _refreshMainToken,
  );

  static final JsonRestClient _posClient = JsonRestClient(
    baseUrl: posUrl,
    tokenStore: _tokenStore,
    authScheme: 'JWT',
    authTokenKey: posToken,
    timeout: const Duration(seconds: 120),
    userAgentProvider: UserAgentProvider.get,
    onUnauthorized: _refreshPosToken,
  );

  static final JsonRestClient _launchpadClient = JsonRestClient(
    baseUrl: mobileLaunchUrl,
    tokenStore: _tokenStore,
    authScheme: 'JWT',
    authTokenKey: posToken,
    timeout: const Duration(seconds: 120),
    userAgentProvider: UserAgentProvider.get,
    onUnauthorized: _refreshPosToken,
  );

  static final JsonRestClient _webClient = JsonRestClient(
    baseUrl: webURL,
    tokenStore: _tokenStore,
    authScheme: 'JWT',
    authTokenKey: posToken,
    timeout: const Duration(seconds: 120),
    userAgentProvider: UserAgentProvider.get,
    onUnauthorized: _refreshPosToken,
  );

  static final JsonRestClient _authClient = JsonRestClient(
    baseUrl: baseUrl,
    tokenStore: _tokenStore,
    timeout: const Duration(seconds: 15),
    userAgentProvider: UserAgentProvider.get,
  );

  static final JsonRestClient _posAuthClient = JsonRestClient(
    baseUrl: posUrl,
    tokenStore: _tokenStore,
    timeout: const Duration(seconds: 15),
    userAgentProvider: UserAgentProvider.get,
  );

  static Future<String?>? _mainRefreshInFlight;
  static Future<String?>? _posRefreshInFlight;

  static Future<String?> _refreshMainToken() =>
      _mainRefreshInFlight ??= refreshToken().whenComplete(() => _mainRefreshInFlight = null);

  static Future<String?> _refreshPosToken() =>
      _posRefreshInFlight ??= refreshToken(pos: true).whenComplete(() => _posRefreshInFlight = null);

  static JsonRestClient _clientFor({required bool pos, required bool web, required bool launchpad}) {
    if (pos) {
      return _posClient;
    }
    if (web) {
      return _webClient;
    }
    if (launchpad) {
      return _launchpadClient;
    }
    return _mainClient;
  }

  // `auth` defaults to true because the old transport always attached the
  // Authorization header; no call site opts out.
  Future<dynamic> get(String url,
      {String? request, bool pos = false, bool web = false, bool launchpad = false, bool auth = true, bool debug = false}) async {
    final response = await _clientFor(pos: pos, web: web, launchpad: launchpad).get<dynamic>(
      url,
      query: request == null ? null : Uri.splitQueryString(request),
      auth: auth,
      debug: debug,
    );
    return response;
  }

  Future<dynamic> post(String url, Map<String, dynamic> request,
      {bool pos = false, bool launchpad = false, bool web = false, bool auth = true, bool debug = false}) async {
    final response = await _clientFor(pos: pos, web: web, launchpad: launchpad).post<dynamic>(
      url,
      body: request,
      auth: auth,
      debug: debug,
    );
    return response;
  }

  static Future<String?> getKey(String login, String pass) async {
    try {
      final response = await _authClient.post<Map<String, dynamic>>(
        'Auth/Signin',
        body: {"email": login, "password": pass},
        headers: {'accept': 'application/json'},
      );
      var js = SignKey.fromJson(response);
      return js.data!.key!;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> getEmailCode(String key) async {
    try {
      await _authClient.post(
        'Auth/SendEmailCodeForSignin',
        body: {"key": key},
        headers: {'accept': 'application/json'},
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<String?> getToken(String key, String code) async {
    try {
      final response = await _authClient.post<Map<String, dynamic>>(
        'Auth/ConfirmSignin',
        body: {"key": key, "emailCode": code},
        headers: {'accept': 'application/json'},
      );
      SignCode? res = SignCode.fromJson(response);
      await secureStore.write(token, res.data!.token!);
      await secureStore.write(tokenRefresh, res.data!.refreshToken!);
      return res.data!.token!;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<String?> getTokenGoogle(String tokenID) async {
    try {
      final response = await _authClient.post<Map<String, dynamic>>(
        'Auth/SignWithGoogle',
        body: {"token": tokenID},
        headers: {'accept': 'application/json'},
      );
      SignCode? res = SignCode.fromJson(response);
      if (res.data!.token != null) {
        await secureStore.write(token, res.data!.token!);
        await secureStore.write(tokenRefresh, res.data!.refreshToken!);
        return res.data!.token!;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<String?> getTokenApple(String authorizationCode) async {
    try {
      final response = await _authClient.post<Map<String, dynamic>>(
        'Auth/SignWithApple',
        body: {"authorizationCode": authorizationCode},
        headers: {'accept': 'application/json'},
      );
      SignCode? res = SignCode.fromJson(response);
      if (res.data!.token != null) {
        await secureStore.write(token, res.data!.token!);
        await secureStore.write(tokenRefresh, res.data!.refreshToken!);
        return res.data!.token!;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<String?> registerUser(
      {required String email,
      required String pass,
      required String passConf,
      required String name,
      required String surname,
      required bool agreed}) async {
    try {
      final response = await _authClient.post<Map<String, dynamic>>(
        'Auth/Signup',
        body: {"email": email, "password": pass, "confirmPassword": passConf, "name": name, "surname": surname, "agreeToConditions": agreed},
        headers: {'accept': 'application/json'},
      );
      if (response == null) {
        return null;
      }
      SignCode? res = SignCode.fromJson(response);
      if (res.data != null && res.data!.token != null) {
        await secureStore.write(token, res.data!.token!);
        await secureStore.write(tokenRefresh, res.data!.refreshToken!);
      }
      return jsonEncode(response);
    } on NetworkException catch (e) {
      debugPrint(e.toString());
      return null;
    } on RequestTimeoutException catch (e) {
      debugPrint(e.toString());
      return null;
    } on DeserializationException catch (e) {
      debugPrint(e.toString());
      return null;
    } on RestClientException catch (e) {
      return e.message;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<int> forgotPass(String email) async {
    try {
      await _mainClient.post(
        "Auth/ForgotPassword",
        body: {"email": email},
        auth: true,
        debug: true,
      );
      return 1;
    } catch (e) {
      debugPrint(e.toString());
      return 0;
    }
  }

  static Future<int> checkToken() async {
    try {
      await _refreshMainToken();
      return 0;
    } catch (e) {
      debugPrint(e.toString());
      return 1;
    }
  }

  static Future<String?> refreshToken({bool pos = false}) async {
    try {
      await secureStore.delete(pos ? posToken : token);
      String? enc = await secureStore.read(pos ? posTokenRefresh : tokenRefresh);
      final response = await (pos ? _posAuthClient : _authClient).post<Map<String, dynamic>>(
        pos ? "auth/refreshToken" : "Auth/RefreshToken",
        body: {"token": enc},
        headers: {"accept": "application/json", "Auth-Type": "rsa"},
        timeout: const Duration(seconds: 15),
      );
      TokenRefresh? res = TokenRefresh.fromJson(response);
      if (res.data != null && res.data!.token != null) {
        if (pos) {
          await secureStore.write(posToken, res.data!.token!);
          await secureStore.write(posTokenRefresh, res.data!.refreshToken!);
        } else {
          await secureStore.write(token, res.data!.token!);
          await secureStore.write(tokenRefresh, res.data!.refreshToken!);
        }
        return res.data!.token;
      }
      if (pos) {
        await secureStore.delete(posToken);
        await secureStore.delete(posTokenRefresh);
      }
      return null;
    } catch (e) {
      if (pos) {
        await secureStore.delete(posToken);
        await secureStore.delete(posTokenRefresh);
      }
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> registerPos(String token) async {
    try {
      final response = await _posAuthClient.post<Map<String, dynamic>>(
        "auth",
        body: {"token": token},
        headers: {"accept": "application/json", "Auth-Type": "rsa"},
        timeout: const Duration(seconds: 15),
      );
      PosTokenAuth? res = PosTokenAuth.fromJson(response);
      await secureStore.write(posToken, res.token!);
      await secureStore.write(posTokenRefresh, res.refreshToken!);
    } on RestClientException {
      debugPrint("//// PoS TOKEN ERROR ////");
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> registerPosHandle() async {
    String? posToken = await secureStore.read(RocketbotClient.posToken);
    if (posToken == null) {
      String? token = await secureStore.read(RocketbotClient.token);
      await RocketbotClient.registerPos(token!);
    } else {
      debugPrint(posToken);
    }
  }
}
