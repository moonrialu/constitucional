import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/mutation.dart';

/// Contrato de persistência da jornada de mutação.
abstract class MutationStorage {
  Future<MutationProgress?> load();

  Future<void> save(MutationProgress data);

  Future<void> clear();
}

/// Save independente do baralho de cartas, para não misturar as duas
/// experiências no mesmo aparelho.
class SharedPrefsMutationStorage implements MutationStorage {
  static const String storageKey = 'ova_mutacao_progress_v1';

  @override
  Future<MutationProgress?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return MutationProgress.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(MutationProgress data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(data.toJson()));
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}

/// Implementação em memória para testes.
class InMemoryMutationStorage implements MutationStorage {
  MutationProgress? _data;

  @override
  Future<MutationProgress?> load() async => _data;

  @override
  Future<void> save(MutationProgress data) async => _data = data;

  @override
  Future<void> clear() async => _data = null;
}
