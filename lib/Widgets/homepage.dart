
import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Repository/github_data/github_credentials.dart';
import '../Repository/github_login_agent_repository.dart';
import 'github_login/github_login_hook.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      authBuilder: (context, ref, httpClient) {
        AsyncValue<CurrentUser> loginData = ref.watch(githubLoginProvider(httpClient.credentials.accessToken));
        
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Text(
              loginData.when(
                loading: () => 'Retrieving viewer login details...',
                error: (err, stack) => 'Error: $err',
                data: (data) {
                  return 'Hello ${data.login}!';
                }
              ),
            ),
          ),
        );
      },
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}