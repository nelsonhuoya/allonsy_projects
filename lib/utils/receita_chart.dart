import 'package:allonsyapp/utils/receita_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class ReceitaChart extends StatelessWidget {
  final List<ReceitaSeries> data;
  final double maxvalue;
  final double minvalue;
  var customFormatterSpec;

  var desiredTickCount;

  ReceitaChart({required this.data, required this.minvalue,required this.maxvalue, this.desiredTickCount, this.customFormatterSpec});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ReceitaSeries, int>> series = [
      charts.Series(
        id: 'pedidos',
        data: data,
        domainFn: (ReceitaSeries series, _) => series.data,
        measureFn: (ReceitaSeries series, _) => series.qtd,
      ),

    ];

    final staticTicks = <charts.TickSpec<double>>[
      charts.TickSpec(minvalue),
      charts.TickSpec(maxvalue),
    ];


    return charts.LineChart(series, animate:false,
      domainAxis: charts.NumericAxisSpec(
          tickFormatterSpec: customFormatterSpec,
          tickProviderSpec: charts.BasicNumericTickProviderSpec(desiredTickCount: desiredTickCount),
          renderSpec: new charts.SmallTickRendererSpec(

              labelStyle: new charts.TextStyleSpec(
                  lineHeight: 2,
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),

              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.transparent)),
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: new charts.GridlineRendererSpec(

            // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white)),
          tickProviderSpec: charts.StaticNumericTickProviderSpec(staticTicks),
          showAxisLine: false,
          tickFormatterSpec: charts.BasicNumericTickFormatterSpec.fromNumberFormat(
            NumberFormat.compactSimpleCurrency(
            )),
      ),

      layoutConfig: charts.LayoutConfig(
        bottomMarginSpec: charts.MarginSpec.fixedPixel(0),
        leftMarginSpec: charts.MarginSpec.fixedPixel(0),
        topMarginSpec: charts.MarginSpec.fixedPixel(0),
        rightMarginSpec: charts.MarginSpec.fixedPixel(0),
      )
      ,);
  }
}

