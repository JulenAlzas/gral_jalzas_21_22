import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gral_jalzas_21_22/logic/login_auth.dart';
import 'package:gral_jalzas_21_22/screens/barchart.dart';
import 'package:gral_jalzas_21_22/screens/gallery_scaffold.dart';
import 'package:gral_jalzas_21_22/screens/homepage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;

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
  bool daytype = false;
  var transactionDocList = [];
  double dataIntervals = 1.0;
  List<ChartDataDonut> _chartDonutData = [];
  List<_ChartData>? chartData = <_ChartData>[];

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

    return Scaffold(
      appBar: appBarDetails(context),
      body: SingleChildScrollView(
        child: _isLoading
            ? Lottie.network(
                'https://assets2.lottiefiles.com/packages/lf20_r7h02cq4.json')
            : Stack(
                children: [
                  const BackgroundHome(),
                  Column(
                    children: [
                      DonutDiagrama(chartDonutData: _chartDonutData),
                      lerroDiagrama(),
                      BarraDiagrama(screenSize: screenSize),
                    ],
                  )
                ],
              ),
      ),
    );
  }

  Center lerroDiagrama() {
    return Center(
      child: SfCartesianChart(
        zoomPanBehavior: _zoomPanBehavior,
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Eguneroko transak. totalak'),
        legend: Legend(overflowMode: LegendItemOverflowMode.wrap),
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: DateFormat.yMd(),
          intervalType:
              daytype ? DateTimeIntervalType.days : DateTimeIntervalType.months,
          interval: dataIntervals,
        ),
        primaryYAxis: NumericAxis(
            labelFormat: '{value}€',
            minimum: 0,
            maximum: transakzioMax,
            interval: transakzioMax / 5,
            majorGridLines: const MajorGridLines(color: Colors.transparent)),
        series: _getDefaultLineSeries(),
        tooltipBehavior: TooltipBehavior(enable: true),
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
              Navigator.pop(context);
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

        DateTime nearestData = querySnapshot.docs.first['data'].toDate();
        DateTime latestData = querySnapshot.docs.last['data'].toDate();

        calculateIntervals(nearestData, latestData);
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

          // bool zerodaysDifference = getDate.difference(currentDate).inDays == 0;
          bool zerodaysDifference = (getDate.year == currentDate.year &&
              getDate.month == currentDate.month &&
              getDate.day == currentDate.day);

          if (zerodaysDifference) {
            if (isPossitive(transDoubleValue)) {
              amountGained1day += transDoubleValue;
              irabazitakoa += transDoubleValue;
            } else {
              amountLost1day += transDoubleValue * (-1);
              galdutakoa += transDoubleValue;
            }

            getDate = ifLastDocumetAddAndroidWeb(doc, querySnapshot, getDate,
                currentDate, amountGained1day, amountLost1day);
          } else {
            if (isNotInitializedDate(getDate)) {
              setTransMaxIfPossible(amountGained1day, amountLost1day);
              chartData!
                  .add(_ChartData(getDate, amountGained1day, amountLost1day));
              amountGained1day = 0.0;
              amountLost1day = 0.0;
            }

            if (isPossitive(transDoubleValue)) {
              amountGained1day += transDoubleValue;
              irabazitakoa += transDoubleValue;
            } else {
              amountLost1day += transDoubleValue * (-1);
              galdutakoa += transDoubleValue;
            }

            getDate = ifLastDocumetAddAndroidWeb(doc, querySnapshot, getDate,
                currentDate, amountGained1day, amountLost1day);
          }
          getDate = currentDate;
        }
      });
      setState(() {
        _chartDonutData;
        chartData;
        galdutakoDirua = galdutakoa;
        irabazitakoDirua = irabazitakoa;
        setDonutData();
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
        transactionDocList = querySnapshot;

        DateTime nearestData = querySnapshot.first['data'];
        DateTime latestData = querySnapshot.last['data'];

        calculateIntervals(nearestData, latestData);

        //     var newMap = groupBy(querySnapshot.docs.toList(), (QueryDocumentSnapshot e) {
        // return e.data;
        // });

        DateTime getDate = DateTime(1555, 1, 1);
        double amountGained1day = 0.0;
        double amountLost1day = 0.0;

        for (var doc in querySnapshot) {
          //Lehenengo karakterea kendu eta zenbakia double bihurtu behar: '+50'(String) -> 50 (double)
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          DateTime currentDate = doc['data'];

          // bool zerodaysDifference = getDate.difference(currentDate).inDays == 0;
          bool zerodaysDifference = (getDate.year == currentDate.year &&
              getDate.month == currentDate.month &&
              getDate.day == currentDate.day);

          if (zerodaysDifference) {
            if (isPossitive(transDoubleValue)) {
              amountGained1day += transDoubleValue;
              irabazitakoa += transDoubleValue;
            } else {
              amountLost1day += transDoubleValue * (-1);
              galdutakoa += transDoubleValue;
            }

            getDate = ifLastDocumendAddDesktop(doc, querySnapshot, getDate,
                currentDate, amountGained1day, amountLost1day);
          } else {
            if (isNotInitializedDate(getDate)) {
              setTransMaxIfPossible(amountGained1day, amountLost1day);
              chartData!
                  .add(_ChartData(getDate, amountGained1day, amountLost1day));
              amountGained1day = 0.0;
              amountLost1day = 0.0;
            }

            if (isPossitive(transDoubleValue)) {
              amountGained1day += transDoubleValue;
              irabazitakoa += transDoubleValue;
            } else {
              amountLost1day += transDoubleValue * (-1);
              galdutakoa += transDoubleValue;
            }

            getDate = ifLastDocumendAddDesktop(doc, querySnapshot, getDate,
                currentDate, amountGained1day, amountLost1day);
          }
          getDate = currentDate;
        }
      });

      setState(() {
        _chartDonutData;
        chartData;
        galdutakoDirua = galdutakoa;
        irabazitakoDirua = irabazitakoa;
        setDonutData();
      });
    }
    // await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }

  void setDonutData() {
    final List<ChartDataDonut> chartDonutData = [
      ChartDataDonut(
          'Transakzio +', irabazitakoDirua, const Color.fromRGBO(9, 0, 136, 1)),
      ChartDataDonut(
          'Transakzio -', galdutakoDirua, const Color.fromRGBO(147, 0, 119, 1)),
    ];

    _chartDonutData = chartDonutData;
  }

  void setTransMaxIfPossible(double amountGained1day, double amountLost1day) {
    if (transakzioMax < amountGained1day) {
      transakzioMax = amountGained1day;
    }
    if (transakzioMax < amountLost1day) {
      transakzioMax = amountLost1day;
    }
  }

  bool isNotInitializedDate(DateTime getDate) =>
      getDate != DateTime(1555, 1, 1);

  bool isPossitive(double transDoubleValue) => transDoubleValue > 0;

  DateTime ifLastDocumendAddDesktop(
      firedart.Document doc,
      List<firedart.Document> querySnapshot,
      DateTime getDate,
      DateTime currentDate,
      double amountGained1day,
      double amountLost1day) {
    if (doc.id == querySnapshot.last.id) {
      getDate = currentDate;
      if (transakzioMax < amountGained1day) {
        transakzioMax = amountGained1day;
      }
      if (transakzioMax < amountLost1day) {
        transakzioMax = amountLost1day;
      }
      chartData!.add(_ChartData(getDate, amountGained1day, amountLost1day));
    }
    return getDate;
  }

  DateTime ifLastDocumetAddAndroidWeb(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      DateTime getDate,
      DateTime currentDate,
      double amountGained1day,
      double amountLost1day) {
    if (doc.id == querySnapshot.docs.last.id) {
      getDate = currentDate;
      if (transakzioMax < amountGained1day) {
        transakzioMax = amountGained1day;
      }
      if (transakzioMax < amountLost1day) {
        transakzioMax = amountLost1day;
      }
      chartData!.add(_ChartData(getDate, amountGained1day, amountLost1day));
    }
    return getDate;
  }

  void calculateIntervals(DateTime nearestData, DateTime latestData) {
    if (nearestData.year == latestData.year) {
      int daysDif = latestData.day - nearestData.day;
      if (nearestData.month == latestData.month) {
        if (latestData.month - nearestData.day >= 5) {
          dataIntervals = daysDif / 5;
        }
        daytype = true;
      } else {
        int monthsDif = latestData.month - nearestData.month;
        dataIntervals = monthsDif / 5;
      }
    } else {
      if (latestData.month >= nearestData.month ||
          latestData.year - nearestData.year > 1) {
        dataIntervals = 12;
      } else {
        int monthsDif = (12 - nearestData.month) + latestData.month;
        dataIntervals = monthsDif / 5;
      }
    }
  }

  /// The method returns line series to chart.
  List<LineSeries<_ChartData, DateTime>> _getDefaultLineSeries() {
    return <LineSeries<_ChartData, DateTime>>[
      LineSeries<_ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData!,
          xValueMapper: (_ChartData sales, _) => sales.date,
          yValueMapper: (_ChartData sales, _) => sales.irabazitakoa1Egun,
          width: 2,
          name: 'Transak. +',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, DateTime>(
          animationDuration: 2500,
          dataSource: chartData!,
          width: 2,
          name: 'Transak. -',
          xValueMapper: (_ChartData sales, _) => sales.date,
          yValueMapper: (_ChartData sales, _) => sales.galdutakoa1Egun,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }
}

class BarraDiagrama extends StatelessWidget {
  const BarraDiagrama({
    Key? key,
    required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenSize.width,
      height: screenSize.height * 0.4,
      child: GalleryScaffold(
        title: 'Barra-diagrama',
        subtitle: 'Irabazi/galtze/sartutakoDirua',
        childBuilder: () => const BarChart(),
      ),
    );
  }
}

class DonutDiagrama extends StatelessWidget {
  const DonutDiagrama({
    Key? key,
    required List<ChartDataDonut> chartDonutData,
  })  : _chartDonutData = chartDonutData,
        super(key: key);

  final List<ChartDataDonut> _chartDonutData;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SfCircularChart(
            title: ChartTitle(text: 'Transakzio guztien diagrama'),
            legend: Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: <CircularSeries>[
          // Renders doughnut chart
          DoughnutSeries<ChartDataDonut, String>(
              dataSource: _chartDonutData,
              pointColorMapper: (ChartDataDonut data, _) => data.color,
              xValueMapper: (ChartDataDonut data, _) => data.x,
              yValueMapper: (ChartDataDonut data, _) => data.y,
              dataLabelMapper: (ChartDataDonut data, _) => data.y.toString(),
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              explode: true,
              explodeGesture: ActivationMode.singleTap)
        ]));
  }
}

class ChartDataDonut {
  ChartDataDonut(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}

class _ChartData {
  _ChartData(this.date, this.irabazitakoa1Egun, this.galdutakoa1Egun);
  final DateTime date;
  final double irabazitakoa1Egun;
  final double galdutakoa1Egun;
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
