import 'package:flutter/material.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'recycle_bin_page.dart';
import 'folders_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 70, //WHAT DO I EVWN SAY IN THE HEADER AND ASK SQUISHY HOW TO CHANGE ITS COLOR
              color: Colors.lightGreen,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(8),
              child: const Text('uhhhh tittle titty title? '), // figure out title you bum, maybe you can have it say willow or something
            ),

            //ACTION BUTTON ICON BLRH BUHF
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // setting page open
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SettingsPage()),
                      );
                    },
                    icon: const Icon(Icons.settings, color: Colors.black),
                    label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Setings',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: () {
                      // open recycle bin
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RecycleBinPage()),
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.black),
                    label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'recycle bin',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: () {
                      // new folder i think?
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const FoldersPage()),
                      );
                    },
                    icon: const Icon(Icons.folder_copy, color: Colors.black),
                    label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Folders',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        // searchy searchy
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            enabled: true, // now interactive
            onChanged: (value) {
              // you can use this to filter data, etc.
              print('Search input: $value');
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('FILE FILE FILE FILE')),
    );
  }
}
