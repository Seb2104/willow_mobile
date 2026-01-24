import 'package:flutter/material.dart';
import 'home_page.dart';

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
              height: 100, //WHAT DO I EVWN SAY IN THE HEADER AND ASK SQUISHY HOW TO CHANGE ITS COLOR
              color: Colors.lightGreen,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8),
              child: const Text('BOBIES NOM NOM NOOOOOOOOOOOOOM'),
            ),

            //ACTION BUTTON ICON BLRH BUHF
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // setting pae open
                      print('Settings pressed');
                    },
                    icon: const Icon(Icons.settings),
                    label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('setings'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: () {
                      // open recycle buin
                      print('Recycle Bin pressed');
                    },
                    icon: const Icon(Icons.delete),
                    label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('recycle bin'),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton.icon(
                    onPressed: () {
                      // new folder i think?
                      print('Forgot what this one is pressed');
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('i forgot what this one is because my book isnt with me'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Center(child: const Text('search bar here')),
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
      body: const Center(child: Text('file thingys go here')),
    );
  }
}
