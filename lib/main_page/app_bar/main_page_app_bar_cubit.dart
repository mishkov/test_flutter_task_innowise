import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageAppBarCubit extends Cubit<MainPageAppBarCubitState> {
  MainPageAppBarCubit() : super(MainPageAppBarCubitState.inittialState());
}

class MainPageAppBarCubitState {
  String title;

  MainPageAppBarCubitState(this.title);

  MainPageAppBarCubitState.inittialState() : title = 'Unknown';
}
