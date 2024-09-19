import 'package:equatable/equatable.dart';

// Image states
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final List<String> downloadUrls;

  const ImageLoaded(this.downloadUrls);
}

class ImageFailure extends ImageState {
  final String error;

  const ImageFailure(this.error);

  @override
  List<Object> get props => [error];
}
