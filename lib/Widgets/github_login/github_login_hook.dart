import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';

import '../../Repository/github_login_agent_repository.dart';


typedef AuthenticatedBuilder = Widget Function(
    BuildContext context, oauth2.Client client);

class GithubLoginWidget extends HookConsumerWidget {
  const GithubLoginWidget({
    required this.authBuilder,
    required this.githubClientId,
    required this.githubClientSecret,
    required this.githubScopes,
    Key? key,
  }) : super(key: key);

  final AuthenticatedBuilder authBuilder;
  final String githubClientId;
  final String githubClientSecret;
  final List<String> githubScopes;

  @override
  build(BuildContext context, WidgetRef ref) {
    var redirectServer = useRef<HttpServer?>(null);
    final client = useState<oauth2.Client?>(null);
    final githubAgent = ref.watch(githubLoginAgentProvider);

    if (client.value != null) {
      return authBuilder(context, client.value!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Github Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await redirectServer.value?.close();
            // Bind to an ephemeral port on localhost
            redirectServer.value = await HttpServer.bind('localhost', 0);
            var authenticatedHttpClient = await githubAgent.getOAuth2Client(
                Uri.parse('http://localhost:${redirectServer.value!.port}/auth'),
                redirectServer.value!);
            
            client.value = authenticatedHttpClient;
            
          },
          child: const Text('Login to Github'),
        ),
      ),
    );
  }
}


