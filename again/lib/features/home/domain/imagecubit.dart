import 'package:bloc/bloc.dart';
import 'package:clone/features/home/domain/image_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import

// Define states
abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final String imageUrl;

  const ImageLoaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}

// Define Cubit
class ImageCubit extends Cubit<ImageState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ImageCubit(ImageRepository instance) : super(ImageInitial());

  Future<void> fetchImage(int uid) async {
    emit(ImageLoading());
    try {
      final querySnapshot = await firestore
          .collection('users') // Adjust this to your user collection name
          .doc(uid.toString()) // Assuming UID is used as document ID
          .collection('images') // Use a sub-collection if necessary
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final imageUrl = querySnapshot.docs.first.data()['url'];
        emit(ImageLoaded(imageUrl));
      } else {
        emit(ImageError('No images found for the user'));
      }
    } catch (e) {
      emit(ImageError('Failed to load image'));
    }
  }
}
