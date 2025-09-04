import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/order/data/models/order_item_model.dart';
import 'package:insta_food/presentation/features/order/logic/leave_review_cubit.dart';
import 'package:insta_food/presentation/features/order/data/repos/orders_repository.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/presentation/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class LeaveReviewPage extends StatefulWidget {
  const LeaveReviewPage({super.key, required this.orderId, required this.item});
  final String orderId;
  final OrderItemModel item;

  @override
  State<LeaveReviewPage> createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveReviewCubit(
        repo: sl<OrdersRepository>(),
        auth: context.read<AuthCubit>(),
      ),
      child: SharedScaffold(
        appBarTitle: AppStrings.leaveAReviewTitle,
        pageDetails: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              _ProductImage(url: widget.item.imageUrl),
              const SizedBox(height: 12),
              _ProductName(name: widget.item.itemName),
              const SizedBox(height: 16),
              _Intro(),
              const SizedBox(height: 16),
              _Stars(),
              const SizedBox(height: 16),
              _CommentPrompt(),
              const SizedBox(height: 12),
              _CommentBox(controller: _controller),
              const SizedBox(height: 16),
              _Buttons(
                orderId: widget.orderId,
                itemId: widget.item.itemId,
                controller: _controller,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ================== Small reusable widgets ==================
class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: url.isEmpty
          ? Container(width: 157, height: 157, color: AppColors.lightYellow)
          : Image.network(url, width: 157, height: 157, fit: BoxFit.cover),
    );
  }
}

class _ProductName extends StatelessWidget {
  const _ProductName({required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 149,
      child: Text(
        name,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.mediumText.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textDarkBrown,
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 317,
      child: Text(
        AppStrings.reviewIntro,
        textAlign: TextAlign.center,
        style: AppTextStyles.small.copyWith(color: AppColors.textDarkBrown),
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LeaveReviewCubit>();
    return BlocBuilder<LeaveReviewCubit, LeaveReviewState>(
      buildWhen: (p, n) => p.rating != n.rating,
      builder: (context, state) {
        return SizedBox(
          width: 317,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final idx = i + 1;
              final selected = idx <= state.rating;
              return Padding(
                padding: EdgeInsets.only(right: i == 4 ? 0 : 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22.5),
                  onTap: () => cubit.setRating(idx),
                  child: SizedBox(
                    width: 33.75,
                    height: 36,
                    child: SvgPicture.asset(
                      'assets/icons/bot-star.svg',
                      colorFilter: ColorFilter.mode(
                        selected
                            ? AppColors.primaryOrange
                            : AppColors.primaryOrange.withAlpha(102),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _CommentPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 317,
      child: Text(
        AppStrings.leaveUsComment,
        textAlign: TextAlign.center,
        style: AppTextStyles.small.copyWith(color: AppColors.textDarkBrown),
      ),
    );
  }
}

class _CommentBox extends StatelessWidget {
  const _CommentBox({required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 323, minHeight: 95),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.lightYellow,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: TextField(
            controller: controller,
            maxLines: 5,
            minLines: 3,
            onChanged: (v) => context.read<LeaveReviewCubit>().setComment(v),
            decoration: const InputDecoration(
              hintText: 'Write Review…',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  const _Buttons({
    required this.orderId,
    required this.itemId,
    required this.controller,
  });
  final String orderId;
  final String itemId;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaveReviewCubit, LeaveReviewState>(
      listenWhen: (p, n) => p.submitted != n.submitted || p.error != n.error,
      listener: (context, state) {
        if (state.submitted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogCtx) => AlertDialog(
              title: const Text('Thank you!'),
              content: const Text('Your review has been submitted.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog first, then route to the main screen to avoid blank overlays.
                    Navigator.of(dialogCtx).pop();
                    // Pop this page and return success to the caller (My Orders tab retains its stack).
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        if (state.error == 'rating_required') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a rating.')),
          );
        } else if (state.error == 'submit_failed') {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Something went wrong'),
              content: const Text(
                'Could not submit your review. Please try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: 323,
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryOrange,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size(0, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.21),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10.57,
                    ),
                    textStyle: AppTextStyles.mediumText.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => context.pop(),
                  child: Text(AppStrings.cancel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.21),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10.57,
                    ),
                    textStyle: AppTextStyles.mediumText.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onPressed: state.isSubmitting
                      ? null
                      : () async {
                          await context.read<LeaveReviewCubit>().submit(
                            orderId: orderId,
                            itemId: itemId,
                          );
                        },
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
