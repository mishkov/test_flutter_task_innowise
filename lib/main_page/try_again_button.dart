import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_task_innowise/main_page/main_page_cubit.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<MainPageCubit>().fetchForecast();
      },
      child: Text('Try again'),
    );
  }
}
