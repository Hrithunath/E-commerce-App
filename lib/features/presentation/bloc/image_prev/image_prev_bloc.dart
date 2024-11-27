import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'image_prev_event.dart';
part 'image_prev_state.dart';

class ImagePrevBloc extends Bloc<ImagePrevEvent, ImagePrevState> {
  ImagePrevBloc() : super(ImagePrevInitial()) {
    on<ImagePrev>((event, emit) {
      emit(ImagePrevSelected(event.selectedIndex));
    });
  }
}
