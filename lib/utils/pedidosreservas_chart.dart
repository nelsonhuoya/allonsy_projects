import 'package:allonsyapp/utils/pedidosreservas_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PedidosReservasChart extends StatelessWidget {
  final List<PedidosReservasSeries> data;
  final List<PedidosReservasSeries> data2;


  PedidosReservasChart({required this.data, required this.data2});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<PedidosReservasSeries, String>> series = [
      charts.Series(
        id: 'pedidos',
        data: data,
        domainFn: (PedidosReservasSeries series, _) => series.data,
        measureFn: (PedidosReservasSeries series, _) => series.qtd,
        colorFn: (PedidosReservasSeries series, _) => series.barcolor,
      ),

      charts.Series(
        id: 'reservas',
        data: data2,
        domainFn: (PedidosReservasSeries series, _) => series.data,
        measureFn: (PedidosReservasSeries series, _) => series.qtd,
        colorFn: (PedidosReservasSeries series, _) => series.barcolor,
      ),
    ];


    return charts.BarChart(series, animate:false,
      domainAxis: charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(

          // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
                fontSize: 12, // size in Pts.
                color: charts.MaterialPalette.white),

            // Change the line colors to match text color.
            lineStyle: new charts.LineStyleSpec(
                color: charts.MaterialPalette.white)),
        showAxisLine: false,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(

          // Tick and Label styling here.
            labelStyle: new charts.TextStyleSpec(
                fontSize: 12, // size in Pts.
                color: charts.MaterialPalette.white),


            lineStyle: new charts.LineStyleSpec(
                color: charts.MaterialPalette.white)),
        showAxisLine: false,
      ),
      barGroupingType: charts.BarGroupingType.grouped,
      layoutConfig: charts.LayoutConfig(
        bottomMarginSpec: charts.MarginSpec.fixedPixel(0),
        leftMarginSpec: charts.MarginSpec.fixedPixel(0),
        topMarginSpec: charts.MarginSpec.fixedPixel(0),
        rightMarginSpec: charts.MarginSpec.fixedPixel(0),
      )
      ,);
  }
}