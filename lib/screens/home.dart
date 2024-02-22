import 'package:bilheteria_panucci/logic/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:bilheteria_panucci/components/classification.dart';
import 'package:bilheteria_panucci/components/home/genre_filter.dart';
import 'package:bilheteria_panucci/components/movie_card.dart';
import 'package:bilheteria_panucci/models/movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeCubit homeCubit = HomeCubit();

  @override
  void initState() {
    homeCubit.getMovies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Text(
                  "Filmes",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const GenreFilter(),
              BlocBuilder<HomeCubit, HomeStates>(
                bloc: homeCubit,
                builder: (context, state) {
                  print(state);
                  if (state is HomeLoading) {
                    return const SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (state is HomeSuccess) {
                    return SliverGrid.builder(
                      itemCount: state.movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisExtent: 320,
                      ),
                      itemBuilder: (context, index) {
                        return MovieCard(movie: state.movies[index]);
                      },
                    );
                  } else if (state is HomeError) {
                    return SliverFillRemaining(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.not_interested, size: 30),
                          const SizedBox(height: 16),
                          Text(state.error)
                        ],
                      ),
                    );
                  }
                  return SliverToBoxAdapter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
