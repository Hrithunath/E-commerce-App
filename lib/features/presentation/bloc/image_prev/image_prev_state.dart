part of 'image_prev_bloc.dart';

@immutable
sealed class ImagePrevState {}

final class ImagePrevInitial extends ImagePrevState {}

class ImagePrevSelected extends ImagePrevState {
  final int selectedIndex;

  ImagePrevSelected(this.selectedIndex);
}
