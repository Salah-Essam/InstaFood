import 'package:insta_food/presentation/features/DeliveryAddress/data/models/address_model.dart';

class AddressRepository {
  static List<AddressModel> getAddresses() {
    return [
      AddressModel(
        id: 0,
        title: "My Home",
        subtitle: "778 Locust View Drive Oakland, CA",
      ),
      AddressModel(
        id: 1,
        title: "My Office",
        subtitle: "123 Business Center, Oakland, CA",
      ),
      AddressModel(
        id: 2,
        title: "Parent's House",
        subtitle: "45 Green Street, Oakland, CA",
      ),
    ];
  }
}
