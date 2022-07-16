import 'package:allonsyapp/utils/delivery_series.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DeliveryChart extends StatelessWidget {
  final List<DeliverySeries> data;

  DeliveryChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<DeliverySeries, String>> series = [
      charts.Series(
        id: 'entregas',
        data: data,
        domainFn: (DeliverySeries series, _) => series.entrega.toString(),
        measureFn: (DeliverySeries series, _) => series.pedidos,
        colorFn: (DeliverySeries series, _) => series.barcolor,
      )
    ];

    return charts.PieChart<String>(series, animate:false, defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 15,
          strokeWidthPx: 0.01,
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
