import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/mehrab_bloc.dart';

class ChildrenScreen extends StatelessWidget {
  const ChildrenScreen({super.key});

  final List<Map<String, String>> stories = const [
    {
      "title": "Nuh's (AS) Great Ark",
      "ayat": "Allah protected Prophet Nuh (AS) and the animals inside the majestic ark.",
      "moral": "Always have complete faith in Allah's Divine planning."
    },
    {
      "title": "Yunus (AS) & the Whale",
      "ayat": "Prophet Yunus (AS) prayed with sincerity inside the belly of the whale and was forgiven.",
      "moral": "Sincere prayer resolves all hardships."
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MehrabBloc, MehrabState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Kids Prayer Adventure", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Earn crowns for reciting daily prayers!", style: TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.workspace_premium, color: Colors.amber, size: 28),
                        const SizedBox(width: 4),
                        Text("${state.kidsPoints} CP", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.black)),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text("DAILY PRAYERS", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...state.kidsPrayers.keys.map((prayer) {
                bool done = state.kidsPrayers[prayer] ?? false;
                return Card(
                  elevation: done ? 4 : 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: done ? theme.colorScheme.secondary.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                      child: Icon(done ? Icons.star : Icons.star_border, color: done ? theme.colorScheme.secondary : Colors.grey),
                    ),
                    title: Text(prayer, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(done ? "Recorded! +10 Crown Points reward" : "Track this prayer now"),
                    trailing: Switch(
                      value: done,
                      onChanged: (v) {
                        context.read<MehrabBloc>().add(RecordKidsPrayerEvent(prayer));
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              Text("PROPHETIC ADVENTURES", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...stories.map((st) => Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(st["title"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const Icon(Icons.import_contacts, color: Colors.teal),
                            ],
                          ),
                          const Divider(),
                          Text(st["ayat"]!, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.palette, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "Moral Lesson: ${st["moral"]!}",
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
