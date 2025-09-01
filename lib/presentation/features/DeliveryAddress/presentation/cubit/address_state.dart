part of 'address_cubit.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoaded extends AddressState {
  final List<AddressModel> addresses;
  final int selectedId;

  AddressLoaded({required this.addresses, required this.selectedId});

  AddressLoaded copyWith({List<AddressModel>? addresses, int? selectedId}) {
    return AddressLoaded(
      addresses: addresses ?? this.addresses,
      selectedId: selectedId ?? this.selectedId,
    );
  }
}
