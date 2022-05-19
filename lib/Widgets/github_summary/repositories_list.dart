import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github/github.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Repository/github_login_agent_repository.dart';
import 'launch_url.dart';

class RepositoriesList extends HookConsumerWidget {
  const RepositoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final github = ref.watch(githubLoginProvider);
    final repositorySnapshot = useFuture(github?.repositories.listRepositories().toList());
    
    
    if (repositorySnapshot.hasError) {
      return Center(child: Text('${repositorySnapshot.error}'));
    }
    if (!repositorySnapshot.hasData || repositorySnapshot.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    var repositories = repositorySnapshot.data;
    return ListView.builder(
      itemBuilder: (context, index) {
        var repository = repositories![index];
        return ListTile(
          title:
              Text('${repository.owner?.login ?? ''}/${repository.name}'),
          subtitle: Text(repository.description),
          onTap: () => launchGithubUrl(context, repository.htmlUrl),
        );
      },
      itemCount: repositories!.length,
    );
  }
}