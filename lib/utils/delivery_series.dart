import 'package:charts_flutter/flutter.dart' as charts;

class DeliverySeries{
  final String entrega;
  final int pedidos;
  final charts.Color barcolor;


  DeliverySeries(
      {
        required this.entrega,
        required this.pedidos,
        required this.barcolor}
      );
}
