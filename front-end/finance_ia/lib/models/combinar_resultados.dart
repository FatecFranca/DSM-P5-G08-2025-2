import 'combinar_item.dart';

class MatchResults {
  final String perfilId;
  final String perfilTipo;
  final List<MatchItem> items;

  MatchResults({
    required this.perfilId,
    required this.perfilTipo,
    required this.items,
  });

  factory MatchResults.fromMap(Map<String, dynamic> map) {
    return MatchResults(
      perfilId: map["perfil_id"],
      perfilTipo: map["perfil_tipo"],
      items: (map["items"] as List)
          .map((e) => MatchItem.fromMap(e))
          .toList(),
    );
  }
}
