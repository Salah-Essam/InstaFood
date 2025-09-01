import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_food/core/theme/app_assets.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/presentation/features/drawer/presentation/widgets/app_text_field_drawer.dart';
import 'package:insta_food/presentation/widgets/app_button_onb.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class AddCardPage extends StatelessWidget {
  AddCardPage({super.key});

  final TextEditingController cardHolderNameController =
      TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expireDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    cardHolderNameController.text = "John Smith";
    cardNumberController.text = "00000000000";
    expireDateController.text = "04/28";
    cvvController.text = "000";
    return SharedScaffold(
      appBarTitle: "Add Card",
      pageDetails: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  children: [
                    SvgPicture.asset(AppAssets.paymentCard),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "000 000 000 00",
                              style: AppTextStyles.fontBlackMedBold,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Card holder name",
                                      style: AppTextStyles.fontBlackSmall,
                                    ),
                                    Text(
                                      "John Smith",
                                      style: AppTextStyles.fontBlackMedBold,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Expiry date",
                                      style: AppTextStyles.fontBlackSmall,
                                    ),
                                    Text(
                                      "04/30",
                                      style: AppTextStyles.fontBlackMedBold,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Text("Card holder name", style: AppTextStyles.fontBlackLargeBold),
              AppTextFieldDrawer(
                controller: cardHolderNameController,
                onChange: (p0) {},
                maxLines: 1,
                maxLength: 30,
              ),
              SizedBox(height: 16),
              Text("Card Number", style: AppTextStyles.fontBlackLargeBold),
              AppTextFieldDrawer(
                controller: cardNumberController,
                onChange: (p0) {},
                maxLines: 1,
                maxLength: 11,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Expiry date", style: AppTextStyles.fontBlackMed),
                      SizedBox(
                        width: 100,
                        child: AppTextFieldDrawer(
                          controller: expireDateController,
                          onChange: (p0) {},
                          maxLines: 1,
                          maxLength: 5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 64),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CVV", style: AppTextStyles.fontBlackMed),
                      SizedBox(
                        width: 100,
                        child: AppTextFieldDrawer(
                          controller: cvvController,
                          onChange: (p0) {},
                          maxLines: 1,
                          maxLength: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: EdgeInsetsGeometry.only(top: 32, bottom: 32),
                  child: AppButton(
                    onPressed: () {},
                    width: 100,
                    height: 30,
                    borderRadius: 24,
                    child: Text(
                      "Save Card",
                      style: AppTextStyles.fontWhiteSmallBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
