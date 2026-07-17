import 'package:flutter/material.dart';
import '../../../core/t.dart';
import '../../../database/app_database.dart';
import '../../profile/presentation/profile_page.dart';
import '../../../core/app_settings.dart';
import '../../../services/sync_service.dart';
import '../../../services/connectivity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/presentation/login_page.dart';



class SettingsPage extends StatefulWidget {
  final AppDatabase database;

  const SettingsPage({
    super.key,
    required this.database,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}



class _SettingsPageState extends State<SettingsPage> {
  bool cloudExpanded = false;
  String lastSync = T.never;


@override
void initState() {
  super.initState();

  final dt = AppSettings.lastSync;

  if (dt != null) {
    lastSync =
        "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const SizedBox(height: 10),

              const Icon(
                Icons.settings,
                size: 42,
                color: Color(0xFF1565C0),
              ),

              const SizedBox(height: 8),

              Text(
                T.settings,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              _card(
                icon: Icons.person,
                title: T.profile,
                subtitle: "",
onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProfilePage(
        database: widget.database,
      ),
    ),
  );

  if (mounted) {
    setState(() {});
  }
},              ),

              const SizedBox(height: 16),

Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Column(
    children: [

      ListTile(
        leading: const Icon(
          Icons.cloud,
          color: Color(0xFF1565C0),
        ),
        title: Text(
          T.cloud,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          cloudExpanded
              ? Icons.keyboard_arrow_up
              : Icons.keyboard_arrow_down,
        ),
        onTap: () {
          setState(() {
            cloudExpanded = !cloudExpanded;
          });
        },
      ),

      AnimatedCrossFade(
  duration: const Duration(milliseconds: 250),
  crossFadeState: cloudExpanded
      ? CrossFadeState.showSecond
      : CrossFadeState.showFirst,

  firstChild: const SizedBox.shrink(),

  secondChild: ValueListenableBuilder<bool>(
    valueListenable: ConnectivityService.online,
    builder: (context, online, _) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                Icon(
                  Icons.circle,
                  size: 14,
                  color: online ? Colors.green : Colors.red,
                ),

                const SizedBox(width: 8),

                Text(
                  online ? T.online : T.offline,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: online ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              T.lastSync,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(lastSync),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
onPressed: online
    ? () async {

        if (!await ConnectivityService.isOnline()) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(T.noInternet),
            ),
          );
          return;
        }

        await SyncService.sync(widget.database);

        final dt = AppSettings.lastSync;

                        setState(() {
                          lastSync = dt == null
                              ? T.never
                              : "${dt.day.toString().padLeft(2, '0')}/"
                                "${dt.month.toString().padLeft(2, '0')}/"
                                "${dt.year} "
                                "${dt.hour.toString().padLeft(2, '0')}:"
                                "${dt.minute.toString().padLeft(2, '0')}";
                        });

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(T.syncCompleted),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.sync),
                label: Text(T.sync),
              ),
            ),
          ],
        ),
      );
    },
  ),
),
                ],
              ),

),
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),
  child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.info_outline,
              color: Color(0xFF1565C0),
            ),
            const SizedBox(width: 10),
            Text(
              T.information,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text("FishingTrack App"),
        Text("${T.version} ${AppSettings.appVersion}"),  
        const Text("© 2026 Leandro Barchiesi"),
      ],
    ),
  ),
),
              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: Text(T.logout),
onPressed: () async {
  final conferma = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Logout"),
        content: const Text(
          "Are you sure you want to sign out?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Logout"),
          ),
        ],
      );
    },
  );

  if (conferma != true) return;

  await Supabase.instance.client.auth.signOut();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginPage(),
    ),
    (route) => false,
  );
},                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF1565C0),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}