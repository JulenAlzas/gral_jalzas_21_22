import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/edit_profile.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;

import "package:collection/collection.dart";

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  double irabazitakoDirua = 0.0;
  double galdutakoDirua = 0.0;
  late ZoomPanBehavior _zoomPanBehavior;

  double transakzioMax = 0.0;
  bool _isLoading = true;
  var transactionDocList;
  List<ChartDataDonut> _chartDonutData = [];
  List<_ChartData>? chartData = <_ChartData>[
    // _ChartData(DateTime(2015, 1, 1), 21, 28),
    // _ChartData(DateTime(2015, 1, 3), 24, 44),
    // _ChartData(DateTime(2015, 1, 5), 36, 48),
    // _ChartData(DateTime(2015, 1, 10), 20, 40),
  ];

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    getChartData();
    super.initState();
  }

  @override
  void dispose() {
    _chartDonutData.clear();
    chartData!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    double swiperobjectWidth = 0.0;
    double swiperobjectHeight = 0.0;

    if (defaultTargetPlatform == TargetPlatform.android) {
      swiperobjectWidth = screenSize.width * 0.7;
      swiperobjectHeight = screenSize.width * 0.7;
    } else {
      swiperobjectWidth = screenSize.width * 0.25;
      swiperobjectHeight = screenSize.width * 0.25;
    }

    List<String> gameImages = [
      'assets/erruletaJokoa.png',
      'assets/slotGame.png',
    ];

    return Scaffold(
      appBar: appBarDetails(context),
      body: SingleChildScrollView(
        child: _isLoading
            ? const KargatzeAnimazioa()
            : Stack(
                children: [
                  const BackgroundHome(),
                  Column(
                    children: [
                      Center(
                          child: Container(
                              child: SfCircularChart(series: <CircularSeries>[
                        // Renders doughnut chart
                        DoughnutSeries<ChartDataDonut, String>(
                            dataSource: _chartDonutData,
                            pointColorMapper: (ChartDataDonut data, _) =>
                                data.color,
                            xValueMapper: (ChartDataDonut data, _) => data.x,
                            yValueMapper: (ChartDataDonut data, _) => data.y,
                            dataLabelMapper: (ChartDataDonut data, _) => data.x,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
                            explode: true,
                            explodeGesture: ActivationMode.singleTap)
                      ]))),
                      Center(
                          child: Container(
                              child: SfCircularChart(series: <CircularSeries>[
                        // Renders doughnut chart
                        PieSeries<ChartDataDonut, String>(
                            dataSource: _chartDonutData,
                            pointColorMapper: (ChartDataDonut data, _) =>
                                data.color,
                            xValueMapper: (ChartDataDonut data, _) => data.x,
                            yValueMapper: (ChartDataDonut data, _) => data.y,
                            dataLabelMapper: (ChartDataDonut data, _) => data.x,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true))
                      ]))),
                      Center(
                        child: SfCartesianChart(
                          zoomPanBehavior: _zoomPanBehavior,
                          plotAreaBorderWidth: 0,
                          title: ChartTitle(text: 'Inflation - Consumer price'),
                          legend:
                              Legend(overflowMode: LegendItemOverflowMode.wrap),
                          primaryXAxis: DateTimeAxis(
                            edgeLabelPlacement: EdgeLabelPlacement.shift,
                            dateFormat: DateFormat.yMd(),
                            intervalType: DateTimeIntervalType.months,
                            interval: 0.5,
                          ),
                          primaryYAxis: NumericAxis(
                              labelFormat: '{value}€',
                              minimum: 0,
                              maximum: transakzioMax,
                              interval: transakzioMax/5,
                              majorGridLines: const MajorGridLines(
                                  color: Colors.transparent)),
                          series: _getDefaultLineSeries(),
                          tooltipBehavior: TooltipBehavior(enable: true),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.4,
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }

  AppBar appBarDetails(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink,
      title: const Text('Lehen jokoa'),
      elevation: 0,
      actions: [
        TextButton.icon(
            onPressed: () {
              LoginAuth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Homepage()),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: const Text(
              'Atera',
              style: TextStyle(color: Colors.white),
            ))
      ],
    );
  }

  void getChartData() async {
    setState(() {
      _isLoading = true;
    });

    String userCred = '';
    double sumAllTransactions = 0.0;
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

      double irabazitakoa = 0.0;
      double galdutakoa = 0.0;
      await _firestore
          .collection('users')
          .doc(userCred)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        transactionDocList = querySnapshot.docs;
        //     var newMap = groupBy(querySnapshot.docs.toList(), (QueryDocumentSnapshot e) {
        // return e.data;
        // });

        DateTime getDate = DateTime(1555, 1, 1);
        double amountGained1day = 0.0;
        double amountLost1day = 0.0;

        for (var doc in querySnapshot.docs) {
          //Lehenengo karakterea kendu eta zenbakia double bihurtu behar: '+50'(String) -> 50 (double)
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);

          DateTime currentDate = doc['data'].toDate();
          bool zerodaysDifference = getDate.difference(currentDate).inDays == 0;

          if (zerodaysDifference) {
            if (transDoubleValue > 0) {
              amountGained1day += transDoubleValue;
              irabazitakoa += transDoubleValue;
            } else {
              amountLost1day += transDoubleValue;
              galdutakoa += transDoubleValue * (-1);
            }

            if (doc.id == querySnapshot.docs.last.id) {
              getDate = currentDate;
              if (transakzioMax < amountGained1day) {
                transakzioMax = amountGained1day;
              }
              if (transakzioMax < amountLost1day) {
                transakzioMax = amountLost1day;
              }
              chartData!
                  .add(_ChartData(getDate, amountGained1day, amountLost1day));
            }
          } else {
            if (getDate != DateTime(1555, 1, 1)) {
              if (transakzioMax < amountGained1day) {
                transakzioMax = amountGained1day;
              }
              if (transakzioMax < amountLost1day) {
                transakzioMax = amountLost1day;
              }
              chartData!
                  .add(_ChartData(getDate, amountGained1day, amountLost1day));
              amountGained1day = 0.0;
              amountLost1day = 0.0;
            }
            if (transDoubleValue > 0) {
              amountGained1day += transDoubleValue;
              irabazitakoa += transDoubleValue;
            } else {
              amountLost1day += transDoubleValue;
              galdutakoa += transDoubleValue * (-1);
            }

            if (doc.id == querySnapshot.docs.last.id) {
              getDate = currentDate;
              if (transakzioMax < amountGained1day) {
                transakzioMax = amountGained1day;
              }
              if (transakzioMax < amountLost1day) {
                transakzioMax = amountLost1day;
              }
              chartData!
                  .add(_ChartData(getDate, amountGained1day, amountLost1day));
            }
          }
          getDate = currentDate;
        }
      });
      setState(() {
        chartData;
        galdutakoDirua = galdutakoa;
        irabazitakoDirua = irabazitakoa;
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      double irabazitakoa = 0.0;
      double galdutakoa = 0.0;
      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          if (getTransString.substring(0, 1) == '+') {
            irabazitakoa += transDoubleValue;
          } else {
            galdutakoa += transDoubleValue;
          }
        }
      });

      setState(() {
        galdutakoDirua = galdutakoa;
        irabazitakoDirua = irabazitakoa;
      });
    }

    final List<ChartDataDonut> chartDonutData = [
      ChartDataDonut(
          'Irabazia', irabazitakoDirua, const Color.fromRGBO(9, 0, 136, 1)),
      ChartDataDonut(
          'Galdua', galdutakoDirua, const Color.fromRGBO(147, 0, 119, 1)),
    ];

    _chartDonutData = chartDonutData;

    setState(() {
      _isLoading = false;
    });
  }

  /// The method returns line series to chart.
  List<LineSeries<_ChartData, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData!,
          xValueMapper: (_ChartData sales, _) => sales.date,
          yValueMapper: (_ChartData sales, _) => sales.irabazitakoa,
          width: 2,
          name: 'Irabaziak',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData!,
          width: 2,
          name: 'Galtzeak',
          xValueMapper: (_ChartData sales, _) => sales.date,
          yValueMapper: (_ChartData sales, _) => sales.galdutakoa,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}

class ChartDataDonut {
  ChartDataDonut(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class _ChartData {
  _ChartData(this.date, this.irabazitakoa, this.galdutakoa);
  final DateTime date;
  final double irabazitakoa;
  final double galdutakoa;
}

class BackgroundHome extends StatelessWidget {
  const BackgroundHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment(0.4, 0.5),
          colors: <Color>[
            Color.fromARGB(235, 153, 0, 76),
            Color.fromARGB(235, 204, 0, 102)
          ],
          tileMode: TileMode.repeated,
        ),
      ),
    );
  }
}
