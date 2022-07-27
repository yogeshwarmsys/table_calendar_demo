// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils.dart';

var startDateFormat, endDateFormat, selectedDate;

class TableRangeExample extends StatefulWidget {
  @override
  _TableRangeExampleState createState() => _TableRangeExampleState();
}

class _TableRangeExampleState extends State<TableRangeExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOn; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Settlements'),
        leading: const Center(
            child: Text(
          'Close',
          style: TextStyle(fontSize: 16.0),
        )),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  '<\t\t>',
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          )
        ],
        backgroundColor: HexColor("#004F62"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Text(
                  'SELECT DATE RANGE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HexColor("#004F62"),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                      });
                    },
                    // ignore: sort_child_properties_last
                    child: Text('Clear',
                        style: selectedDate == null
                            ? TextStyle(color: HexColor("#B9C3C6"))
                            : TextStyle(color: HexColor("#448BA0"))),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#FFFFFF"),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                selectedDate != null
                    ? Text(
                        '$selectedDate',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: HexColor('#565F61'),
                            fontWeight: FontWeight.w400),
                      )
                    : Text(
                        'Start - End',
                        style: TextStyle(
                            color: HexColor('#B9C3C6'),
                            fontWeight: FontWeight.normal),
                      )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(thickness: 2.0, color: HexColor("#EDF2F3")),
          ),
          TableCalendar(
            daysOfWeekVisible: true,
            currentDay: DateTime.now(),
            availableGestures: AvailableGestures.all,
            headerStyle: const HeaderStyle(
                headerPadding: EdgeInsets.all(10.0),
                formatButtonVisible: false,
                rightChevronVisible: false,
                leftChevronVisible: false),
            sixWeekMonthsEnforced: false,
            calendarStyle: CalendarStyle(
                rangeHighlightColor: HexColor("#448BA0"),
                selectedDecoration: const BoxDecoration(
                  color: const Color(0xADD7BC),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: const BoxDecoration(
                  color: const Color(0x448BA0),
                  shape: BoxShape.circle,
                ),
                canMarkersOverflow: false),
            firstDay: DateTime.now().subtract(const Duration(days: 0)),
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            headerVisible: true,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _rangeStart = null; // Important to clean those
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;

                  // formatSingleDate(_selectedDay);
                });
              }
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
                _rangeSelectionMode = RangeSelectionMode.toggledOn;
                // Update values in a Set

                formatDate(_rangeStart, _rangeEnd);
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Divider(thickness: 2.0, color: HexColor("#EDF2F3")),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    // ignore: sort_child_properties_last
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: HexColor("#448BA0")),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: HexColor("#FFFFFF"),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      // ignore: sort_child_properties_last
                      child: Text(
                        'Search',
                        style: TextStyle(color: HexColor("#FFFFFF")),
                      ),
                      style: selectedDate == null
                          ? ElevatedButton.styleFrom(
                              primary: HexColor("#B9C3C6"),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal))
                          : ElevatedButton.styleFrom(
                              primary: HexColor("#448BA0"),
                              textStyle: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.normal)))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Selected Date Formatted
void formatDate(var startDate, var endDate) {
  if (startDate != null) {
    startDateFormat = DateFormat('MMM-dd-yy').format(startDate);
    // debugPrint('Formatted Start Date : $startDateFormat');
    selectedDate = "$startDateFormat - End";
  }
  if (endDate != null) {
    endDateFormat = DateFormat('MMM-dd-yy').format(endDate);
    // debugPrint('Formatted End Date : $endDateFormat');
    selectedDate = "Start  - $endDateFormat";
  }
  if (startDate != null && endDate != null) {
    selectedDate = "$startDateFormat - $endDateFormat";
    // debugPrint('Formatted Range Date : $selectedDate');
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
