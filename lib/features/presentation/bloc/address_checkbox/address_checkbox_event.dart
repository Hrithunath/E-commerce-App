part of 'address_checkbox_bloc.dart';

@immutable
sealed class AddressCheckboxEvent {}

class ToggleAddressCheckbox extends AddressCheckboxEvent {
  final String? documentId;

  ToggleAddressCheckbox({this.documentId});
}