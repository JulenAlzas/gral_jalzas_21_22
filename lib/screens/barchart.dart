import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart' as authforandroid;
import 'package:firedart/firedart.dart' as firedart;
import 'package:gral_jalzas_21_22/screens/edit_profile.dart';
import 'package:intl/intl.dart';

class IconRenderer extends charts.CustomSymbolRenderer {
  final IconData iconData;

  IconRenderer(this.iconData);

  @override
  Widget build(BuildContext context,
      {Size? size, Color? color, bool enabled = true}) {
    if (color != null && !enabled) {
      color = color.withOpacity(0.26);
    }

    return SizedBox.fromSize(
        size: size, child: Icon(iconData, color: color, size: 12.0));
  }
}

class BarChart extends StatefulWidget {
  const BarChart({Key? key}) : super(key: key);

  @override
  State<BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {
  List<charts.Series<dynamic, String>> seriesList = [];
  final bool animate = false;
  bool isloading = true;

  @override
  void initState() {
    _getDataDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return const KargatzeAnimazioa();
    } else {
      return charts.BarChart(
        seriesList,
        animate: animate,
        animationDuration: Duration.zero,
        domainAxis: charts.OrdinalAxisSpec(
            viewport: charts.OrdinalViewport(
          DateFormat('yyyy-MM-dd').format(seriesList[0].data[0].date),
          3,
        )),
        behaviors: [
          charts.SeriesLegend(),
          charts.PanAndZoomBehavior(),
        ],
        defaultRenderer: charts.BarRendererConfig(
          symbolRenderer: IconRenderer(Icons.cloud),
          barRendererDecorator: charts.BarLabelDecorator<String>(),
        ),
      );
    }
  }

