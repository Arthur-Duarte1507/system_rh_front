import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final String key = "usuario";
  
  Future<void> salvarFuncionarioId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, id);
  }

  Future<String?> obterFuncionarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
 }