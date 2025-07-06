import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/payment_controllers.dart';

import '../controllers/stats_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/income_chart.dart';

class StatsView extends StatelessWidget {
  final PaymentsController paymentsController = Get.find<PaymentsController>();
  final StatsController statsController = Get.find<StatsController>();

  StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Income Statistics',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final totalEarnings = paymentsController.totalEarnings;
              final pendingPayments = paymentsController.pendingPayments;

              return Row(
                children: [
                  _StatCard(
                    title: 'Total Earnings',
                    value: totalEarnings,
                    color: AppColors.primaryColor,
                    icon: Icons.account_balance_wallet,
                  ),
                  SizedBox(width: 12),
                  _StatCard(
                    title: 'Pending \nPayments',
                    value: pendingPayments,
                    color: AppColors.secondaryColor,
                    icon: Icons.hourglass_empty,
                  ),
                ],
              );
            }),
            SizedBox(height: 16),
            IncomeChart(),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.all(12),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earnings Distribution',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 12),
                      Obx(() {
                        final earningsByClient =
                            statsController.getEarningsByClient();
                        if (earningsByClient.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'No earnings data available',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ),
                          );
                        }
                        final chartData =
                            earningsByClient.entries
                                .map((e) => ChartData(e.key, e.value))
                                .toList();

                        return SizedBox(
                          height: 240,
                          child: SfCircularChart(
                            legend: Legend(
                              isVisible: true,
                              overflowMode: LegendItemOverflowMode.wrap,
                              position: LegendPosition.bottom,
                              textStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            series: <CircularSeries>[
                              PieSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) => data.month,
                                yValueMapper:
                                    (ChartData data, _) => data.amount,
                                pointColorMapper:
                                    (ChartData data, _) =>
                                        [
                                          AppColors.primaryColor,
                                          AppColors.secondaryColor,
                                          AppColors.accentColor,
                                          AppColors.lightPrimary,
                                          AppColors.darkPrimary,
                                        ][chartData.indexOf(data) % 5],
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelPosition: ChartDataLabelPosition.outside,
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                  connectorLineSettings: ConnectorLineSettings(
                                    length: '15%',
                                    type: ConnectorType.curve,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                enableTooltip: true,
                                radius: '90%',
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(
                              enable: true,

                              color: Theme.of(context).colorScheme.surface,
                              textStyle: GoogleFonts.poppins(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              builder: (
                                data,
                                point,
                                series,
                                pointIndex,
                                seriesIndex,
                              ) {
                                final chartData = data as ChartData;
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surface.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '${chartData.month}\n\$${chartData.amount.toStringAsFixed(0)}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              final earningsByClient = statsController.getEarningsByClient();
              if (earningsByClient.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'No client earnings data available',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              }

              return AnimatedOpacity(
                opacity: 1.0,
                duration: Duration(milliseconds: 500),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.all(12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Earnings by Client',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...earningsByClient.entries
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final client = entry.value;
                              return AnimatedOpacity(
                                opacity: 1.0,
                                duration: Duration(
                                  milliseconds: 300 + (index * 100),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          client.key,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '\$${client.value.toStringAsFixed(2)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                            .toList(),
                      ],
                    ),
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
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: color.withOpacity(0.7), size: 24),
                    SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: value),
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  builder: (context, double animatedValue, child) {
                    return Text(
                      '\$${animatedValue.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.month, this.amount);
  final String month;
  final double amount;
}
