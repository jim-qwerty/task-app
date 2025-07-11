// lib/widgets/month_day_selector.dart

import 'dart:math';
import 'package:flutter/material.dart';

class MonthDaySelector extends StatelessWidget {
  final List<int> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const MonthDaySelector({
    Key? key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calcula ventana de 7 días centrada en selectedIndex (3 previos + seleccionado + 3 posteriores)
    final total = days.length;
    final start = max(0, selectedIndex - 3);
    final end = min(total - 1, selectedIndex + 3);
    final window = List.generate(end - start + 1, (i) => start + i);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: window.map((idx) {
        final day = days[idx];
        final isSelected = idx == selectedIndex;
        final size = isSelected ? 50.0 : 40.0;
        return GestureDetector(
          onTap: () => onDaySelected(idx),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFFFDAC1)  // Peach
                  : Colors.white12,
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
