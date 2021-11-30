import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function removeTransaction;
  const TransactionsList(this.userTransaction, this.removeTransaction);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => userTransaction.isEmpty
          ? Column(
              children: [
                Container(
                  height: constraints.maxHeight * 0.10,
                  child: Text(
                    'No transaction yet ...',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.05),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView(
              children: userTransaction
                  .map((tx) => TransactionItem(
                        key: ValueKey(tx.id),
                        removeTransaction: removeTransaction,
                        transaction: tx,
                      ))
                  .toList(),
            ),
    );
  }
}

// for refrences we could just edit list view and add list view builder since it's much better for
//longer list becuase it only renders the elements on the current screen , more optimezed for long list
/* ListView.builder(
              itemCount: userTransaction.length,
              itemBuilder: (context, index) {
                return TransactionItem(
                  key: ValueKey(userTransaction[index].id),
                  removeTransaction: removeTransaction,
                  transactionItem: userTransaction[index],
                );
              },
            ),*/
