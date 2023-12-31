import 'package:flutter/material.dart';
import "package:expense_tracker/models/expense.dart";

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onNewExpense});
  final void Function(Expense expense) onNewExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate == null ? now : _selectedDate!,
        firstDate: DateTime(now.year - 1, now.month, now.day),
        lastDate: DateTime.now());
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final ammountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        ammountIsInvalid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text("Invalid inputs"),
                content: const Text(
                    "Please make sure a valid title, amouunt,date and category was entered"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Close"))
                ],
              ));
      return;
    }
    widget.onNewExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constrainst) {
      final width = constrainst.maxWidth;
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: Column(children: [
            width >= 600
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text("Title"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "\$",
                            label: Text("Amount"),
                          ),
                        ),
                      )
                    ],
                  )
                : TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
            width >= 600
                ? Row(
                    children: [
                      Expanded(
                        child: DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name
                                        .toString()
                                        .toUpperCase())))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? "No Date Selected"
                              : formatter.format(_selectedDate!)),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ))
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixText: "\$",
                            label: Text("Amount"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? "No Date Selected"
                              : formatter.format(_selectedDate!)),
                          IconButton(
                              onPressed: _presentDatePicker,
                              icon: const Icon(Icons.calendar_month))
                        ],
                      ))
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
            width >= 600
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expense")),
                    ],
                  )
                : Row(
                    children: [
                      DropdownButton(
                          value: _selectedCategory,
                          items: Category.values
                              .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                      category.name.toString().toUpperCase())))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            setState(() {
                              _selectedCategory = value;
                            });
                          }),
                      const Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: _submitExpenseData,
                          child: const Text("Save Expense")),
                    ],
                  )
          ]),
        ),
      );
    });
  }
}
