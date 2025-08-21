import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/section_card.dart';
import '../widgets/switch_tile.dart';
import '../widgets/slack_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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

  Future<void> _setBool(String key, bool value) async => await _prefs.setBool(key, value);
  Future<void> _setInt(String key, int value) async => await _prefs.setInt(key, value);

  String get slackLabel {
    switch (slackMode) {
      case 1: return 'Mentions';
      case 2: return 'All';
      default: return 'Off';
    }
  }

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
              SlackOption(label: 'Off', selected: slackMode == 0, onTap: () => Navigator.pop(ctx, 0)),
              SlackOption(label: 'Mentions', selected: slackMode == 1, onTap: () => Navigator.pop(ctx, 1)),
              SlackOption(label: 'All', selected: slackMode == 2, onTap: () => Navigator.pop(ctx, 2)),
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
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Text('Notifications', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          SectionCard(children: [
            SwitchTile(
              title: 'Mobile push notifications',
              subtitle: 'Receive push notifications on mentions and comments via your mobile app',
              value: mobilePush,
              onChanged: (v) { setState(() => mobilePush = v); _setBool(_kMobilePush, v); },
            ),
            SwitchTile(
              title: 'Activity in your workspace',
              subtitle: 'Receive emails for workspace activity',
              value: activityWorkspace,
              onChanged: (v) { setState(() => activityWorkspace = v); _setBool(_kActivityWorkspace, v); },
            ),
            SlackTile(
              title: 'Slack notifications',
              subtitle: 'Receive notifications in Slack when mentioned',
              valueLabel: slackLabel,
              onTap: _pickSlackMode,
            ),
          ]),
        ],
      ),
    );
  }
}
