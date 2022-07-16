import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SimpleLineChart extends StatelessWidget {

  final List<LinearSales> teste;

  var customFormatterSpec;

  SimpleLineChart(this.teste, this.customFormatterSpec);


  @override
  Widget build(BuildContext context) {

    List<charts.Series<LinearSales, int>> seriesList = [
      charts.Series(
        id: "Sales",
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: teste,
      )
    ];


    return charts.LineChart(seriesList,
        animate:false,
        domainAxis: charts.NumericAxisSpec(
          tickFormatterSpec: customFormatterSpec
        ),
    );
  }
}

  class LinearSales {
    final int year;
    final double sales;

    LinearSales(this.year, this.sales);
}

