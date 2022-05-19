
import 'dart:io';

import 'package:github/github.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:riverpod/riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Exceptions/login_exception.dart';
import 'github_data/github_repository.dart';
import '../json_http_client.dart';

final _authorizationEndpoint =
    Uri.parse('https://github.com/login/oauth/authorize');
final _tokenEndpoint = Uri.parse('https://github.com/login/oauth/access_token');

abstract class AGithubLoginAgent {
  Future<oauth2.Client> getOAuth2Client(Uri redirectUrl, HttpServer redirectServer);
  Future<void> redirect(Uri authorizationUrl);
  Future<Map<String, String>> listen(HttpServer redirectServer);
}

class GithubLoginAgent extends AGithubLoginAgent { 
  Ref? ref;

  GithubLoginAgent();

  GithubLoginAgent getProvider(Ref ref) {
    this.ref = ref;
    return this;
  }

  @override
  Future<oauth2.Client> getOAuth2Client(Uri redirectUrl, HttpServer redirectServer) async {
    final githubRepository = ref!.read(githubRepositoryProvider);

    if (githubRepository.githubClientId.isEmpty || githubRepository.githubClientSecret.isEmpty) {
      throw const GithubLoginException(
          'githubClientId and githubClientSecret must be not empty. '
          'See `lib/github_oauth_credentials.dart` for more detail.');
    }
    var grant = oauth2.AuthorizationCodeGrant(
      githubRepository.githubClientId,
      _authorizationEndpoint,
      _tokenEndpoint,
      secret: githubRepository.githubClientSecret,
      httpClient: JsonHttpClient(),
    );
    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: githubRepository.githubScopes);

    await redirect(authorizationUrl);
    var responseQueryParameters = await listen(redirectServer);
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  @override
  Future<void> redirect(Uri authorizationUrl) async {
    var url = authorizationUrl.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw GithubLoginException('Could not launch $url');
    }
  }

  @override
  Future<Map<String, String>> listen(HttpServer redirectServer ) async {
    var request = await redirectServer.first;
    var params = request.uri.queryParameters;
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await redirectServer.close();
    return params;
  }
}

final githubLoginAgent = GithubLoginAgent();
final githubLoginAgentProvider = Provider((ref) => githubLoginAgent.getProvider(ref));

final githubLoginProvider = FutureProvider.family<CurrentUser, String>((ref, accessToken) async {
  final gitHub = GitHub(auth: Authentication.withToken(accessToken));
  return gitHub.users.getCurrentUser();
});