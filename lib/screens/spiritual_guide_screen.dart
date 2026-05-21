import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/mehrab_bloc.dart';

class SpiritualGuideScreen extends StatefulWidget {
  const SpiritualGuideScreen({super.key});

  @override
  State<SpiritualGuideScreen> createState() => _SpiritualGuideScreenState();
}

class _SpiritualGuideScreenState extends State<SpiritualGuideScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.isEmpty) return;
    context.read<MehrabBloc>().add(AskSpiritualGuideEvent(_controller.text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MehrabBloc, MehrabState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.primary.withOpacity(0.05),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, color: theme.colorScheme.secondary),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Share your emotional struggles or life situations, and Mehrab will provide comforting Qur'anic script, translated insight, and specialized Duas.",
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.guideChat.length,
                itemBuilder: (context, index) {
                  final message = state.guideChat[index];
                  final isUser = message["role"] == "user";

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? theme.colorScheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                      ),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                      child: Text(
                        message["text"] ?? "",
                        style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (state.isGuideLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "E.g., I am feeling anxious about work...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _submit,
                    icon: Icon(Icons.send, color: theme.colorScheme.primary),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
