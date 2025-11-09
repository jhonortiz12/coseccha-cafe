import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chatbot_controller.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../widgets/suggested_questions_widget.dart';

class ChatbotPage extends StatefulWidget {
  final String fincaId;
  final String fincaNombre;

  const ChatbotPage({
    Key? key,
    required this.fincaId,
    required this.fincaNombre,
  }) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final controller = Get.put(ChatbotController());
    controller.initializeChat(widget.fincaId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatbotController>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Asistente IA', style: TextStyle(fontSize: 18)),
            Text(
              widget.fincaNombre,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF6B4CE6),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () => controller.generateFullAnalysis(),
            tooltip: 'Análisis completo',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.clearChat(),
            tooltip: 'Limpiar chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Mensajes del chat
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

              return Column(
                children: [
                  // Preguntas sugeridas (solo si hay pocos mensajes)
                  if (controller.messages.length <= 1)
                    SuggestedQuestionsWidget(
                      onQuestionTap: (question) {
                        _messageController.text = question;
                        _sendMessage(controller);
                      },
                    ),
                  // Lista de mensajes
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return _MessageBubble(message: message);
                      },
                    ),
                  ),
                ],
              );
            }),
          ),

          // Indicador de carga
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Pensando...',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Campo de entrada
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(controller),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => FloatingActionButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => _sendMessage(controller),
                  backgroundColor: const Color(0xFF6B4CE6),
                  child: const Icon(Icons.send, color: Colors.white),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatbotController controller) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      controller.sendMessage(message);
      _messageController.clear();
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageEntity message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: const Color(0xFF6B4CE6),
              radius: 18,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF6B4CE6) : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 18,
              child: Icon(Icons.person, color: Colors.grey[700], size: 20),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
