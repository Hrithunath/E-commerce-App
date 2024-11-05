part of 'search_bloc.dart';

class SearchProductEvent {}

class SearchByProductEvent extends SearchProductEvent {
  String query;
  SearchByProductEvent({required this.query});
}
