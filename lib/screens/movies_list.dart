import 'package:flutter/material.dart';
import 'package:mitt_arv_assignment/model/movie.dart';

class MoviesList extends StatelessWidget {
  final List<Movie>? movies;

  MoviesList(this.movies);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Background color
      child: movies != null && movies!.isNotEmpty
          ? Center(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: movies!.length,
                  itemBuilder: (ctx, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: movies![index].posterPath != null
                            ? Image.network(
                                "https://image.tmdb.org/t/p/w92${movies![index].posterPath}",
                                width: 50,
                                height: 75,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.movie),
                        title: Text(
                          movies![index].name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Year: ${movies![index].year}, Rating: ${movies![index].rating}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : Center(
              child: Text("No movies found"),
            ),
    );
  }
}
