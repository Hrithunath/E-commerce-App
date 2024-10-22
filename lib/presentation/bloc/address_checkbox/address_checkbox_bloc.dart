import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'address_checkbox_event.dart';
part 'address_checkbox_state.dart';

class AddressCheckboxBloc extends Bloc<AddressCheckboxEvent, AddressCheckBoxState> {
  AddressCheckboxBloc() : super(AddressCheckBoxState()) {
    on<ToggleAddressCheckbox>((event, emit) {
      // If the selected address is the same as the current, deselect it
      if (state.selectedDocumentId == event.documentId) {
        emit(AddressCheckBoxState(selectedDocumentId: null)); // Deselect the address
      } else {
        emit(AddressCheckBoxState(selectedDocumentId: event.documentId)); // Select the new address
      }
    });
  }
}