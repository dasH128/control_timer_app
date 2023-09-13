import 'dart:async';

import 'package:control_timer_app/configs/helpers/helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timeProvider = StateNotifierProvider<TimeNotifier, TimeState>(
  (ref) => TimeNotifier(),
);

class TimeNotifier extends StateNotifier<TimeState> {
  Timer? timer;
  TimeNotifier() : super(TimeState(listTime: [], dateInit: DateTime.now()));

  startTimer() {
    if (state.status == TimeStatus.none || state.status == TimeStatus.pausa) {
      state = state.copyWith(status: TimeStatus.start);

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        addTime();
      });
    }
  }

  addTime() {
    var newTime = state.time + 1;
    state = state.copyWith(time: newTime, duration: Duration(seconds: newTime));
  }

  pauseTimer() {
    state = state.copyWith(status: TimeStatus.pausa);
    timer?.cancel();
  }
}

class TimeState {
  final DateTime dateInit;
  final DateTime? dateInitPause;
  final List<String> listTime;
  final Duration duration;
  final int time;
  final TimeStatus status;

  TimeState({
    required this.dateInit,
    this.dateInitPause,
    required this.listTime,
    this.duration = const Duration(seconds: 0),
    this.time = 0,
    this.status = TimeStatus.none,
  });

  TimeState copyWith({
    DateTime? dateInitPause,
    List<String>? listTime,
    int? time,
    Duration? duration,
    TimeStatus? status,
  }) {
    return TimeState(
      dateInit: dateInit,
      dateInitPause: dateInitPause ?? this.dateInitPause,
      listTime: listTime ?? this.listTime,
      duration: duration ?? this.duration,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }

  String get getDateInitInText {
    var minute = twoDigits(dateInit.minute);
    var hour = twoDigits(dateInit.hour);
    var symbol = (dateInit.hour >= 12) ? 'PM' : 'AM';
    return '$hour:$minute $symbol';
  }
}

enum TimeStatus {
  none,
  start,
  pausa,
  fin,
}

final pauseProvider =
    StateNotifierProvider.autoDispose<PauseNotifier, PauseState>(
  (ref) => PauseNotifier(),
);

class PauseNotifier extends StateNotifier<PauseState> {
  PauseNotifier() : super(PauseState(messages: []));

  addTimeToListPause() {
    if (state.dateInitPause == null) return;

    var dateEndPause = DateTime.now();
    var dif = dateEndPause.difference(state.dateInitPause!);
    var newMessage = MessageEntity(
      time: dif.toString(),
      message: state.message,
    );
    var newMessages = [...state.messages, newMessage];
    updateState(messages: newMessages);
  }

  startPause() {
    updateState(dateInitPause: DateTime.now(), message: '');
  }

  updateState({
    String? message,
    List<MessageEntity>? messages,
    DateTime? dateInitPause,
  }) {
    state = state.copyWith(
      message: message,
      messages: messages,
      dateInitPause: dateInitPause,
    );
  }
}

class PauseState {
  final String message;
  final DateTime? dateInitPause;
  final List<MessageEntity> messages;

  PauseState({
    this.message = '',
    this.dateInitPause,
    required this.messages,
  });

  PauseState copyWith({
    String? message,
    DateTime? dateInitPause,
    List<MessageEntity>? messages,
  }) {
    return PauseState(
      message: message ?? this.message,
      dateInitPause: dateInitPause ?? this.dateInitPause,
      messages: messages ?? this.messages,
    );
  }
}

class MessageEntity {
  final String time;
  final String message;

  MessageEntity({
    required this.time,
    required this.message,
  });
}
