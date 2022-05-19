
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github/github.dart';
import 'package:github_agent/Widgets/github_summary/launch_url.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Repository/github_login_agent_repository.dart';


class PullRequestsList extends HookConsumerWidget {
  const PullRequestsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final github = ref.watch(githubLoginProvider);
    final pullRequestSnapshot = useFuture(github?.pullRequests
        .list(RepositorySlug('flutter', 'flutter'))
        .toList());

    if (pullRequestSnapshot.hasError) {
      return Center(child: Text('${pullRequestSnapshot.error}'));
    }
    if (!pullRequestSnapshot.hasData || pullRequestSnapshot.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    var pullRequests = pullRequestSnapshot.data;
    return ListView.builder(
      itemBuilder: (context, index) {
        var pullRequest = pullRequests![index];
        return ListTile(
          title: Text(pullRequest.title ?? ''),
          subtitle: Text('flutter/flutter '
              'PR #${pullRequest.number} '
              'opened by ${pullRequest.user?.login ?? ''} '
              '(${pullRequest.state?.toLowerCase() ?? ''})'),
          onTap: () => launchGithubUrl(context, pullRequest.htmlUrl ?? ''),
        );
      },
      itemCount: pullRequests!.length,
    );
  }
}

