import 'package:control_timer_app/configs/helpers/helpers.dart';
import 'package:control_timer_app/presentation/providers/home_provider.dart';
import 'package:control_timer_app/presentation/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(timeProvider);
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          const _HeaderView(),
          const _TimeTextView(),
          SizedBox(height: (state.status == TimeStatus.none) ? 260 : 16),
          const _TimeButtonView(),
          (state.status == TimeStatus.none)
              ? Container()
              : (state.status == TimeStatus.pausa)
                  ? const _FormularioPausaView()
                  : const _ListRegisterTimesView(),
          // (state.status == TimeStatus.pausa)
          //     ? const _FormularioPausaView()
          //     : const _ListRegisterTimesView(),
        ],
      ),
    );
  }
}

class _HeaderView extends ConsumerWidget {
  const _HeaderView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(timeProvider);
    var state2 = ref.watch(pauseProvider);

    final color = Theme.of(context).colorScheme;
    TextStyle style = TextStyle(color: color.onSurface, fontSize: 32);

    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(state.getDateInitInText, style: style),
              const Text('START TIME'),
            ],
          ),
          Column(
            children: [
              Text(state.status.name, style: style),
              const Text('STATUS'),
            ],
          ),
          Column(
            children: [
              Text(state2.messages.length.toString(), style: style),
              const Text('AMOUNT'),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormularioPausaView extends ConsumerWidget {
  const _FormularioPausaView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Column(
              children: [
                CustomInputTextAreaWidget(
                  prefixIcon: const Icon(Icons.telegram),
                  label: 'Mensaje',
                  onChanged: (value) {
                    ref
                        .read(pauseProvider.notifier)
                        .updateState(message: value);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ListRegisterTimesView extends ConsumerWidget {
  const _ListRegisterTimesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    var status = ref.watch(pauseProvider);

    List<MessageEntity> list = status.messages;
    if (list.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text('0 Elements in the list'),
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (_, i) {
          MessageEntity messageEntity = list[i];
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.primaryContainer,
            ),
            child: Material(
              color: Colors.transparent,
              child: ListTile(
                leading: const Icon(Icons.flag_rounded),
                title: Text(messageEntity.message),
                subtitle: Text('time: ${messageEntity.time}'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TimeButtonView extends ConsumerWidget {
  const _TimeButtonView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(timeProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (state.status == TimeStatus.none || state.status == TimeStatus.pausa)
            ? IconButton.filled(
                icon: const Icon(Icons.play_arrow_rounded, size: 80),
                onPressed: () {
                  ref.read(timeProvider.notifier).startTimer();
                  ref.read(pauseProvider.notifier).addTimeToListPause();
                },
              )
            : IconButton.filled(
                icon: const Icon(Icons.pause_rounded, size: 80),
                onPressed: () {
                  ref.read(timeProvider.notifier).pauseTimer();
                  ref.read(pauseProvider.notifier).startPause();
                },
              ),
        if (state.status != TimeStatus.none)
          IconButton.filled(
            icon: const Icon(Icons.stop_rounded, size: 80),
            onPressed: () async {
              ref.read(timeProvider.notifier).timer?.cancel();
              ref.invalidate(timeProvider);
              ref.invalidate(pauseProvider);
            },
          ),
      ],
    );
  }
}

class _TimeTextView extends ConsumerWidget {
  const _TimeTextView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).colorScheme;
    TextStyle style = TextStyle(color: color.onSurface, fontSize: 48);
    var state = ref.watch(timeProvider);
    var seconds = state.duration.inSeconds.remainder(60);
    var minutes = state.duration.inMinutes.remainder(60);
    var hours = state.duration.inHours;

    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimeTextBoxWidget(text: twoDigits(hours)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: style),
          ),
          TimeTextBoxWidget(text: twoDigits(minutes)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: style),
          ),
          TimeTextBoxWidget(text: twoDigits(seconds)),
        ],
      ),
    );
  }
}

class TimeTextBoxWidget extends StatelessWidget {
  final String text;
  const TimeTextBoxWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    TextStyle style = TextStyle(color: color.onSurface, fontSize: 48);

    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(text, style: style),
      ),
    );
  }
}
