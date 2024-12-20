import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:search_map_location/model/list_of_stores_model.dart';
import 'package:search_map_location/src/api_call.dart';

part 'store_list_event.dart';
part 'store_list_state.dart';

class StoreListBloc extends Bloc<StoreListEvent, StoreListInitialState> {
  StoreListBloc() : super(const StoreListInitialState()) {
    on<LoadStoresListEvent>(loadStoresListEvent);
  }

  FutureOr<void> loadStoresListEvent(
      LoadStoresListEvent event, Emitter<StoreListInitialState> emit) async {
    final List<Data> storeListData = await FetchStoresList().fetchStoreData();
    emit(StoreListInitialState(storeDate: storeListData));
  }
}
