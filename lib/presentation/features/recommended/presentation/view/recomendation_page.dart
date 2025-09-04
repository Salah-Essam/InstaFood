import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_food/core/di/di.dart';
import 'package:insta_food/core/theme/app_text_styles.dart';
import 'package:insta_food/core/utils/app_strings.dart';
import 'package:insta_food/presentation/features/recommended/presentation/cubit/recommendations_cubit.dart';
import 'package:insta_food/presentation/features/recommended/presentation/widget/recommends_tile.dart';
import 'package:insta_food/presentation/features/recommended/presentation/widget/thumbnail.dart';
import 'package:insta_food/presentation/widgets/app_backbutton.dart';
import 'package:insta_food/presentation/widgets/shared_scaffold.dart';

class RecommendationPage extends StatelessWidget {
  const RecommendationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      appBarTitle: AppStrings.recommendations,
      leading: AppBackButton(onTap: () => Navigator.pop(context)),
      pageDetails: BlocProvider(
        create: (context) => sl<RecommendationsCubit>()..loadRecommendations(),
        child: BlocBuilder<RecommendationsCubit, RecommendationsState>(
          builder: (context, state) {
            if (state is RecommendationsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RecommendationsFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RecommendationsLoaded) {
              return Center(
                child: ListView(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        children: [
                          Text(
                            AppStrings.discover,
                            style: AppTextStyles.fontPrimaryHeaderRagular,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            AppStrings.byChef,
                            style: AppTextStyles.fontPrimaryHeaderRagular,
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Thumbnail(item: state.thumbnailItem),
                    SizedBox(height: 27),
                    Center(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                        itemCount: state.recommendations.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        itemBuilder: (context, index) {
                          return RecommendsTile(
                            item: state.recommendations[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
