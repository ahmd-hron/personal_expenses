import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  final Function removeTransaction;
  const TransactionItem({Key key, this.removeTransaction, this.transaction})
      : super(key: key);

  final Transaction transaction;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bcColor;

  @override
  void initState() {
    const List<Color> avilableColors = [
      Colors.black,
      Colors.purple,
      Colors.green,
      Colors.red
    ];
    _bcColor = avilableColors[Random().nextInt(avilableColors.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 10,
      ),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bcColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(
              5,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '\$${widget.transaction.amount}',
              ),
            ),
          ),
        ),
        title: Text(
          '${widget.transaction.title}',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMEd().format(
            widget.transaction.date,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).errorColor,
          ),
          onPressed: () {
            _deleteSelectedTransaction(
              widget.transaction.id,
            );
          },
        ),
      ),
    );
  }

  void _deleteSelectedTransaction(String id) {
    widget.removeTransaction(id);
  }
}
