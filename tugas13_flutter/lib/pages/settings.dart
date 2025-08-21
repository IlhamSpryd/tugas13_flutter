import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Keys for persistence
  static const _kMobilePush = 'notif_mobile_push';
  static const _kActivityWorkspace = 'notif_activity_workspace';
  static const _kAlwaysEmail = 'notif_always_email';
  static const _kPageUpdates = 'notif_page_updates';
  static const _kWorkspaceDigest = 'notif_workspace_digest';
  static const _kSlackNotif = 'notif_slack_mode';

  bool mobilePush = true;
  bool activityWorkspace = true;
  bool alwaysEmail = false;
  bool pageUpdates = true;
  bool workspaceDigest = true;

  int slackMode = 0;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      mobilePush = _prefs.getBool(_kMobilePush) ?? true;
      activityWorkspace = _prefs.getBool(_kActivityWorkspace) ?? true;
      alwaysEmail = _prefs.getBool(_kAlwaysEmail) ?? false;
      pageUpdates = _prefs.getBool(_kPageUpdates) ?? true;
      workspaceDigest = _prefs.getBool(_kWorkspaceDigest) ?? true;
      slackMode = _prefs.getInt(_kSlackNotif) ?? 0;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> _setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text(
            "Apakah kamu yakin ingin menghapus akunmu? Semua data akan hilang.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }
  }

  String get slackLabel {
    switch (slackMode) {
      case 1:
        return 'Mentions';
      case 2:
        return 'All';
      default:
        return 'Off';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 8),
          Text(
            'Notifications',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _SectionCard(
            children: [
              _SwitchTile(
                title: 'Mobile push notifications',
                subtitle:
                    'Receive push notifications on mentions and comments via your mobile app',
                value: mobilePush,
                onChanged: (v) {
                  setState(() => mobilePush = v);
                  _setBool(_kMobilePush, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Activity in your workspace',
                subtitle:
                    'Receive emails when you get comments, mentions, page invites, reminders, access requests, and property changes',
                value: activityWorkspace,
                onChanged: (v) {
                  setState(() => activityWorkspace = v);
                  _setBool(_kActivityWorkspace, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Always send email notifications',
                subtitle:
                    'Receive emails about activity in your workspace, even when you’re active on the app',
                value: alwaysEmail,
                onChanged: (v) {
                  setState(() => alwaysEmail = v);
                  _setBool(_kAlwaysEmail, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Page updates',
                subtitle:
                    'Receive email digests for changes to pages you’re subscribed to',
                value: pageUpdates,
                onChanged: (v) {
                  setState(() => pageUpdates = v);
                  _setBool(_kPageUpdates, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Workspace digest',
                subtitle:
                    'Receive email digests of what’s happening in your workspace',
                value: workspaceDigest,
                onChanged: (v) {
                  setState(() => workspaceDigest = v);
                  _setBool(_kWorkspaceDigest, v);
                },
              ),
              _divider(),
              _SlackTile(
                title: 'Slack notifications',
                subtitle:
                    'Receive notifications in your Slack workspace when you’re mentioned in a page, database property, or comment',
                valueLabel: slackLabel,
                onTap: _pickSlackMode,
              ),
              _divider(),
              _SlackTile(
                title: 'Announcements and update emails',
                subtitle:
                    'Receive notifications in your Slack workspace when you’re mentioned in a page, database property, or comment',
                valueLabel: slackLabel,
                onTap: _pickSlackMode,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Preferences',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(height: 8),
          _SectionCard(
            children: [
              _SwitchTile(
                title: 'Password',
                subtitle:
                    'Receive push notifications on mentions and comments via your mobile app',
                value: mobilePush,
                onChanged: (v) {
                  setState(() => mobilePush = v);
                  _setBool(_kMobilePush, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Passkeys',
                subtitle:
                    'Receive emails when you get comments, mentions, page invites, reminders, access requests, and property changes',
                value: activityWorkspace,
                onChanged: (v) {
                  setState(() => activityWorkspace = v);
                  _setBool(_kActivityWorkspace, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Appreance',
                subtitle:
                    'Receive emails about activity in your workspace, even when you’re active on the app',
                value: alwaysEmail,
                onChanged: (v) {
                  setState(() => alwaysEmail = v);
                  _setBool(_kAlwaysEmail, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'External links',
                subtitle:
                    'Receive email digests for changes to pages you’re subscribed to',
                value: pageUpdates,
                onChanged: (v) {
                  setState(() => pageUpdates = v);
                  _setBool(_kPageUpdates, v);
                },
              ),
              _divider(),
              _SwitchTile(
                title: 'Support access',
                subtitle:
                    'Receive email digests of what’s happening in your workspace',
                value: workspaceDigest,
                onChanged: (v) {
                  setState(() => workspaceDigest = v);
                  _setBool(_kWorkspaceDigest, v);
                },
              ),
              _divider(),
              _SlackTile(
                title: 'Start week on Monday',
                subtitle:
                    'Receive notifications in your Slack workspace when you’re mentioned in a page, database property, or comment',
                valueLabel: slackLabel,
                onTap: _pickSlackMode,
              ),
              _divider(),
              _SlackTile(
                title: 'Delete my account',
                subtitle:
                    'Permanently delete the account and remove acces from all workspaces.',
                valueLabel: '',
                onTap: _deleteAccount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1);

  Future<void> _pickSlackMode() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SlackOption(
                label: 'Off',
                selected: slackMode == 0,
                onTap: () => Navigator.pop(ctx, 0),
              ),
              _SlackOption(
                label: 'Mentions',
                selected: slackMode == 1,
                onTap: () => Navigator.pop(ctx, 1),
              ),
              _SlackOption(
                label: 'All',
                selected: slackMode == 2,
                onTap: () => Navigator.pop(ctx, 2),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() => slackMode = result);
      _setInt(_kSlackNotif, result);
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(children: children),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade700, height: 1.2),
        ),
      ),
      dense: false,
    );
  }
}

class _SlackTile extends StatelessWidget {
  const _SlackTile({
    required this.title,
    required this.subtitle,
    required this.valueLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade700, height: 1.2),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(valueLabel, style: TextStyle(color: Colors.grey.shade800)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}

class _SlackOption extends StatelessWidget {
  const _SlackOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label),
      trailing: selected ? const Icon(Icons.check) : null,
    );
  }
}
