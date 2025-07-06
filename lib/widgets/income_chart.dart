import 'package:flutter/material.dart';
import 'package:freelancer_income_tracker_app/theme/app_theme.dart';
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

    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 600),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.lightCard.withOpacity(0.9),
                AppColors.lightCard,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Income',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12),
              Container(
                height:
                    MediaQuery.of(context).size.height * 0.3, // Dynamic height
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    majorGridLines: MajorGridLines(width: 0),
                    majorTickLines: MajorTickLines(size: 0),
                    labelRotation: 45,
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0),
                    majorGridLines: MajorGridLines(
                      width: 1,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                    ),
                    minorGridLines: MinorGridLines(width: 0),
                  ),
                  series: <CartesianSeries>[
                    ColumnSeries<ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.month,
                      yValueMapper: (ChartData data, _) => data.amount,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.secondaryColor,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        labelPosition: ChartDataLabelPosition.outside,
                        connectorLineSettings: ConnectorLineSettings(
                          length: '10%',
                          type: ConnectorType.line,
                          color: AppColors.accentColor.withOpacity(0.7),
                        ),
                      ),
                      animationDuration: 1000,
                    ),
                  ],
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    // borderRadius: 8,
                    color: AppColors.lightCard.withOpacity(0.9),
                    textStyle: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    builder: (data, point, series, pointIndex, seriesIndex) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightCard.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${data.month}\n\$${data.amount.toStringAsFixed(0)}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
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
      ),
    );
  }
}

class ChartData {
  final String month;
  final double amount;

  ChartData(this.month, this.amount);
}
