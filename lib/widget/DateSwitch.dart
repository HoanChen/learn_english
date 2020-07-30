import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';

class DateSwitch extends StatefulWidget {
  final Function callback;
  final String dateStr;

  DateSwitch({Key key, this.dateStr, @required this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateSwitchState();
}

class _DateSwitchState extends State<DateSwitch> {
  DateTime _date;
  String _dateStr;
  var _dateType = 0; //0 时间最小，2 时间最大

  @override
  void initState() {
    if (widget.dateStr == null) {
      _setDateField(DateTime.now());
      widget.callback(_dateStr);
    } else {
      _setDateField(DateTime.parse('${widget.dateStr}-01'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Visibility(
            visible: _dateType != 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  int _year = _date.year;
                  int _month = _date.month;
                  if (_date.month == 1) {
                    _year -= 1;
                    _month = 12;
                  } else {
                    _month -= 1;
                  }
                  _setDateField(DateTime(_year, _month));
                });
                widget.callback(_dateStr);
              },
              icon: Icon(Icons.chevron_left),
            )),
        GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020, 5),
                lastDate: DateTime.now(),
              ).then((DateTime dateTime) {
                if (dateTime != null) {
                  setState(() {
                    _setDateField(dateTime);
                  });
                  widget.callback(_dateStr);
                }
              });
            },
            child: Text(
              _dateStr,
              style: TextStyle(fontSize: 15.0, color: MyColors.accentColor),
            )),
        Visibility(
            visible: _dateType != 2,
            child: IconButton(
              onPressed: () {
                setState(() {
                  int _year = _date.year;
                  int _month = _date.month;
                  if (_date.month == 12) {
                    _year += 1;
                    _month = 1;
                  } else {
                    _month += 1;
                  }
                  _setDateField(DateTime(_year, _month));
                });
                widget.callback(_dateStr);
              },
              icon: Icon(Icons.chevron_right),
            )),
      ]));

  void _setDateField(DateTime dateTime) {
    _date = dateTime;
    _dateStr =
        "${_date.year.toString()}-${_date.month.toString().padLeft(2, '0')}";
    var now = DateTime.now();
    if (_date.year == now.year && _date.month == now.month) {
      _dateType = 2;
    } else if (_date.year == 2020 && _date.month == 5) {
      _dateType = 0;
    } else {
      _dateType = 1;
    }
  }
}
