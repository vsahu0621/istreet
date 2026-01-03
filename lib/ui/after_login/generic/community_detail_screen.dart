import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:istreet/data/models/generic/community_detail_model.dart';
import 'package:istreet/data/services/generic/community_service.dart';
import 'package:istreet/providers/auth_provider.dart';
import 'package:istreet/providers/generic/community_detail_provider.dart';
import 'package:istreet/ui/navigation/bottom_nav.dart';
import 'community_info_screen.dart';

class CommunityDetailScreen extends ConsumerStatefulWidget {
  final int communityId;
  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  ConsumerState<CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends ConsumerState<CommunityDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _showEmojiPicker = false;

  /// 🔥 LOCAL MESSAGE LIST (OPTIMISTIC UI)
  List<Message> _localMessages = [];

  final List<String> _emojis = [
    '😀',
    '😊',
    '😇',
    '🥰',
    '👍',
    '👌',
    '❤️',
    '🎉',
    '🎁',
    '🏆',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _insertEmoji(String emoji) {
    final text = _messageController.text;
    final selection = _messageController.selection;
    final newText = text.replaceRange(selection.start, selection.end, emoji);
    _messageController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.start + emoji.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(communityDetailProvider(widget.communityId));
    final myUserId = ref.watch(authProvider).userId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          /// 🔥 Merge API messages + local sent messages
          final apiMessages = data.messages;

          final localOnly = _localMessages.where(
            (m) => !apiMessages.any((api) => api.id == m.id),
          );

          final messages = [...apiMessages, ...localOnly];

          return Column(
            children: [
              // ================= TOP BAR =================
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.groups,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            communityNavKey.currentState?.push(
                              MaterialPageRoute(
                                builder: (_) => CommunityInfoScreen(
                                  communityId: widget.communityId,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${data.membersCount} members',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ================= CHAT LIST =================
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    // final message = messages[index];
                    final message = messages[messages.length - 1 - index];

                    /// ✅ REAL LOGIC (NO FAKE INDEX LOGIC)
                    final isSentByMe =
                        message.senderId != null &&
                        message.senderId == myUserId;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: isSentByMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isSentByMe)
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors
                                  .primaries[index % Colors.primaries.length]
                                  .withOpacity(0.2),
                              child: Text(
                                message.sender[0].toUpperCase(),
                                style: TextStyle(
                                  color:
                                      Colors.primaries[index %
                                          Colors.primaries.length],
                                ),
                              ),
                            ),
                          const SizedBox(width: 6),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSentByMe
                                  ? const Color(0xFFDCF8C6)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isSentByMe)
                                  Text(
                                    message.sender,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                Text(message.text),
                                const SizedBox(height: 4),
                                Text(
                                  message.createdAt,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ================= EMOJI PICKER =================
              if (_showEmojiPicker)
                Container(
                  height: 220,
                  color: Colors.grey[100],
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: _emojis.length,
                    itemBuilder: (_, i) => InkWell(
                      onTap: () {
                        if (detail.hasValue && !detail.value!.canSendMessages) {
                          // 🔥 Reaction-only mode → direct send
                          _sendReaction(_emojis[i]);
                        } else {
                          // Text allowed → emoji insert in input
                          _insertEmoji(_emojis[i]);
                        }
                      },

                      child: Center(
                        child: Text(
                          _emojis[i],
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  ),
                ),

              // ================= INPUT =================
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: SafeArea(
                  child: data.canSendMessages
                      ? _chatInputAllowed(context)
                      : _reactionOnlyInput(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= CHAT INPUT =================
  Widget _chatInputAllowed(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showEmojiPicker
                        ? Icons.keyboard
                        : Icons.emoji_emotions_outlined,
                  ),
                  onPressed: () {
                    setState(() => _showEmojiPicker = !_showEmojiPicker);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).primaryColor,
          child: IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ),
      ],
    );
  }

  // ================= SEND MESSAGE =================
  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    final msg = await CommunityService.sendCommunityMessage(
      communityId: widget.communityId,
      message: text,
      type: "text",
    );

    if (msg != null) {
      setState(() {
        _localMessages.add(msg); // 🔥 instant UI update
      });
    }
  }

  // ================= SEND REACTION =================
  Future<void> _sendReaction(String emoji) async {
    final msg = await CommunityService.sendCommunityMessage(
      communityId: widget.communityId,
      message: emoji,
      type: "reaction", // 🔥 IMPORTANT
    );

    if (msg != null) {
      setState(() {
        _localMessages.add(msg);
        _showEmojiPicker = false;
      });
    }
  }

  // ================= REACTION ONLY =================
  Widget _reactionOnlyInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              "Only reactions allowed",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
          ),
          onPressed: () {
            FocusScope.of(context).unfocus(); // keyboard band
            setState(() {
              _showEmojiPicker = !_showEmojiPicker; // 🔥 TOGGLE
            });
          },
        ),
      ],
    );
  }
}
