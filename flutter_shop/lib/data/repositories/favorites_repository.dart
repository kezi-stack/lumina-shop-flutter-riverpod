import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  const FavoritesRepository(this.preferences);

  final SharedPreferences preferences;
  static const _key = 'favorite_product_ids';

  Set<String> readIds() {
    return (preferences.getStringList(_key) ?? <String>[]).toSet();
  }

  Future<void> writeIds(Set<String> ids) {
    return preferences.setStringList(_key, ids.toList());
  }
}
