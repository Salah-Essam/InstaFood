import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/presentation/features/PaymentMethods/data/models/payment_model.dart';

class PaymentRepository {
  static List<PaymentModel> getPaymentRepo() {
    return [
      PaymentModel(
        id: 0,
        title: "*** *** *** 43",
        icon: AppAssets.paymentCardIcon,
      ),
      PaymentModel(
        id: 1,
        title: "apple play",
        icon: AppAssets.paymentGooglePlay,
      ),
      PaymentModel(id: 2, title: "paypal", icon: AppAssets.paymentMac),
      PaymentModel(id: 3, title: "Paypal", icon: AppAssets.paymentPaypal),
    ];
  }
}
