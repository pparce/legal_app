import 'package:hive/hive.dart';

part 'articulo.model..g.dart';

@HiveType(typeId: 0)
class Articulo extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String tipo;

  Articulo(this.name, this.description, this.tipo);
}
