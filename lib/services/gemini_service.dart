import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Service untuk integrasi Gemini AI (Gratis)
/// 
/// Untuk mendapatkan API key gratis:
/// 1. Buka https://aistudio.google.com/app/apikey
/// 2. Login dengan Google account
/// 3. Klik "Create API Key"
/// 4. Copy API key dan simpan di environment variable atau hardcode untuk testing
class GeminiService {
  GeminiService({String? apiKey}) 
      : _apiKey = apiKey ?? _defaultApiKey,
        _model = null {
    if (kDebugMode) {
      debugPrint('🔧 GeminiService constructor called');
      debugPrint('   API Key length: ${_apiKey.length}');
      debugPrint('   API Key starts with: ${_apiKey.substring(0, _apiKey.length > 10 ? 10 : _apiKey.length)}...');
      debugPrint('   Is placeholder: ${_apiKey == _placeholderApiKey}');
    }
    
    // Jangan initialize di constructor, biarkan lazy initialization
    // Ini untuk menghindari error saat app start jika API key bermasalah
  }

  // Default API key - GANTI dengan API key Anda sendiri
  // Untuk production, gunakan environment variable atau secure storage
  static const String _defaultApiKey = 'AIzaSyB2d_OLCuDHGfOmzauvqQCNH5YSvFJPgk4';
  static const String _placeholderApiKey = 'YOUR_GEMINI_API_KEY_HERE';
  
  final String _apiKey;
  GenerativeModel? _model;

  /// Cek apakah service sudah siap digunakan
  bool get isAvailable => 
      _model != null && 
      _apiKey.isNotEmpty && 
      _apiKey != _placeholderApiKey;

  String? _workingModel; // Simpan model yang berhasil
  
