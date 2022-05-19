
import 'package:flutter/material.dart';

import '../Repository/github_data/github_credentials.dart';
import 'github_login/github_login_hook.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      authBuilder: (context, httpClient) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: const Center(
            child: Text(
              'You are logged in to GitHub!',
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