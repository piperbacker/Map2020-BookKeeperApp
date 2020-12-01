import 'package:bookkeeperapp/controller/firebasecontroller.dart';
import 'package:bookkeeperapp/model/bkbook.dart';
import 'package:bookkeeperapp/model/bkuser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';

class AuthorMetricsScreen extends StatefulWidget {
  static const routeName = 'home/authorMetricsScreen';

  @override
  State<StatefulWidget> createState() {
    return _AuthorMetricsState();
  }
}

class _AuthorMetricsState extends State<AuthorMetricsScreen> {
  User user;
  BKUser bkUser;
  List<BKBook> bkBooks;
  _Controller con;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args['user'];
    bkUser ??= args['bkUser'];
    bkBooks ??= args['bkBooks'];

    Map<String, double> dataMap = {
      for (var book in bkBooks) book.title: book.downloads.toDouble()
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Book Downloads'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.0,
            ),
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 50,
              chartRadius: MediaQuery.of(context).size.width / 1.5,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 40,
              centerText: "Downloads",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                chartValueStyle: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                ),
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesInPercentage: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Controller {
  _AuthorMetricsState _state;
  _Controller(this._state);
}
