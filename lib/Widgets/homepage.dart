
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_to_front/window_to_front.dart';

import '../Repository/github_data/github_credentials.dart';
import '../Repository/github_login_agent_repository.dart';
import 'github_login/github_login_hook.dart';
import 'github_summary/github_summary.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      authBuilder: (context, ref, httpClient) {
        WindowToFront.activate();
        
        useEffect(() {
          final accessToken = httpClient.credentials.accessToken;
          ref.read(githubLoginProvider.notifier).state = GitHub(auth: Authentication.withToken(accessToken));
        }, [httpClient.credentials.accessToken]);
        
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body:  const GitHubSummary(),
        );
      },
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}