  void _getDataDB() async {
    setState(() {
      isloading = true;
    });

    List<AmountDateTrans> kontuanSartutakoa = [];
    List<AmountDateTrans> kontuanIrabazitakoa = [];
    List<AmountDateTrans> kontuanGaldutakoa = [];

    String userCred = '';
    if (defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      userCred =
          authforandroid.FirebaseAuth.instance.currentUser?.uid ?? 'no-id';

      await _firestore
          .collection('users')
          .doc(userCred)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        DateTime getDate = DateTime(1555, 1, 1);

        double amountGained1day = 0.0;
        double amountLost1day = 0.0;
        double amountAdded1day = 0.0;

        for (var doc in querySnapshot.docs) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          DateTime currentDate = doc['data'].toDate();
          String transMota = doc['trans_mota'].split('_')[1];

          bool zerodaysDifference = (getDate.year == currentDate.year &&
              getDate.month == currentDate.month &&
              getDate.day == currentDate.day);

          if (zerodaysDifference) {
            if (transMota == 'irabazi') {
              amountGained1day += transDoubleValue;
            } else if (transMota == 'galdu') {
              amountLost1day += transDoubleValue * (-1);
            } else {
              amountAdded1day += transDoubleValue;
            }

            getDate = ifLastDocumetAddAndroidWeb(
                doc,
                querySnapshot,
                getDate,
                currentDate,
                kontuanSartutakoa,
                amountAdded1day,
                kontuanIrabazitakoa,
                amountGained1day,
                kontuanGaldutakoa,
                amountLost1day);
          } else {
            if (isNotInitializedDate(getDate)) {
              kontuanSartutakoa
                  .add(AmountDateTrans(getDate, amountAdded1day.toInt()));
              kontuanIrabazitakoa
                  .add(AmountDateTrans(getDate, amountGained1day.toInt()));
              kontuanGaldutakoa
                  .add(AmountDateTrans(getDate, amountLost1day.toInt()));
              amountGained1day = 0.0;
              amountLost1day = 0.0;
              amountAdded1day = 0.0;
            }
            if (transMota == 'irabazi') {
              amountGained1day += transDoubleValue;
            } else if (transMota == 'galdu') {
              amountLost1day += transDoubleValue * (-1);
            } else {
              amountAdded1day += transDoubleValue;
            }

            getDate = ifLastDocumetAddAndroidWeb(
                doc,
                querySnapshot,
                getDate,
                currentDate,
                kontuanSartutakoa,
                amountAdded1day,
                kontuanIrabazitakoa,
                amountGained1day,
                kontuanGaldutakoa,
                amountLost1day);
          }
          getDate = currentDate;
        }
      });
    } else {
      firedart.FirebaseAuth auth = firedart.FirebaseAuth.instance;

      String userId = auth.userId;

      await firedart.Firestore.instance
          .collection('users')
          .document(userId)
          .collection('moneyTransactions')
          .orderBy('data', descending: false)
          .get()
          .then((querySnapshot) {
        DateTime getDate = DateTime(1555, 1, 1);

        double amountGained1day = 0.0;
        double amountLost1day = 0.0;
        double amountAdded1day = 0.0;

        for (var doc in querySnapshot) {
          String getTransString = doc['zenbat'];
          double transDoubleValue = double.parse(getTransString);
          DateTime currentDate = doc['data'];
          String transMota = doc['trans_mota'].split('_')[1];

          bool zerodaysDifference = (getDate.year == currentDate.year &&
              getDate.month == currentDate.month &&
              getDate.day == currentDate.day);

          if (zerodaysDifference) {
            if (transMota == 'irabazi') {
              amountGained1day += transDoubleValue;
            } else if (transMota == 'galdu') {
              amountLost1day += transDoubleValue * (-1);
            } else {
              amountAdded1day += transDoubleValue;
            }

            getDate = ifLastDocumendAddDesktop(
                doc,
                querySnapshot,
                getDate,
                currentDate,
                kontuanSartutakoa,
                amountAdded1day,
                kontuanIrabazitakoa,
                amountGained1day,
                kontuanGaldutakoa,
                amountLost1day);
          } else {
            if (isNotInitializedDate(getDate)) {
              kontuanSartutakoa
                  .add(AmountDateTrans(getDate, amountAdded1day.toInt()));
              kontuanIrabazitakoa
                  .add(AmountDateTrans(getDate, amountGained1day.toInt()));
              kontuanGaldutakoa
                  .add(AmountDateTrans(getDate, amountLost1day.toInt()));
              amountGained1day = 0.0;
              amountLost1day = 0.0;
              amountAdded1day = 0.0;
            }
            if (transMota == 'irabazi') {
              amountGained1day += transDoubleValue;
            } else if (transMota == 'galdu') {
              amountLost1day += transDoubleValue * (-1);
            } else {
              amountAdded1day += transDoubleValue;
            }

            getDate = ifLastDocumendAddDesktop(
                doc,
                querySnapshot,
                getDate,
                currentDate,
                kontuanSartutakoa,
                amountAdded1day,
                kontuanIrabazitakoa,
                amountGained1day,
                kontuanGaldutakoa,
                amountLost1day);
          }
          getDate = currentDate;
        }
      });
    }

    seriesList = [
      charts.Series<AmountDateTrans, String>(
        labelAccessorFn: (AmountDateTrans sales, _) => sales.sales.toString(),
        id: 'Sartutakoa',
        domainFn: (AmountDateTrans sales, _) =>
            DateFormat('yyyy-MM-dd').format(sales.date),
        measureFn: (AmountDateTrans sales, _) => sales.sales,
        data: kontuanSartutakoa,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      charts.Series<AmountDateTrans, String>(
        id: 'Irabazia',
        domainFn: (AmountDateTrans sales, _) =>
            DateFormat('yyyy-MM-dd').format(sales.date),
        measureFn: (AmountDateTrans sales, _) => sales.sales,
        data: kontuanIrabazitakoa,
        labelAccessorFn: (AmountDateTrans sales, _) => sales.sales.toString(),
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
      charts.Series<AmountDateTrans, String>(
        id: 'Galdua',
        domainFn: (AmountDateTrans sales, _) =>
            DateFormat('yyyy-MM-dd').format(sales.date),
        measureFn: (AmountDateTrans sales, _) => sales.sales,
        data: kontuanGaldutakoa,
        labelAccessorFn: (AmountDateTrans sales, _) => sales.sales.toString(),
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
      ),
    ];

    setState(() {
      isloading = false;
    });
  }

  DateTime ifLastDocumetAddAndroidWeb(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      QuerySnapshot<Map<String, dynamic>> querySnapshot,
      DateTime getDate,
      DateTime currentDate,
      List<AmountDateTrans> kontuanSartutakoa,
      double amountAdded1day,
      List<AmountDateTrans> kontuanIrabazitakoa,
      double amountGained1day,
      List<AmountDateTrans> kontuanGaldutakoa,
      double amountLost1day) {
    if (doc.id == querySnapshot.docs.last.id) {
      getDate = currentDate;
      kontuanSartutakoa.add(AmountDateTrans(getDate, amountAdded1day.toInt()));
      kontuanIrabazitakoa
          .add(AmountDateTrans(getDate, amountGained1day.toInt()));
      kontuanGaldutakoa.add(AmountDateTrans(getDate, amountLost1day.toInt()));
    }
    return getDate;
  }

  bool isNotInitializedDate(DateTime getDate) =>
      getDate != DateTime(1555, 1, 1);

  DateTime ifLastDocumendAddDesktop(
      firedart.Document doc,
      List<firedart.Document> querySnapshot,
      DateTime getDate,
      DateTime currentDate,
      List<AmountDateTrans> kontuanSartutakoa,
      double amountAdded1day,
      List<AmountDateTrans> kontuanIrabazitakoa,
      double amountGained1day,
      List<AmountDateTrans> kontuanGaldutakoa,
      double amountLost1day) {
    if (doc.id == querySnapshot.last.id) {
      getDate = currentDate;
      kontuanSartutakoa.add(AmountDateTrans(getDate, amountAdded1day.toInt()));
      kontuanIrabazitakoa
          .add(AmountDateTrans(getDate, amountGained1day.toInt()));
      kontuanGaldutakoa.add(AmountDateTrans(getDate, amountLost1day.toInt()));
    }
    return getDate;
  }
}

class AmountDateTrans {
  final DateTime date;
  final int sales;

  AmountDateTrans(this.date, this.sales);
}
