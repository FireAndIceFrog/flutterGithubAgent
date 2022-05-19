import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:github/github.dart';
import 'package:github_agent/Widgets/github_summary/assigned_issues_list.dart';
import 'package:github_agent/Widgets/github_summary/launch_url.dart';
import 'package:github_agent/Widgets/github_summary/pull_requests_list.dart';
import 'package:github_agent/Widgets/github_summary/repositories_list.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Repository/github_login_agent_repository.dart';

class GitHubSummary extends HookConsumerWidget {
  const GitHubSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final github = ref.watch(githubLoginProvider);
    return Row(
      children: [
        NavigationRail(
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) {
            selectedIndex.value = index;
          },
          labelType: NavigationRailLabelType.selected,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Octicons.repo),
              label: Text('Repositories'),
            ),
            NavigationRailDestination(
              icon: Icon(Octicons.issue_opened),
              label: Text('Assigned Issues'),
            ),
            NavigationRailDestination(
              icon: Icon(Octicons.git_pull_request),
              label: Text('Pull Requests'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        // This is the main content.
        Expanded(
          child: IndexedStack(
            index: selectedIndex.value,
            children: (github == null) ? [] :
            [
              const RepositoriesList(),
              const AssignedIssuesList(),
              const PullRequestsList()
            ],
          ),
        ),
      ],
    );
  }
}
