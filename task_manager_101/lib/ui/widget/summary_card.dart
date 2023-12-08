
import 'package:flutter/material.dart';
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,required this.count,required this.title,
  });
  final String count,title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              " $count ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              " $title ",
            ),
          ],
        ),
      ),
    );
  }
}
