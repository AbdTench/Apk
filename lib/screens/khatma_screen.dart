import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/mehrab_bloc.dart';

class KhatmaScreen extends StatelessWidget {
  const KhatmaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MehrabBloc, MehrabState>(
      builder: (context, state) {
        // Core Khatma math algorithm: 604 pages in Quran
        int totalPages = 604;
        int remainingPages = totalPages - state.khatmaCompletedPages;
        double dailyQuota = (remainingPages / state.khatmaTargetDays).clamp(1.0, 604.0);
        double progressRatio = state.khatmaCompletedPages / totalPages;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("KHATMA SYSTEM", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressRatio,
                        minHeight: 12,
                        backgroundColor: Colors.grey[200],
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Progress: ${(progressRatio * 100).toStringAsFixed(1)}%"),
                          Text("${state.khatmaCompletedPages}/$totalPages Pages"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: theme.colorScheme.primary.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Active Calculation Target", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Daily Quran Goal: ${dailyQuota.toStringAsFixed(1)} pages / day"),
                      Text("Remaining time frame: ${state.khatmaTargetDays} Days"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Adjust Target Duration:", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<int>(
                    value: state.khatmaTargetDays,
                    items: const [
                      DropdownMenuItem(value: 10, child: Text("10 Days")),
                      DropdownMenuItem(value: 15, child: Text("15 Days")),
                      DropdownMenuItem(value: 30, child: Text("30 Days")),
                      DropdownMenuItem(value: 60, child: Text("60 Days")),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        context.read<MehrabBloc>().add(UpdateKhatmaPlanEvent(val));
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MehrabBloc>().add(const ScrollKhatmaProgressEvent(-5));
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text("-5 Pages"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MehrabBloc>().add(const ScrollKhatmaProgressEvent(5));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("+5 Pages"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
