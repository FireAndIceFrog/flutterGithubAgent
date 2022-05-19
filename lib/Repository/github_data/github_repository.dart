import 'package:riverpod/riverpod.dart';

import 'github_credentials.dart';

class GithubRepository {
  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;

  GithubRepository(this.githubClientId, this.githubClientSecret, this.githubScopes);
}

final _githubRepository = GithubRepository(githubClientId, githubClientSecret, githubScopes);
final githubRepositoryProvider = StateProvider((_) => _githubRepository);