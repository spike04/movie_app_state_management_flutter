import 'package:core/api/tmdb_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/models/app_state/movies_state.dart';
import 'package:core/ui/movies_grid.dart';
import 'package:core/ui/scrollable_movies_page_builder.dart';
import 'package:movie_app_demo_flutter_bloc/app/now_playing/movies_cubit.dart';

class NowPlayingPage extends StatelessWidget {
  static Widget create(BuildContext context) {
    return BlocProvider<MoviesCubit>(
      create: (_) => MoviesCubit(api: TMDBClient()),
      child: NowPlayingPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollableMoviesPageBuilder(
      onNextPageRequested: () {
        final moviesCubit = BlocProvider.of<MoviesCubit>(context);
        moviesCubit.fetchNextPage();
      },
      builder: (context, controller) {
        return BlocBuilder<MoviesCubit, MoviesState>(
          builder: (context, state) {
            return state.when(
              data: (movies, _) => MoviesGrid(
                movies: movies,
                controller: controller,
              ),
              dataLoading: (movies) {
                return movies.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : MoviesGrid(
                        movies: movies,
                        controller: controller,
                      );
              },
              error: (error) => Center(child: Text(error)),
            );
          },
        );
      },
    );
  }
}