import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTransactionFun;
  const NewTransaction(this.newTransactionFun);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();
  DateTime selectedDate;

  @override
  Widget build(BuildContext ctx) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: titleController,
                onSubmitted: (_) => _onSubmitted(),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount ',
                ),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _onSubmitted(),
              ),
              Container(
                height: 65,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'enter date'
                            : 'Date :${DateFormat.yMEd().format(
                                selectedDate,
                              )}',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _showDatePicker();
                      },
                      child: const Text(
                        'Chose Date',
                        style: TextStyle(color: Colors.purple, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purple),
                ),
                onPressed: _onSubmitted,
                child: const Text(
                  'Add Transaction ',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmitted() {
    if (titleController.text.isEmpty) return;
    final title = titleController.text;
    final amount = double.parse(amountController.text);
    final date = selectedDate;
    if (title.isEmpty || amount <= 0 || date == null) return;

    widget.newTransactionFun(title, amount, date);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: (DateTime(2018)),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) {
        if (pickedDate == null) return;
        setState(() {
          selectedDate = pickedDate;
        });
      },
    );
  }
}
