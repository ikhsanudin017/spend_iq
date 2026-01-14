import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/router/app_router.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../core/utils/responsive.dart';
import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';
import '../../../domain/entities/alert_item.dart';
import '../../../domain/usecases/get_forecast.dart';
import '../../../services/predictive_engine.dart';
import '../../../services/gemini_service.dart';
import 'chat_ai_controller.dart';

class ChatMessage {
  const ChatMessage({
    required this.isUser,
    required this.message,
    required this.timestamp,
  });

  final bool isUser;
  final String message;
  final DateTime timestamp;
}

class ChatController extends StateNotifier<List<ChatMessage>> {
  ChatController(this._ref)
      : super([
          ChatMessage(
            isUser: false,
            message:
                'Hai! Saya Spend-IQ AI. Tanya apa saja tentang forecast, alert, atau strategi menabung.',
            timestamp: DateTime.now(),
          ),
        ]);

  final Ref _ref;

  Future<void> send(
    String content, {
    String? assistantMessage,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;
    final now = DateTime.now();
    state = [
      ...state,
      ChatMessage(isUser: true, message: trimmed, timestamp: now),
    ];
    if (assistantMessage != null) {
      state = [
        ...state,
        ChatMessage(
          isUser: false,
          message: assistantMessage,
          timestamp: DateTime.now(),
        ),
      ];
      return;
    }
    final reply = await _generateReply(trimmed);
    state = [...state, reply];
  }

  Future<ChatMessage> _generateReply(String content) async {
    // Coba gunakan Gemini AI terlebih dahulu
    final geminiService = _ref.read(geminiServiceProvider);
    
    // Selalu coba Gemini AI dulu, bahkan jika isAvailable false (untuk debugging)
    try {
      // Ambil context finansial untuk memberikan konteks yang lebih baik
      final repository = _ref.read(financeRepositoryProvider);
      final engine = _ref.read(predictiveEngineProvider);
      
      final accounts = await repository.getAccounts();
      final transactions = await repository.getRecentTransactions();
      final goals = await repository.getGoals();
      
      final totalBalance = accounts.fold<double>(0, (sum, acc) => sum + acc.balance);
      final healthScore = engine.healthScore(
        accounts: accounts,
        transactions: transactions,
        goals: goals,
      );
      
      final context = {
        'totalBalance': totalBalance.toInt(),
        'healthScore': healthScore,
        'recentTransactions': transactions.length,
      };
      
      // Selalu coba Gemini AI, service akan handle fallback sendiri
      final aiResponse = await geminiService.generateResponse(content, context: context);
      
      return ChatMessage(
        isUser: false,
        message: aiResponse,
        timestamp: DateTime.now(),
      );
    } catch (e, stackTrace) {
      // Fallback ke logic lama jika Gemini error
      if (kDebugMode) {
        debugPrint('⚠️ Error in _generateReply: $e');
        debugPrint('Stack trace: $stackTrace');
      }
    }
    
    // Fallback ke logic lama jika Gemini tidak tersedia
    final repository = _ref.read(financeRepositoryProvider);
    final engine = _ref.read(predictiveEngineProvider);
    final lower = content.toLowerCase();

    if (lower.contains('health') || lower.contains('kesehatan')) {
      final accounts = await repository.getAccounts();
      final transactions = await repository.getRecentTransactions();
      final goals = await repository.getGoals();
      final score = engine.healthScore(
        accounts: accounts,
        transactions: transactions,
        goals: goals,
      );
      return ChatMessage(
        isUser: false,
        message:
            'Skor kesehatan finansial kamu $score dari 100. Jaga dana darurat minimal 3x pengeluaran bulanan agar tetap aman.',
        timestamp: DateTime.now(),
      );
    }

    if (lower.contains('forecast') || lower.contains('prediksi')) {
      final forecast = await _ref.read(getForecastProvider(7).future);
      final riskyDays = forecast
          .where((point) => point.risky)
          .map((point) => DateUtilsX.formatShort(point.date));
      final info = riskyDays.isEmpty
          ? 'Tidak ada hari risiko tinggi minggu ini.'
          : 'Perhatikan hari ${riskyDays.join(', ')} karena mendekati batas aman.';
      return ChatMessage(
        isUser: false,
        message:
            'Forecast 7 hari rata-rata ${CurrencyUtils.format(forecast.first.predictedSpend)} per hari. $info',
        timestamp: DateTime.now(),
      );
    }

    if (lower.contains('alerts') || lower.contains('tagihan')) {
      final alerts = await repository.getAlerts();
      final bills = alerts
          .where((alert) => alert.type == AlertType.bill)
          .take(2)
          .map((alert) =>
              '${alert.title} pada ${DateUtilsX.formatShort(alert.date)}');
      final summary = bills.isEmpty
          ? 'Tidak ada tagihan dalam waktu dekat.'
          : bills.join(', ');
      return ChatMessage(
        isUser: false,
        message: 'Berikut tagihan yang perlu diperhatikan: $summary',
        timestamp: DateTime.now(),
      );
    }

    final autosave = await repository.getAutosavePlans();
    final suggestion = autosave.isEmpty
        ? 'Aktifkan mode Safe Days di tab Autosave untuk rekomendasi tanggal menabung.'
        : 'Jadwal autosave terdekat ${DateUtilsX.formatShort(autosave.first.date)} sebesar ${CurrencyUtils.format(autosave.first.amount)}.';
    return ChatMessage(
      isUser: false,
      message: 'Berikut insight yang bisa kamu lakukan: $suggestion',
      timestamp: DateTime.now(),
    );
  }
}

final chatControllerProvider =
    StateNotifierProvider<ChatController, List<ChatMessage>>(
  ChatController.new,
);

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Scroll ke bawah dengan multiple attempts untuk memastikan selalu berhasil
  void _scrollToBottom({bool force = false}) {
    if (!_scrollController.hasClients && !force) return;
    
    // Function untuk melakukan scroll
    void doScroll() {
      if (!mounted || !_scrollController.hasClients) return;
      
      try {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        
        // Jika sudah di akhir (dalam 20px), tidak perlu scroll
        if (maxScroll > 0 && (maxScroll - currentScroll).abs() < 20) {
          return;
        }
        
        // Selalu gunakan jumpTo untuk lebih reliable dan cepat
        _scrollController.jumpTo(maxScroll);
      } catch (e) {
        // Ignore scroll errors
      }
    }
    
    // Attempt 1: Immediate dengan postFrameCallback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      doScroll();
    });
    
    // Attempt 2: Setelah delay pendek (untuk memastikan UI sudah update)
    Future<void>.delayed(const Duration(milliseconds: 50), () {
      if (mounted) doScroll();
    });
    
    // Attempt 3: Setelah delay lebih lama (untuk AI response yang panjang)
    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (mounted) doScroll();
    });
    
    // Attempt 4: Final attempt setelah delay lebih lama lagi
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (mounted) doScroll();
    });
  }

  Future<void> _send(String message) async {
    await ref.read(chatControllerProvider.notifier).send(message);
    // Scroll manual setelah send (untuk pesan user)
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isMobileSmall = ResponsiveUtils.isMobileSmall(context);
    
    // Watch messages untuk auto scroll
    final messages = ref.watch(chatControllerProvider);
    
    // Track perubahan message count dan auto-scroll
    if (messages.length != _lastMessageCount) {
      final wasEmpty = _lastMessageCount == 0;
      final isNewMessage = messages.length > _lastMessageCount;
      _lastMessageCount = messages.length;
      
      if (isNewMessage && !wasEmpty) {
        // Cek apakah pesan terakhir adalah dari AI
        final lastMessage = messages.last;
        final isAiMessage = !lastMessage.isUser;
        
        // Scroll dengan multiple attempts, lebih agresif untuk AI response
        if (isAiMessage) {
          // AI response: lebih banyak attempts dengan delay lebih lama
          Future<void>.delayed(const Duration(milliseconds: 200), () {
            if (mounted) _scrollToBottom();
          });
          Future<void>.delayed(const Duration(milliseconds: 500), () {
            if (mounted) _scrollToBottom();
          });
          Future<void>.delayed(const Duration(milliseconds: 1000), () {
            if (mounted) _scrollToBottom();
          });
        } else {
          // User message: scroll lebih cepat
          Future<void>.delayed(const Duration(milliseconds: 100), () {
            if (mounted) _scrollToBottom();
          });
        }
      }
    }
    
    // Listen untuk perubahan messages sebagai backup
    ref.listen<List<ChatMessage>>(chatControllerProvider, (previous, next) {
      if (previous != null && next.length > previous.length) {
        final lastMessage = next.last;
        final isAiMessage = !lastMessage.isUser;
        
        if (isAiMessage) {
          // Multiple attempts untuk AI response
          Future<void>.delayed(const Duration(milliseconds: 300), () {
            if (mounted) _scrollToBottom();
          });
          Future<void>.delayed(const Duration(milliseconds: 700), () {
            if (mounted) _scrollToBottom();
          });
          Future<void>.delayed(const Duration(milliseconds: 1200), () {
            if (mounted) _scrollToBottom();
          });
        } else {
          Future<void>.delayed(const Duration(milliseconds: 150), () {
            if (mounted) _scrollToBottom();
          });
        }
      }
    });

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Spend-IQ Chat',
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, isTablet ? 20 : 18),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Profil',
            icon: Icon(
              Icons.person_outline,
              size: ResponsiveUtils.iconSize(context, base: isTablet ? 28 : 24),
            ),
            onPressed: () => context.push(AppRoute.profile.path),
          ),
        ],
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          
          // Responsive padding dan spacing
          final horizontalPadding = ResponsiveUtils.horizontalPadding(context);
          final verticalSpacing = ResponsiveUtils.spacing(context);
          final maxContentWidth = ResponsiveUtils.maxContentWidth(context);
          
          return Column(
            children: [
              // Welcome Banner - Responsive
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalSpacing,
                  horizontalPadding,
                  verticalSpacing * 0.75,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.spacing(context, base: isTablet ? 20 : 16),
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(context, base: isTablet ? 16 : 12),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(
                            ResponsiveUtils.spacing(context, base: isTablet ? 12 : 8),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(36),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.smart_toy_rounded,
                            color: Colors.white,
                            size: ResponsiveUtils.iconSize(
                              context,
                              base: isTablet ? 32 : 24,
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Spend-IQ AI siap membantu',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    isTablet ? 18 : 16,
                                  ),
                                ),
                              ),
                              SizedBox(height: verticalSpacing * 0.5),
                              Text(
                                'Gunakan Quick Ask di bawah untuk mendapatkan insight instan tentang cashflow, alert, atau rencana saving.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withAlpha(220),
                                  fontSize: ResponsiveUtils.fontSize(
                                    context,
                                    isTablet ? 14 : 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Chat Messages - Responsive
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isUser = message.isUser;
                        final alignment =
                            isUser ? Alignment.centerRight : Alignment.centerLeft;
                        final bubbleColor = isUser
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface;
                        final textColor =
                            isUser ? Colors.white : theme.colorScheme.onSurface;
                        
                        // Responsive bubble width
                        final maxBubbleWidth = isTablet
                            ? constraints.maxWidth * 0.6
                            : isMobileSmall
                                ? constraints.maxWidth * 0.75
                                : constraints.maxWidth * 0.7;

                        return Align(
                          alignment: alignment,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
                            margin: EdgeInsets.only(
                              top: verticalSpacing * 0.5,
                              bottom: verticalSpacing * 0.5,
                              left: isUser
                                  ? ResponsiveUtils.spacing(context, base: isTablet ? 60 : 40)
                                  : 0,
                              right: isUser
                                  ? 0
                                  : ResponsiveUtils.spacing(context, base: isTablet ? 60 : 40),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: ResponsiveUtils.spacing(
                                context,
                                base: isTablet ? 16 : 12,
                              ),
                              vertical: ResponsiveUtils.spacing(
                                context,
                                base: isTablet ? 14 : 10,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  ResponsiveUtils.borderRadius(context, base: isTablet ? 16 : 12),
                                ),
                                topRight: Radius.circular(
                                  ResponsiveUtils.borderRadius(context, base: isTablet ? 16 : 12),
                                ),
                                bottomLeft: Radius.circular(
                                  isUser
                                      ? ResponsiveUtils.borderRadius(context, base: isTablet ? 16 : 12)
                                      : ResponsiveUtils.borderRadius(context, base: isTablet ? 6 : 4),
                                ),
                                bottomRight: Radius.circular(
                                  isUser
                                      ? ResponsiveUtils.borderRadius(context, base: isTablet ? 6 : 4)
                                      : ResponsiveUtils.borderRadius(context, base: isTablet ? 16 : 12),
                                ),
                              ),
                              boxShadow: isUser
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withAlpha(40),
                                        blurRadius: isTablet ? 20 : 16,
                                        offset: const Offset(0, 10),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(12),
                                        blurRadius: isTablet ? 18 : 14,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.message,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                    fontSize: ResponsiveUtils.fontSize(
                                      context,
                                      isTablet ? 16 : 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: verticalSpacing * 0.5),
                                Text(
                                  DateUtilsX.formatShort(message.timestamp),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: textColor.withAlpha(180),
                                    fontSize: ResponsiveUtils.fontSize(
                                      context,
                                      isTablet ? 12 : 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              
              // Quick Ask Chips - Horizontal Scrollable
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  verticalSpacing,
                  horizontalPadding,
                  verticalSpacing,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'Skor kesehatan finansial?',
                        'Forecast belanja minggu ini',
                        'Tagihan terdekat',
                        'Rekomendasi menabung',
                      ]
                          .map((text) => Padding(
                                padding: EdgeInsets.only(
                                  right: ResponsiveUtils.spacing(
                                    context,
                                    base: isTablet ? 12 : 8,
                                  ),
                                ),
                                child: ActionChip(
                                  label: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.fontSize(
                                        context,
                                        isTablet ? 14 : 12,
                                      ),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.spacing(
                                      context,
                                      base: isTablet ? 12 : 8,
                                    ),
                                    vertical: ResponsiveUtils.spacing(
                                      context,
                                      base: isTablet ? 6 : 4,
                                    ),
                                  ),
                                  onPressed: () async {
                                    await ref
                                        .read(chatControllerProvider.notifier)
                                        .send(text);
                                    
                                    // Scroll setelah mengirim pesan
                                    await Future<void>.delayed(const Duration(milliseconds: 300));
                                    _scrollToBottom();
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              
              // Input Field - Responsive
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  ResponsiveUtils.verticalPadding(context) + 
                      (MediaQuery.of(context).padding.bottom > 0 
                          ? MediaQuery.of(context).padding.bottom 
                          : verticalSpacing),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.spacing(
                        context,
                        base: isTablet ? 16 : 12,
                      ),
                      vertical: ResponsiveUtils.spacing(
                        context,
                        base: isTablet ? 12 : 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.borderRadius(context, base: isTablet ? 16 : 12),
                      ),
                      border: Border.all(color: AppColors.surfaceAlt),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x151E3A8A),
                          blurRadius: 16,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Tanyakan Spend-IQ AI...',
                              hintStyle: TextStyle(
                                fontSize: ResponsiveUtils.fontSize(
                                  context,
                                  isTablet ? 16 : 14,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: ResponsiveUtils.fontSize(
                                context,
                                isTablet ? 16 : 14,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              _send(value);
                              _controller.clear();
                            },
                          ),
                        ),
                        SizedBox(
                          width: ResponsiveUtils.spacing(context, base: isTablet ? 12 : 8),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.all(
                              ResponsiveUtils.spacing(context, base: isTablet ? 12 : 8),
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            final text = _controller.text;
                            _controller.clear();
                            _send(text);
                          },
                          child: Icon(
                            Icons.send_rounded,
                            size: ResponsiveUtils.iconSize(
                              context,
                              base: isTablet ? 28 : 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}





