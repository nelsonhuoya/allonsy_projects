import 'package:charts_flutter/flutter.dart' as charts;

class PedidosReservasSeries {
  final String data;
  final int qtd;
  final charts.Color barcolor;

  PedidosReservasSeries(
      {
      required this.data,
      required this.qtd,
        required this.barcolor
      });

}