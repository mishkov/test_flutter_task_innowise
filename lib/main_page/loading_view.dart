import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: CircularProgressIndicator.adaptive(),
        ),
        Text(
          'Loading...',
        ),
      ],
    );
  }
}
