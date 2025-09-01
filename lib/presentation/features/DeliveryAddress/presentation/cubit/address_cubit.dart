import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/presentation/features/DeliveryAddress/data/models/address_model.dart';
import 'package:insta_food/presentation/features/DeliveryAddress/data/repositories/address_repo.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial()) {
    loadAddresses();
  }

  void loadAddresses() {
    final addresses = AddressRepository.getAddresses();
    emit(AddressLoaded(addresses: addresses, selectedId: addresses.first.id));
  }

  void selectAddress(int id) {
    if (state is AddressLoaded) {
      final currentState = state as AddressLoaded;
      emit(currentState.copyWith(selectedId: id));
    }
  }
}