  /// Test model dengan HTTP request langsung
  Future<bool> _testModelWithHttp(String modelName) async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$modelName:generateContent?key=$_apiKey',
      );
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {'parts': [{'text': 'hi'}]}
          ]
        }),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          final parts = content?['parts'] as List<dynamic>?;
          if (parts != null && parts.isNotEmpty) {
            return true; // Model bekerja
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Get list of available models dari API
  Future<List<String>> _getAvailableModels() async {
    try {
      if (kDebugMode) {
        debugPrint('📋 Fetching available models from API...');
      }
      
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$_apiKey');
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final allModels = (data['models'] as List<dynamic>?) ?? [];
        
        final models = <String>[];
        for (final m in allModels) {
          final modelData = m as Map<String, dynamic>;
          final name = modelData['name'] as String?;
          final supportedMethods = modelData['supportedGenerationMethods'] as List<dynamic>?;
          
          if (name != null && 
              name.contains('gemini') && 
              supportedMethods != null &&
              supportedMethods.contains('generateContent')) {
            final modelName = name.replaceAll('models/', '');
            models.add(modelName);
          }
        }
        
        if (kDebugMode) {
          debugPrint('✅ Found ${models.length} available models: $models');
        }
        return models;
      } else {
        final errorBody = response.body.length > 300 
            ? response.body.substring(0, 300) 
            : response.body;
        if (kDebugMode) {
          debugPrint('⚠️ Failed to fetch models: ${response.statusCode}');
          debugPrint('   Response: $errorBody');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error fetching models: $e');
      }
      return [];
    }
  }
  
  /// Initialize model Gemini dengan test request
  Future<bool> _ensureModelInitialized() async {
    // Jika sudah ada model yang bekerja, gunakan itu
    if (_model != null && _workingModel != null) return true;
    
    if (_apiKey.isEmpty || _apiKey == _placeholderApiKey) {
      if (kDebugMode) {
        debugPrint('❌ Cannot initialize: API key is empty or placeholder');
      }
      return false;
    }

    try {
      if (kDebugMode) {
        debugPrint('🔄 Testing Gemini API with key: ${_apiKey.substring(0, 15)}...');
      }
      
      // Coba dapatkan daftar model yang tersedia dari API
      final availableModels = await _getAvailableModels();
      
      // Gabungkan dengan model default jika API tidak mengembalikan model
      final modelsToTry = <String>[];
      if (availableModels.isNotEmpty) {
        modelsToTry.addAll(availableModels);
        if (kDebugMode) {
          debugPrint('   Using models from API: $availableModels');
        }
      } else {
        // Fallback ke model default jika API tidak mengembalikan model
        modelsToTry.addAll([
          'gemini-1.5-flash',
          'gemini-1.5-pro',
          'gemini-pro',
        ]);
        if (kDebugMode) {
          debugPrint('   Using default models (API tidak mengembalikan daftar model)');
        }
      }
      
      Exception? lastError;
      
      for (final modelName in modelsToTry) {
        try {
          if (kDebugMode) {
            debugPrint('   🔄 Testing model: $modelName');
          }
          
          // Initialize model
          _model = GenerativeModel(
            model: modelName,
            apiKey: _apiKey,
            generationConfig: GenerationConfig(
              temperature: 0.7,
              topK: 40,
              topP: 0.95,
              maxOutputTokens: 1024,
            ),
          );
          
          // Test dengan request sederhana untuk memastikan model benar-benar bekerja
          if (kDebugMode) {
            debugPrint('   Testing connection with simple request...');
          }
          
          final testResponse = await _model!.generateContent([Content.text('hi')])
              .timeout(const Duration(seconds: 10));
          
          if (testResponse.text != null && testResponse.text!.isNotEmpty) {
            if (kDebugMode) {
              debugPrint('✅✅✅ Model $modelName is WORKING!');
              debugPrint('   Test response: ${testResponse.text!.substring(0, testResponse.text!.length > 50 ? 50 : testResponse.text!.length)}...');
            }
            _workingModel = modelName;
            return true;
          } else {
            throw Exception('Model returned empty response');
          }
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          if (kDebugMode) {
            final errorMsg = e.toString();
            if (errorMsg.contains('not found') || errorMsg.contains('not supported')) {
              debugPrint('   ❌ Model $modelName not available');
            } else if (errorMsg.contains('API') || errorMsg.contains('key') || errorMsg.contains('auth') || errorMsg.contains('permission')) {
              debugPrint('   ❌ Model $modelName: API key error');
            } else {
              debugPrint('   ❌ Model $modelName failed: ${errorMsg.substring(0, 100)}');
            }
          }
          _model = null;
          continue; // Coba model berikutnya
        }
      }
      
      // Jika semua model gagal
      if (kDebugMode) {
        debugPrint('❌❌❌ Semua model gagal');
        debugPrint('   💡 Solusi:');
        debugPrint('   1. Pastikan API key valid di https://aistudio.google.com/app/apikey');
        debugPrint('   2. Pastikan API key memiliki akses ke Gemini API');
        debugPrint('   3. Coba buat API key baru');
      }
      throw lastError ?? Exception('All models failed');
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌❌❌ Failed to initialize Gemini model');
        debugPrint('Error: $e');
      }
      _model = null;
      _workingModel = null;
      return false;
    }
  }

  /// Generate response dari Gemini AI dengan retry mechanism untuk error 503
  /// 
  /// [userMessage] - Pesan dari user
  /// [context] - Konteks finansial (opsional) untuk memberikan context yang lebih baik
  Future<String> generateResponse(
    String userMessage, {
    Map<String, dynamic>? context,
  }) async {
    // Pastikan model sudah di-initialize
    final initialized = await _ensureModelInitialized();
    
    if (!initialized || _model == null) {
      if (kDebugMode) {
        debugPrint('⚠️ Model not initialized, using fallback');
      }
      return _getFallbackResponse(userMessage);
    }

    final prompt = _buildPrompt(userMessage, context);
    final content = [Content.text(prompt)];
    
    // Retry mechanism untuk error 503 (overloaded)
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 2);
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        if (kDebugMode) {
          if (attempt == 0) {
            debugPrint('🚀🚀🚀 Calling Gemini API...');
            debugPrint('   Message: "$userMessage"');
            debugPrint('   Prompt length: ${prompt.length} chars');
          } else {
            debugPrint('🔄 Retry attempt ${attempt + 1}/$maxRetries...');
          }
        }
        
        // Timeout 30 detik untuk request
        final response = await _model!.generateContent(content)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw TimeoutException('Gemini API request timeout after 30s');
              },
            );
        
        final text = response.text;
        
        if (text != null && text.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('✅✅✅✅✅ GEMINI AI SUCCESS! ✅✅✅✅✅');
            debugPrint('   Model used: $_workingModel');
            debugPrint('   Attempt: ${attempt + 1}');
            debugPrint('   Response length: ${text.length} chars');
            debugPrint('   Response preview: ${text.substring(0, text.length > 200 ? 200 : text.length)}...');
          }
          return text;
        }
        
        if (kDebugMode) {
          debugPrint('⚠️ Gemini returned empty/null text');
        }
      } catch (e, stackTrace) {
        final errorStr = e.toString().toLowerCase();
        final isOverloaded = errorStr.contains('503') || 
                            errorStr.contains('overloaded') || 
                            errorStr.contains('unavailable');
        
        // Jika error 503 (overloaded), retry dengan delay
        if (isOverloaded && attempt < maxRetries - 1) {
          final delay = Duration(
            milliseconds: baseDelay.inMilliseconds * (1 << attempt), // Exponential backoff: 2s, 4s, 8s
          );
          
          if (kDebugMode) {
            debugPrint('⚠️ Model overloaded (503). Retrying in ${delay.inSeconds}s...');
            debugPrint('   Attempt ${attempt + 1}/$maxRetries');
          }
          
          await Future.delayed(delay);
          continue; // Retry dengan delay
        }
        
        // Jika error karena model tidak ditemukan, reset dan coba model lain
        if (errorStr.contains('not found') || errorStr.contains('not supported')) {
          if (kDebugMode) {
            debugPrint('❌ Model $_workingModel tidak tersedia, akan coba model lain...');
          }
          _model = null;
          _workingModel = null;
          
          // Coba initialize lagi dengan model lain
          final retryInitialized = await _ensureModelInitialized();
          if (retryInitialized && _model != null) {
            if (kDebugMode) {
              debugPrint('✅ Model baru berhasil di-initialize: $_workingModel');
              debugPrint('   Retrying request...');
            }
            // Retry request dengan model baru (hanya sekali)
            try {
              final response = await _model!.generateContent(content)
                  .timeout(const Duration(seconds: 30));
              final text = response.text;
              if (text != null && text.isNotEmpty) {
                if (kDebugMode) {
                  debugPrint('✅✅✅ Retry SUCCESS with model $_workingModel!');
                }
                return text;
              }
            } catch (retryError) {
              if (kDebugMode) {
                debugPrint('❌ Retry juga gagal: $retryError');
              }
            }
          }
        }
        
        // Jika bukan error yang bisa di-retry atau sudah max retries
        if (kDebugMode) {
          debugPrint('❌❌❌❌❌ GEMINI API CALL FAILED ❌❌❌❌❌');
          debugPrint('   Error: $e');
          debugPrint('   Error type: ${e.runtimeType}');
          debugPrint('   Attempt: ${attempt + 1}/$maxRetries');
          if (isOverloaded) {
            debugPrint('   ⚠️⚠️⚠️ MODEL OVERLOADED (503) - Server sedang sibuk ⚠️⚠️⚠️');
            debugPrint('   💡 Ini masalah dari server Gemini, bukan aplikasi Anda');
            debugPrint('   💡 Coba lagi dalam beberapa detik');
          }
          if (errorStr.contains('api') || errorStr.contains('key') || errorStr.contains('auth')) {
            debugPrint('   🔑🔑🔑 API KEY AUTHENTICATION ERROR! 🔑🔑🔑');
            debugPrint('   💡 Pastikan API key valid di https://aistudio.google.com/app/apikey');
          }
          if (errorStr.contains('quota') || errorStr.contains('limit')) {
            debugPrint('   ⚠️ QUOTA/LIMIT ERROR!');
          }
          debugPrint('   Stack trace (first 500 chars):');
          debugPrint('   ${stackTrace.toString().substring(0, stackTrace.toString().length > 500 ? 500 : stackTrace.toString().length)}');
        }
        
        // Jika sudah max retries atau bukan error yang bisa di-retry, break
        if (!isOverloaded || attempt >= maxRetries - 1) {
          break;
        }
      }
    }

    // Fallback jika semua retry gagal
    if (kDebugMode) {
      debugPrint('⚠️ Falling back to default response after $maxRetries attempts');
    }
    return _getFallbackResponse(userMessage);
  }

  /// Build prompt dengan context finansial
  String _buildPrompt(String userMessage, Map<String, dynamic>? context) {
    final buffer = StringBuffer();
    
    buffer.writeln('Kamu adalah Spend-IQ AI, asisten finansial pintar. Jawab SEMUA pertanyaan dengan bahasa Indonesia yang ramah dan membantu.');
    buffer.writeln('');
    buffer.writeln('ATURAN WAJIB:');
    buffer.writeln('- JANGAN PERNAH katakan "maaf tidak bisa menjawab" atau "belum bisa menjawab"');
    buffer.writeln('- Untuk sapaan (hai/halo/hello/tes): sambut dengan ramah, perkenalkan diri, tanyakan apa yang bisa dibantu');
    buffer.writeln('- Untuk pertanyaan saldo: berikan informasi saldo jika ada di context, atau jelaskan cara melihatnya');
    buffer.writeln('- Untuk pertanyaan singkat/tidak jelas: berikan jawaban umum yang membantu atau tanyakan klarifikasi');
    buffer.writeln('- Fokus pada topik: cashflow, forecast, tagihan, strategi menabung, kesehatan finansial');
    buffer.writeln('');
    
    if (context != null) {
      buffer.writeln('DATA KEUANGAN PENGGUNA:');
      if (context.containsKey('totalBalance') && context['totalBalance'] > 0) {
        final balance = context['totalBalance'] as int;
        buffer.writeln('Total saldo: Rp${balance.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}');
      }
      if (context.containsKey('healthScore')) {
        buffer.writeln('Skor kesehatan: ${context['healthScore']}/100');
      }
      if (context.containsKey('recentTransactions')) {
        buffer.writeln('Jumlah transaksi: ${context['recentTransactions']}');
      }
      buffer.writeln('');
    }
    
    buffer.writeln('PERTANYAAN PENGGUNA: "$userMessage"');
    buffer.writeln('');
    buffer.writeln('JAWAB SEKARANG dengan ramah dan membantu. JANGAN katakan tidak bisa menjawab.');
    
    return buffer.toString();
  }

  /// Fallback response jika Gemini tidak tersedia
  String _getFallbackResponse(String userMessage) {
    final lower = userMessage.toLowerCase().trim();
    
    // Handle sapaan
    if (lower == 'hai' || lower == 'halo' || lower == 'hello' || lower == 'hi' || lower == 'tes' || lower == 'test') {
      return 'Halo! Saya Spend-IQ AI, asisten finansial Anda. Saya siap membantu mengelola keuangan Anda. Ada yang bisa saya bantu hari ini? Anda bisa bertanya tentang cashflow, forecast pengeluaran, tagihan terdekat, atau strategi menabung.';
    }
    
    if (lower.contains('kesehatan') || lower.contains('health') || lower.contains('skor')) {
      return 'Skor kesehatan finansial Anda dapat dilihat di dashboard. Pastikan dana darurat minimal 3x pengeluaran bulanan untuk menjaga kesehatan finansial yang baik.';
    }
    
    if (lower.contains('forecast') || lower.contains('prediksi') || lower.contains('belanja')) {
      return 'Forecast pengeluaran dapat dilihat di halaman Insights. Prediksi ini membantu Anda merencanakan pengeluaran minggu ini dengan lebih baik.';
    }
    
    if (lower.contains('tagihan') || lower.contains('alert') || lower.contains('bills')) {
      return 'Tagihan terdekat dapat dilihat di halaman Alerts. Pastikan untuk membayar tagihan tepat waktu untuk menghindari denda.';
    }
    
    if (lower.contains('menabung') || lower.contains('saving') || lower.contains('tabung')) {
      return 'Untuk rekomendasi menabung, buka halaman Autosave. Spend-IQ akan membantu menemukan hari yang aman untuk menabung berdasarkan prediksi cashflow.';
    }
    
    // Default response yang lebih ramah
    return 'Halo! Saya Spend-IQ AI. Saya bisa membantu Anda dengan berbagai hal terkait keuangan, seperti cashflow, forecast pengeluaran, tagihan, atau strategi menabung. Ada yang ingin Anda tanyakan? Atau gunakan Quick Ask di bawah untuk pertanyaan cepat.';
  }
}

/// Provider untuk GeminiService
final geminiServiceProvider = Provider<GeminiService>((ref) {
  // Untuk production, ambil API key dari secure storage atau environment variable
  // Contoh: final apiKey = ref.read(secureStorageProvider).get('gemini_api_key');
  return GeminiService();
});