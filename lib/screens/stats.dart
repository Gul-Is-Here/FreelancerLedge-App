// modules/stats/views/stats_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/payment_controllers.dart';
import '../controllers/stats_controller.dart';
import '../widgets/income_chart.dart';

class StatsView extends StatelessWidget {
  final PaymentsController paymentsController = Get.find();
  final StatsController statsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Statistics', style: GoogleFonts.poppins()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              final totalEarnings = paymentsController.totalEarnings;
              final pendingPayments = paymentsController.pendingPayments;

              return Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    _StatCard(
                      title: 'Total Earnings',
                      value: totalEarnings,
                      color: Colors.green,
                    ),
                    SizedBox(width: 12),
                    _StatCard(
                      title: 'Pending Payments',
                      value: pendingPayments,
                      color: Colors.orange,
                    ),
                  ],
                ),
              );
            }),
            IncomeChart(),
            // In modules/stats/views/stats_view.dart
// Add this after the existing IncomeChart widget
            Card(
              margin: EdgeInsets.all(12),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Earnings Distribution',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurface,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: Obx(() {
                        final earningsByClient = statsController
                            .getEarningsByClient();
                        final chartData = earningsByClient.entries
                            .map((e) => ChartData(e.key, e.value))
                            .toList();

                        return SfCircularChart(
                          legend: Legend(
                            isVisible: true,
                            overflowMode: LegendItemOverflowMode.wrap,
                            textStyle: GoogleFonts.poppins(),
                          ),
                          series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.month,
                              yValueMapper: (ChartData data, _) => data.amount,
                              dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                textStyle: GoogleFonts.poppins(fontSize: 10),
                                connectorLineSettings: ConnectorLineSettings(
                                  length: '20%',
                                  type: ConnectorType.curve,
                                ),
                              ),
                              enableTooltip: true,
                            )
                          ],
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            builder: (data, point, series, pointIndex, seriesIndex) {
                              return Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '${data.month}\n\$${data.amount.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(),
                                ),
                              );
                            },
                          ),                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() {
              final earningsByClient = statsController.getEarningsByClient();
              if (earningsByClient.isEmpty) {
                return SizedBox();
              }

              return Card(
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earnings by Client',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurface,
                        ),
                      ),
                      SizedBox(height: 16),
                      ...earningsByClient.entries.map((entry) =>
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                                Text(
                                  '\$${entry.value.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final double value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.7),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '\$${value.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}