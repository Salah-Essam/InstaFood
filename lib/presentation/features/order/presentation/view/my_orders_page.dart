import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_food/core/routes/router_constants.dart';
import 'package:insta_food/core/theme/app_colors.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/order/data/models/order_model.dart';
import 'package:insta_food/presentation/features/order/logic/orders_cubit.dart';
import 'package:insta_food/presentation/features/order/presentation/view/leave_review_page.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  int _selected = 0; // 0 active, 1 completed, 2 cancelled

  @override
  void initState() { super.initState(); }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: AppStrings.myOrders,
      pageDetails: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          final lists = [state.active, state.completed, state.cancelled];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Chips(selected: _selected, onChanged: (i) => setState(() => _selected = i)),
              const SizedBox(height: 8),
              Expanded(
                child: _OrdersList(
                  orders: lists[_selected],
                  emptyText: _selected == 0
                      ? 'No active orders'
                      : _selected == 1
                          ? 'No completed orders'
                          : 'No cancelled orders',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Chips extends StatelessWidget {
  const _Chips({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    // Figma specs: target width 104, height 28. Use LayoutBuilder so all 3 chips fit without overflow.
    Widget chip(String text, bool isSelected, VoidCallback onTap, double width) {
      return SizedBox(
        width: width,
        height: 28,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(38),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryOrange : AppColors.orange2,
              borderRadius: BorderRadius.circular(38),
              border: Border.all(
                color: isSelected ? AppColors.primaryOrange : AppColors.border,
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsetsDirectional.only(start: 12, end: 12, top: 2),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.mediumText.copyWith(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.primaryOrange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        // Try to fit 3 chips and 2 gaps into available width
        final per = ((constraints.maxWidth - (2 * gap)) / 3).clamp(84.0, 104.0);
        return Row(
          children: [
            chip('Active', selected == 0, () => onChanged(0), per),
            const SizedBox(width: gap),
            chip('Completed', selected == 1, () => onChanged(1), per),
            const SizedBox(width: gap),
            chip('Cancelled', selected == 2, () => onChanged(2), per),
          ],
        );
      },
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders, required this.emptyText});
  final List<OrderModel> orders;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return ListView.separated(
      padding: const EdgeInsets.only(top: 4),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(height: 24, color: Color(0x1A000000)),
      itemBuilder: (context, i) {
        final o = orders[i];
        final first = o.items.isNotEmpty ? o.items.first : null;
        final dt = o.createdAt ?? o.updatedAt;
        final date = dt == null ? '' : DateFormat('MMM d, h:mm a').format(dt);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: first == null || first.imageUrl.isEmpty
                  ? Container(width: 58, height: 58, color: AppColors.orange2)
                  : Image.network(first.imageUrl, width: 58, height: 58, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          first?.itemName ?? 'Order ${o.id.substring(0, 6)}',
                          style: AppTextStyles.mediumText.copyWith(color: Colors.black, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${o.total.toStringAsFixed(2)}',
                        style: AppTextStyles.mediumText.copyWith(color: AppColors.primaryOrange, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(date, style: AppTextStyles.mediumText.copyWith(color: Colors.black54, fontSize: 12)),
                      const Spacer(),
                      Text('${o.items.length} ${o.items.length == 1 ? 'item' : 'items'}',
                          style: AppTextStyles.mediumText.copyWith(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                  if (o.isCompleted) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/right.svg',
                          width: 16, height: 16,
                          colorFilter: ColorFilter.mode(Colors.green.shade600, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 6),
                        Text('Order delivered', style: AppTextStyles.mediumText.copyWith(color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ] else if (o.isCancelled) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/cancle.svg',
                          width: 16, height: 16,
                          colorFilter: ColorFilter.mode(Colors.red.shade600, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 6),
                        Text('Order cancelled', style: AppTextStyles.mediumText.copyWith(color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  _ActionRow(order: o),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();
    final btnStyle = OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.primaryOrange),
      foregroundColor: AppColors.primaryOrange,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      minimumSize: const Size(0, 28),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      textStyle: AppTextStyles.mediumText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
    );

    if (order.isActive) {
  return Wrap(spacing: 12, runSpacing: 8, children: [
        OutlinedButton(
          style: btnStyle,
          onPressed: () => cubit.cancel(order.id),
          child: const Text('Cancel Order'),
        ),
    TextButton(
          onPressed: () { context.push(RouterConstants.deliveryTime); },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    minimumSize: const Size(0, 28),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    textStyle: AppTextStyles.mediumText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          child: const Text('Track Driver'),
        ),
  ]);
    } else if (order.isCompleted) {
      return Wrap(spacing: 12, runSpacing: 8, children: [
        OutlinedButton(
          style: btnStyle,
          onPressed: () {
            final first = order.items.isNotEmpty ? order.items.first : null;
            if (first == null) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LeaveReviewPage(orderId: order.id, item: first),
              ),
            );
          },
          child: const Text('Leave a review'),
        ),
    TextButton(
          onPressed: () {/* TODO: order again */},
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryOrange,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    minimumSize: const Size(0, 28),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    textStyle: AppTextStyles.mediumText.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          child: const Text('Order Again'),
        ),
  ]);
    } else {
      return const SizedBox.shrink();
    }
  }
}
