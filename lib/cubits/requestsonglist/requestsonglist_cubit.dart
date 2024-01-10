import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:radiounicorn/models/requestsongdata.dart';
part 'requestsonglist_state.dart';

class RequestsonglistCubit extends Cubit<RequestsonglistState> {
  RequestsonglistCubit() : super(RequestsonglistState.initial()) {}

  emitNewList(List<RequestSongData> newList) {
    emit(state.copyWith(list: newList));
  }
}
