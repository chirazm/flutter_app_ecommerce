import 'package:admin_panel_pfe/screens/dashboard/dashbord_screen.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

Widget generateBarChart(int totalCustomers, int totalVendors) {
  List<CustomerData> data = [
    CustomerData(title: 'Total Customers', count: totalCustomers),
    CustomerData(title: 'Total Vendors', count: totalVendors),
  ];

  List<charts.Series<CustomerData, String>> seriesList = [
    charts.Series<CustomerData, String>(
      id: 'customers',
      domainFn: (CustomerData data, _) => data.title,
      measureFn: (CustomerData data, _) => data.count,
      data: data,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      labelAccessorFn: (CustomerData data, _) => '${data.title}: ${data.count}',
    ),
  ];

  return Container(
    height: 200,
    width: 200,
    child: charts.BarChart(
      seriesList,
      animate: true,
      animationDuration: const Duration(milliseconds: 500),
      barGroupingType: charts.BarGroupingType.grouped,
      layoutConfig: charts.LayoutConfig(
        leftMarginSpec: charts.MarginSpec.fixedPixel(5),
        topMarginSpec: charts.MarginSpec.fixedPixel(5),
        rightMarginSpec: charts.MarginSpec.fixedPixel(5),
        bottomMarginSpec: charts.MarginSpec.fixedPixel(5),
      ),
    ),
  );
}

Widget generateBarChart2(int totalProducts, int totalOrders) {
  List<CustomerData> data = [
    CustomerData(title: 'Total Products', count: totalProducts),
    CustomerData(title: 'Total Orders', count: totalOrders),
  ];

  List<charts.Series<CustomerData, String>> seriesList = [
    charts.Series<CustomerData, String>(
      id: 'products',
      domainFn: (CustomerData data, _) => data.title,
      measureFn: (CustomerData data, _) => data.count,
      data: data,
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      labelAccessorFn: (CustomerData data, _) => '${data.title}: ${data.count}',
    ),
  ];

  return Container(
    height: 200,
    width: 200,
    child: charts.BarChart(
      seriesList,
      animate: true,
      animationDuration: const Duration(milliseconds: 500),
      barGroupingType: charts.BarGroupingType.grouped,
      layoutConfig: charts.LayoutConfig(
        leftMarginSpec: charts.MarginSpec.fixedPixel(5),
        topMarginSpec: charts.MarginSpec.fixedPixel(5),
        rightMarginSpec: charts.MarginSpec.fixedPixel(5),
        bottomMarginSpec: charts.MarginSpec.fixedPixel(5),
      ),
    ),
  );
}

Widget generatePieChart(int totalProducts, int featuredProducts) {
  double featuredPercentage = (featuredProducts / totalProducts) * 100;
  double productsPercentage = 100 - featuredPercentage;
  String featuredPercentageStr = featuredPercentage.toStringAsFixed(2);
  String productsPercentageStr = productsPercentage.toStringAsFixed(2);

  List<CustomerData> data = [
    CustomerData(title: 'Total Products', count: totalProducts),
    CustomerData(title: 'Featured Products', count: featuredProducts),
  ];

  List<charts.Series<CustomerData, String>> seriesList = [
    charts.Series<CustomerData, String>(
      id: 'products',
      domainFn: (CustomerData data, _) => data.title,
      measureFn: (CustomerData data, _) => data.count,
      data: data,
      colorFn: (CustomerData data, _) {
        if (data.title == 'Featured Products') {
          return charts.MaterialPalette.indigo.shadeDefault;
        } else {
          return charts.MaterialPalette.deepOrange.shadeDefault;
        }
      },
      labelAccessorFn: (CustomerData data, _) {
        if (data.title == 'Featured Products') {
          return '$featuredPercentageStr% (${data.count})';
        } else {
          return '$productsPercentageStr% (${data.count})';
        }
      },
    ),
  ];

  return Container(
    height: 200,
    width: 300,
    child: charts.PieChart(
      seriesList,
      animate: true,
      animationDuration: const Duration(milliseconds: 500),
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          ),
        ],
      ),
    ),
  );
}
