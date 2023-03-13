import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final container = ProviderContainer();

final tokenProvider = StateNotifierProvider<TokenNotifier, String>((ref) => TokenNotifier());
final messagesProvider = StateNotifierProvider<MessagesNotifier, List<String>>((ref) => MessagesNotifier());

class TokenNotifier extends StateNotifier<String> {
  TokenNotifier() : super("");

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    state = token ?? "";
  }

  void set(String token) {
    state = token;

    SharedPreferences.getInstance().then((prefs) => prefs.setString("token", token));
  }
}

class MessagesNotifier extends StateNotifier<List<String>> {
  MessagesNotifier() : super([]);

  @override
  bool updateShouldNotify(List<String> old, List<String> current) {
    return true;
  }

  void add(String message) {
    state.add(message);
    state = state;
  }
}