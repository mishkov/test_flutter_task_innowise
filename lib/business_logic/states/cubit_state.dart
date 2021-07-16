enum Status { none, loading, done, failed }

class CubitState<S> {
  Status status = Status.none;
  S data;
  String errorDetail = '';

  CubitState(this.data);
}
