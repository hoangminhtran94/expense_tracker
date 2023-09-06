import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Maths",
        amount: 2.1,
        date: DateTime.now(),
        category: Category.food),
    Expense(
        title: "Literature",
        amount: 3,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: "Science travel show",
        amount: 1.5,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: "Movie ticket",
        amount: 4,
        date: DateTime.now(),
        category: Category.work),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text("The chart"),
          Expanded(child: ExpensesList(expenses: _registeredExpenses))
        ],
      ),
    );
  }
}
