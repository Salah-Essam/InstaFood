import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
// Removed dummy chat seed; we'll load cached messages per user instead
import 'package:insta_food/presentation/features/Help/presentation/widgets/chat_bubble_widget.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/app_text_field_drawer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'AGENT_BASE_URL',
        defaultValue: 'http://127.0.0.1:8787',
      ),
      connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 90),
    ),
  );

  bool _loadedFromCache = false;

  String _cacheKey(String uid) => 'chat_messages:$uid';

  Future<void> _loadCachedMessages(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cacheKey(uid));
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> arr = jsonDecode(raw);
        final list = arr.whereType<Map>().map((m) => m.map((k, v) => MapEntry(k.toString(), v))).toList();
        if (!mounted) return;
        setState(() {
          _messages
            ..clear()
            ..addAll(list.cast<Map<String, dynamic>>());
        });
      }
    } catch (_) {
      // ignore cache errors
    }
  }

  Future<void> _saveCachedMessages(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey(uid), jsonEncode(_messages));
    } catch (_) {
      // ignore cache errors
    }
  }

  Future<void> _ensureLoadedOnce() async {
    if (_loadedFromCache) return;
    final auth = context.read<AuthCubit>().state;
    final uid = auth is Authenticated ? (auth.user.id ?? '') : '';
    if (uid.isEmpty) return;
    _loadedFromCache = true;
    await _loadCachedMessages(uid);
  }

  @override
  void initState() {
    super.initState();
    // Defer reading Bloc until first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureLoadedOnce();
    });
  }

  void _sendMessage(bool isMe) {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({'text': text, 'isMe': isMe, 'ts': DateTime.now().millisecondsSinceEpoch});
        _controller.clear();
      });
      final auth = context.read<AuthCubit>().state;
      final uid = auth is Authenticated ? (auth.user.id ?? '') : '';
      if (uid.isNotEmpty) {
        _saveCachedMessages(uid);
      }
      _callAgent(text);
    }
  }

  Future<void> _callAgent(String userText) async {
    final auth = context.read<AuthCubit>().state;
    final uid = auth is Authenticated ? (auth.user.id ?? '') : '';
    if (uid.isEmpty) {
      setState(() {
        _messages.add({
          'text': 'Please log in to use AI assistant.',
          'isMe': false,
          'ts': DateTime.now().millisecondsSinceEpoch,
        });
      });
      return;
    }
    try {
      final resp = await _dio.post(
        '/chat',
        data: {'userId': uid, 'message': userText},
      );
      final reply = resp.data['reply']?.toString() ?? 'No reply';
      if (!mounted) return;
      setState(() {
        _messages.add({'text': reply, 'isMe': false, 'ts': DateTime.now().millisecondsSinceEpoch});
      });
      _saveCachedMessages(uid);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({'text': 'Agent error: $e', 'isMe': false, 'ts': DateTime.now().millisecondsSinceEpoch});
      });
      _saveCachedMessages(uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          _ensureLoadedOnce();
        }
      },
      child: Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) => ChatBubbleWidget(
              isMe: _messages[index]['isMe'],
              text: _messages[index]['text'],
            ),
          ),
        ),

        SizedBox(
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.lightOrange),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  InkWell(child: SvgPicture.asset(AppAssets.attachIcon)),
                  SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 30,
                      child: AppTextFieldDrawer(
                        controller: _controller,
                        hint: "Write Here ... ",
                        hintStyle: AppTextStyles.fontBlackSmall,
                        maxLines: 1,
                        // maxLength: 30,
                        height: 30,
                        backgroundColor: AppColors.white,
                        onChange: (v) {},
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(child: SvgPicture.asset(AppAssets.microphoneIcon)),
                  SizedBox(width: 8),
                  InkWell(
                    child: SvgPicture.asset(AppAssets.sendIcon),
                    onTap: () {
                      _sendMessage(true);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
  ),
  );
  }
}
