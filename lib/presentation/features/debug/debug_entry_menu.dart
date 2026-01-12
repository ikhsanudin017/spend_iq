import 'package:flutter/material.dart';

import '../accounts_meta/accounts_meta_list_page.dart';
import '../home/home_page.dart';
import '../profile/profile_page.dart';

class DebugEntryMenu extends StatelessWidget {
  const DebugEntryMenu({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Debug Menu')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const HomePage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('Akun & Metadata'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const AccountsMetaListPage()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profil & Koneksi Bank'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
}
