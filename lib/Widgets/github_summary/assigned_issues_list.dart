import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:github/github.dart';
import 'package:github_agent/Widgets/github_summary/launch_url.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../Repository/github_login_agent_repository.dart';

class AssignedIssuesList extends HookConsumerWidget {
  const AssignedIssuesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final github = ref.watch(githubLoginProvider);
    final assignedIssuesSnapshot = useFuture(github?.issues.listByUser().toList());

    
    if (assignedIssuesSnapshot.hasError) {
      return Center(child: Text('${assignedIssuesSnapshot.error}'));
    }
    if (!assignedIssuesSnapshot.hasData || assignedIssuesSnapshot.data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    var assignedIssues = assignedIssuesSnapshot.data;
    return ListView.builder(
      itemBuilder: (context, index) {
        var assignedIssue = assignedIssues![index];
        return ListTile(
          title: Text(assignedIssue.title),
          subtitle: Text('${_nameWithOwner(assignedIssue)} '
              'Issue #${assignedIssue.number} '
              'opened by ${assignedIssue.user?.login ?? ''}'),
          onTap: () => launchGithubUrl(context, assignedIssue.htmlUrl),
        );
      },
      itemCount: assignedIssues!.length,
    );
  }

  String _nameWithOwner(Issue assignedIssue) {
    final endIndex = assignedIssue.url.lastIndexOf('/issues/');
    return assignedIssue.url.substring(29, endIndex);
  }
}
