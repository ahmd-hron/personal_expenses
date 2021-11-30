import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/transaction_List.dart';
import './widgets/new_Transaction.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); //makethe app forced in PortriatUp or Down
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'OnpenSans',
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'QuickSand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                    fontFamily: 'QuickSand',
                    fontSize: 20,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  List<Transaction> get _recentTransaction {
    return _userTransactions.where(
      (tx) {
        return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
      },
    ).toList();
  }

  bool _showChart = true;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    super.didChangeAppLifecycleState(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget build(BuildContext cx) {
    final mediaQuery = MediaQuery.of(context);
    final _isLandescape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'personal expess',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddtNewTransaction(cx),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('personal expess'),
            actions: [
              IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () => _startAddtNewTransaction(cx),
              )
            ],
          );
    final _txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionsList(
        _userTransactions,
        _deleteTransaction,
      ),
    );
    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (_isLandescape)
              ..._buildLandscapeMode(
                  mediaQuery, appBar, _txListWidget, _showChart),
            if (!_isLandescape)
              ..._buildPortriatMode(mediaQuery, appBar, _txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyWidget,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyWidget,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _startAddtNewTransaction(cx),
              child: const Icon(
                Icons.add,
              ),
            ),
          );
  }

  List<Widget> _buildLandscapeMode(MediaQueryData mediaQuery, AppBar appBar,
      Widget txTransaction, bool showChart) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'show Chart',
          style: Theme.of(context).textTheme.headline6,
        ),
        Switch(
          value: _showChart,
          onChanged: (val) {
            setState(
              () {
                _showChart = val;
              },
            );
          },
          activeColor: Theme.of(context).accentColor,
          inactiveTrackColor: Color.fromRGBO(220, 220, 220, 1),
        )
      ]),
      showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(
                _recentTransaction,
              ),
            )
          : txTransaction
    ];
  }

  List<Widget> _buildPortriatMode(
      MediaQueryData mediaQuery, AppBar appBar, Widget transactionList) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(
          _recentTransaction,
        ),
      ),
      transactionList,
    ];
  }

  void _startAddtNewTransaction(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(
            25,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      // isScrollControlled: true,
      context: context,
      builder: (_) {
        return NewTransaction(
          _addTransaction,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(
      () {
        _userTransactions.removeWhere(
          (transaction) => transaction.id == id,
        );
      },
    );
  }

  void _addTransaction(String title, double amount, DateTime date) {
    final nTransaction = Transaction(
        amount: amount,
        title: title,
        date: date,
        id: DateTime.now().toString());
    setState(() {
      _userTransactions.add(nTransaction);
    });
  }
}
