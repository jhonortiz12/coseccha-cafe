import 'package:flutter/material.dart';

class SuggestedQuestionsWidget extends StatelessWidget {
  final Function(String) onQuestionTap;

  const SuggestedQuestionsWidget({
    Key? key,
    required this.onQuestionTap,
  }) : super(key: key);

  static const List<Map<String, dynamic>> questions = [
    {
      'icon': Icons.trending_up,
      'question': '¿Cómo puedo mejorar la productividad de mi finca?',
      'color': Colors.green,
    },
    {
      'icon': Icons.attach_money,
      'question': '¿Mis costos son normales para este tipo de cultivo?',
      'color': Colors.orange,
    },
    {
      'icon': Icons.calendar_today,
      'question': '¿Cuál es el mejor momento para cosechar?',
      'color': Colors.blue,
    },
    {
      'icon': Icons.analytics,
      'question': 'Dame un análisis de mi rentabilidad',
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Preguntas sugeridas:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return _QuestionCard(
                icon: question['icon'],
                question: question['question'],
                color: question['color'],
                onTap: () => onQuestionTap(question['question']),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final IconData icon;
  final String question;
  final Color color;
  final VoidCallback onTap;

  const _QuestionCard({
    required this.icon,
    required this.question,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
