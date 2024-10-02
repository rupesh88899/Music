import 'package:flutter/material.dart';
import 'package:music/models/Permission_service.dart';
import 'package:music/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S E T T I N G S'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade500,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //dark mode
                const Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),

                //switch
                Switch(
                  value: Provider.of<ThemeProvider>(context, listen: false)
                      .isDarkMode,
                  onChanged: (value) =>
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggletheme(),
                ),
              ],
            ),
          ),

//storage permission tile
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () {
                permissionChecker();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 60), // Width: 200, Height: 60
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 22),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                foregroundColor: Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.white // White text in dark mode
                    : const Color.fromARGB(
                        255, 0, 0, 0), // Grey text in light mode
              ),
              child: const Text(
                "Storage Permission",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
