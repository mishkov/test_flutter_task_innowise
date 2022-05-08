import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_page_app_bar_cubit.dart';

class MainPageAppBar extends AppBar {
  MainPageAppBar() : super(
          title: BlocProvider(
            create: (_) => MainPageAppBarCubit(),
            child: BlocBuilder<MainPageAppBarCubit, MainPageAppBarCubitState>(
              builder: (_, state) => Text(state.title),
            ),
          ),
        );
}