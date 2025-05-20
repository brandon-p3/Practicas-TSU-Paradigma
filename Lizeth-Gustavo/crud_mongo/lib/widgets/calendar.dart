import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  final Function(DateTime selectedDay)? onDaySelected;

  const CustomCalendar({this.onDaySelected, Key? key}) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final List<String> _months = const [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre', 'Holaa'
  ];
  final List<int> _years = List.generate(130, (i) => 1900 + i); 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Este es el campo para seleccionar un mes
            DropdownButton<String>(
              value: _months[_focusedDay.month -1 ],
              items: _months.map((m) {
                return DropdownMenuItem(value: m, child: Text(m));
              }).toList(),
              onChanged: (month) {
                final newMonth = _months.indexOf(month!) + 1;
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, newMonth, 1);
                });
              },
            ),
            const SizedBox(width: 10),
            //Este es el campo para seleccionar un año
            DropdownButton<int>(
              value: _focusedDay.year,
              items: _years.map((y) {
                return DropdownMenuItem(value: y, child: Text('$y'));
              }).toList(),
              onChanged: (year) {
                setState(() {
                  _focusedDay = DateTime(year!, _focusedDay.month, 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Calendario
        TableCalendar(
          firstDay: DateTime.utc(1900, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            widget.onDaySelected?.call(selectedDay);
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) => setState(() => _calendarFormat = format),
          onPageChanged: (focusedDay) => _focusedDay = focusedDay,
          headerVisible: false,
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, _) => Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
