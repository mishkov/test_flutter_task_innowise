import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../business_logic/cubits/five_day_forecast_formatted_cubit.dart';

class TryAgainButton extends StatelessWidget {
  const TryAgainButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<FiveDayForecastFormattedCubit>().tryAgain();
      },
      child: Text('Try again'),
    );
  }
}
