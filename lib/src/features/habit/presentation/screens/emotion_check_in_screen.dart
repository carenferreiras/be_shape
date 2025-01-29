import 'package:flutter/material.dart';

class EmotionCheckInScreen extends StatefulWidget {
  final Function(String emotion) onSaveEmotion;

  const EmotionCheckInScreen({required this.onSaveEmotion, super.key});

  @override
  State<EmotionCheckInScreen> createState() => _EmotionCheckInScreenState();
}

class _EmotionCheckInScreenState extends State<EmotionCheckInScreen> {
  final List<String> emotions = [
    'Feliz',
    'Triste',
    'Ansioso',
    'Relaxado',
    'Cansado'
  ];
  String? selectedEmotion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Como você está se sentindo?'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Selecione uma emoção:',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: emotions.length,
                itemBuilder: (context, index) {
                  final emotion = emotions[index];
                  return ListTile(
                    title: Text(
                      emotion,
                      style: TextStyle(
                        color: selectedEmotion == emotion
                            ? Colors.orange
                            : Colors.white,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedEmotion = emotion;
                      });
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedEmotion != null) {
                  widget.onSaveEmotion(selectedEmotion!);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
