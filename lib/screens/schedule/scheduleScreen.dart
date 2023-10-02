import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:provider/provider.dart';
import 'package:thanhhoa_garden_staff_app/models/workingDate/schedule/working_date.dart';
import 'package:thanhhoa_garden_staff_app/providers/schedule/workingProvider.dart';
import '../../blocs/workingDate/workingDate_bloc.dart';
import '../../blocs/workingDate/workingDate_event.dart';
import '../../blocs/workingDate/workingDate_state.dart';
import '../../components/appBar.dart';
import '../../constants/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late WorkingDateBloc workingDateBloc;
  late Stream<WorkingDateState> workingDateStream;

  int selectedTab = 0;
  String today = getToday(DateTime.now());
  String test = '2023-09-18';

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<WorkingDate>> events = {};
  late final ValueNotifier<List<WorkingDate>> _selectedEvents;
  List<WorkingDate> _listDate = [];
  @override
  void initState() {
    workingDateBloc = Provider.of<WorkingDateBloc>(context, listen: false);
    workingDateStream = workingDateBloc.WorkingDateStateStream;
    getListJobsToday(null, test, test, []);

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List<WorkingDate> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  _onDayselected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  _getListDate(String? ID, String from, String to) async {
    WorkingDateProvider provider = WorkingDateProvider();
    await provider.getWorkingDate(GetWorkingDate(
        contractDetailID: ID, from: from, to: to, listWorkingDate: []));
    setState(() {
      _listDate = provider.listWorkingDate!;
    });
  }

  getListJobsToday(String? ID, String from, String to, List<WorkingDate> list) {
    workingDateBloc.send(GetWorkingDate(
        contractDetailID: ID, from: from, to: to, listWorkingDate: list));
  }

  setEventsList(String? ID, String from, String to) async {
    await _getListDate(
      ID,
      from,
      to,
    );
    for (var date in _listDate) {
      DateTime parseDate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss").parseUTC(date.workingDate!);
      if (events[parseDate] != null) {
        for (var d in events[parseDate]!) {
          if (d.id != date.id) {
            setState(() {
              events.addAll({
                parseDate: [...events[parseDate] ?? [], date]
              });
            });
          }
        }
      } else {
        setState(() {
          events.addAll({
            parseDate: [...events[parseDate] ?? [], date]
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     addEvent();
      //   },
      // ),
      body: Column(children: [
        const SizedBox(
          height: 35,
        ),
        AppBarWiget(title: 'Lịch Chăm Sóc'),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 10,
          decoration: const BoxDecoration(color: divince),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(width: size.width, height: 50, child: _listCategory()),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          child: IndexedStack(
            index: selectedTab,
            children: [
              SizedBox(height: size.height - 175, child: _listJobsToday()),
              SizedBox(
                height: size.height - 175,
                child: Column(
                  children: [
                    _calendar(),
                    _listEvents(),
                  ],
                ),
              ),
              const Text('3'),
            ],
          ),
        )
      ]),
    );
  }

  Widget _listCategory() {
    // String weekday = getWeekday(now.weekday);
    // int selectedDay = formatNumDay(weekday);
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                setState(() {
                  selectedTab = index;
                  if (index == 0) {
                    getListJobsToday(null, test, test, []);
                  } else if (index == 1) {
                    getListJobsToday(null, test, test, []);
                    var start = DateTime.utc(
                        DateTime.now().year, DateTime.now().month, 1);
                    var end = DateTime.utc(
                        DateTime.now().year,
                        DateTime.now().month,
                        ((DateTime.now().month == 2) &&
                            ((DateTime.now().year % 4) == 0))
                            ? 29
                            : ((DateTime.now().month == 2) &&
                            ((DateTime.now().year % 4) != 0))
                            ? 28
                            : ((DateTime.now().month == 4) ||
                            (DateTime.now().month == 6) ||
                            (DateTime.now().month == 9) ||
                            (DateTime.now().month == 11))
                            ? 30
                            : 31);
                    setEventsList(null, getToday(start), getToday(end));
                  }

                  // selectedTab == 1
                  //     ? selectedTabInWeek = selectedDay
                  //     : selectedTabInWeek = 0;
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                height: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: (selectedTab == index) ? buttonColor : barColor,
                    borderRadius: BorderRadius.circular(50)),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: AutoSizeText(
                  tab[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: (selectedTab == index) ? lightText : HintIcon),
                ),
              ));
        },
        itemCount: tab.length);
  }

  Widget _listJobsToday() {
    return StreamBuilder<WorkingDateState>(
      stream: workingDateStream,
      initialData: WorkingDateInitial(),
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state is WorkingDateLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ListWorkingDateSuccess) {
          List<WorkingDate> list = [...state.listWorkingDate!];
          return list.isEmpty
              ? const Center(
            child: Text('Hôm nay không có lịch chăm sóc'),
          )
              : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const ScrollPhysics(),
            itemCount: list.length,
            // itemCount: 10,
            itemBuilder: (context, index) {
              return _workingDateTab(list[index]);
            },
          );
        } else if (state is WorkingDateFailure) {
          return Text(state.errorMessage);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _workingDateTab(WorkingDate date) {
    return GestureDetector(
      onTap: () {
        showWorkingDate(date, context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(),
            gradient: tabBackground,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _rowInfo('Ngày thực hiện : ',
              getDate(date.workingDate.toString()).substring(0, 10), null),
          _rowInfo('Mã hợp đồng : ', date.contractID, null),
          _rowInfo('Tên hợp đồng : ', date.title, null),
          _rowInfo('Tên dịch vụ : ', date.serviceName, null),
          _rowInfo('Ngày làm việc trong tuần : ', date.timeWorking, null),
          _rowInfo(
              'Trạng thái : ',
              convertStatusWorkingDate(date.status.toString()),
              colorWorkingDate(date.status.toString())),
        ]),
      ),
    );
  }

  Widget _rowInfo(title, value, color) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.4,
            child: AutoSizeText(
              title.toString(),
              maxLines: 2,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          SizedBox(
              width: size.width * 0.6 - 55,
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 17, color: color),
              )),
        ],
      ),
    );
  }

  Widget _rowInfoDialog(title, value, color) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.3 - 25,
            child: AutoSizeText(
              title.toString(),
              maxLines: 2,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
              width: size.width * 0.6 - 75,
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 17, color: color),
              )),
        ],
      ),
    );
  }

  dynamic showWorkingDate(WorkingDate date, context) {
    var size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(
                child: Text(
                  'Ngày ${getDate(date.workingDate.toString()).substring(0, 10)}',
                  style: const TextStyle(color: buttonColor, fontSize: 20),
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _rowInfoDialog('Mã hợp đồng : ', date.contractID, null),
                        _rowInfoDialog('Tên hợp đồng : ', date.title, null),
                        _rowInfoDialog('Tên dịch vụ : ', date.serviceName, null),
                        _rowInfoDialog(
                            'Ngày làm việc trong tuần : ', date.timeWorking, null),
                        _rowInfoDialog(
                            'Ngày bắt đầu thực hiện : ',
                            getDate(date.startDate.toString()).substring(0, 10),
                            null),
                        _rowInfoDialog(
                            'Trạng thái : ',
                            convertStatusWorkingDate(date.status.toString()),
                            colorWorkingDate(date.status.toString())),
                        (date.startWorking != null)
                            ? Column(
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.only(bottom: 5, top: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: size.width * 0.6 - 75,
                                      child: const Text(
                                        'Hình ảnh kiểm chứng',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                ),
                                Text('Băt đầu',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                Spacer(),
                                Text('Kết thúc',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 50,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    PopupBanner(
                                      useDots: false,
                                      fit: BoxFit.fitWidth,
                                      height: size.height - 150,
                                      context: context,
                                      images: [date.startWorkingIMG ?? NoIMG],
                                      autoSlide: false,
                                      dotsAlignment: Alignment.bottomCenter,
                                      dotsColorActive: buttonColor,
                                      dotsColorInactive:
                                      Colors.grey.withOpacity(0.5),
                                      onClick: (index) {},
                                    ).show();
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                date.startWorkingIMG ??
                                                    NoIMG))),
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    PopupBanner(
                                      fit: BoxFit.fitWidth,
                                      useDots: false,
                                      height: size.height - 150,
                                      context: context,
                                      images: [date.endWorkingIMG ?? NoIMG],
                                      autoSlide: false,
                                      dotsAlignment: Alignment.bottomCenter,
                                      dotsColorActive: buttonColor,
                                      dotsColorInactive:
                                      Colors.grey.withOpacity(0.5),
                                      onClick: (index) {},
                                    ).show();
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                date.endWorkingIMG ??
                                                    NoIMG))),
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            )
                          ],
                        )
                            : const SizedBox(),
                      ],
                    )),
              ));
        });
  }

  addEvent() {
    setState(() {
      events.addAll({
        _selectedDay!: [
          ...events[_selectedDay!] ?? [],
          WorkingDate(title: 'Tesst 1', status: 'WAITING')
        ]
      });
    });
  }

  Widget _calendar() {
    return TableCalendar(
      calendarFormat: _calendarFormat,
      locale: 'VI_VN',
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: _onDayselected,
      eventLoader: _getEventsForDay,
      headerStyle:
      const HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarStyle: const CalendarStyle(
        outsideDaysVisible: false,
      ),
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
          _selectedDay!.add(Duration(days: 30));
        });
        setEventsList(
            null,
            getToday(DateTime.utc(focusedDay.year, focusedDay.month, 1)),
            getToday(DateTime.utc(
                focusedDay.year,
                focusedDay.month,
                ((focusedDay.month == 2) && ((focusedDay.year % 4) == 0))
                    ? 29
                    : ((focusedDay.month == 2) && ((focusedDay.year % 4) != 0))
                    ? 28
                    : ((focusedDay.month == 4) ||
                    (focusedDay.month == 6) ||
                    (focusedDay.month == 9) ||
                    (focusedDay.month == 11))
                    ? 30
                    : 31)));
        print('object 123');
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (BuildContext context, date, events) {
          if (events.isEmpty) return SizedBox();
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(1),
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getEventsForDay(date)[index].status == 'WAITING'
                            ? Colors.yellow
                            : Colors.green),
                  ),
                );
              });
        },
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            final text = DateFormat.E().format(day);
            return const Center(
              child: Text(
                'CN',
                style: TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _listEvents() {
    return Expanded(
      child: ValueListenableBuilder<List<WorkingDate>>(
        valueListenable: _selectedEvents,
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return _workingDateTab(value[index]);
            },
          );
        },
      ),
    );
  }
}
