import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'volume_state.dart';

class VolumeCubit extends Cubit<VolumeState> {
  VolumeCubit() : super(VolumeState.initial());

  setNewVolume(double newVolume) {
    emit(state.copyWith(volume: newVolume));
  }
}
