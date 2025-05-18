// widgets/income_chart.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/stats_controller.dart';

class IncomeChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final StatsController statsController = Get.find();
    final monthlyEarnings = statsController.getMonthlyEarnings();

    // Convert to list of ChartData objects
    final chartData =
        monthlyEarnings.entries.map((e) => ChartData(e.key, e.value)).toList();

    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Income',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.month,
                    yValueMapper: (ChartData data, _) => data.amount,
                    color: Theme.of(context).colorScheme.primary,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.auto,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(
                  enable: true,
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        '${data.month}\n\$${data.amount.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String month;
  final double amount;

  ChartData(this.month, this.amount);
}
