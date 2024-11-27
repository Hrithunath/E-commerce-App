part of 'image_prev_bloc.dart';

@immutable
sealed class ImagePrevEvent {}

class ImagePrev extends ImagePrevEvent {
  final int selectedIndex;

  ImagePrev(this.selectedIndex);
}
