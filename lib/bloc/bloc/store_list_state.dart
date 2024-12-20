part of 'store_list_bloc.dart';

final class StoreListInitialState extends Equatable {
  final List<Data> storeDate;
  final String errorMessage;

  const StoreListInitialState({
    this.storeDate = const [],
    this.errorMessage = '',
  });

  StoreListInitialState copyWith({
    List<Data>? storeData,
    String? errorMessage,
  }) {
    return StoreListInitialState(
      storeDate: storeData ?? this.storeDate,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        storeDate,
        errorMessage,
      ];
}
