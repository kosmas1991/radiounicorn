part of 'volume_cubit.dart';

class VolumeState extends Equatable {
  final double volume;

  VolumeState({required this.volume});

  factory VolumeState.initial() {
    return VolumeState(volume: 0.75);
  }

  @override
  List<Object> get props => [volume];

  VolumeState copyWith({
    double? volume,
  }) {
    return VolumeState(
      volume: volume ?? this.volume,
    );
  }

  @override
  bool get stringify => true;
}
