import 'package:shared_preferences/shared_preferences.dart';

import '../models/progress.dart';

/// Contrato de persistência. Isolar aqui permite trocar
/// `shared_preferences` por SQLite (histórico) sem mexer no resto do app.
abstract class ProgressStorage {
  Future<ProgressData?> load();

  Future<void> save(ProgressData data);

  Future<void> clear();
}

/// Implementação do protótipo: um JSON versionado em `shared_preferences`.
///
/// A chave é própria da v2: a v1 instalada no mesmo aparelho mantém o save
/// dela intacto.
class SharedPrefsProgressStorage implements ProgressStorage {
  static const String storageKey = 'ova_stf_cards_progress_v1';

  @override
  Future<ProgressData?> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ProgressData.decode(prefs.getString(storageKey));
  }

  @override
  Future<void> save(ProgressData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, data.encode());
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }
}

/// Implementação em memória, usada nos testes.
class InMemoryProgressStorage implements ProgressStorage {
  ProgressData? _data;

  @override
  Future<ProgressData?> load() async => _data;

  @override
  Future<void> save(ProgressData data) async => _data = data;

  @override
  Future<void> clear() async => _data = null;
}
