import 'package:flutter/material.dart';
import 'package:mitt_arv_assignment/screens/login_page.dart';
import 'package:mitt_arv_assignment/screens/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mitt_arv_assignment/api/movie_service.dart';
import 'package:mitt_arv_assignment/model/movie.dart';
import 'package:mitt_arv_assignment/screens/movies_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Top Rated Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register', 
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MovieScreen(),
      },
    );
  }
}

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  final String _apiKey = "95515296317d900f7ed06b90323487e8"; 
  List<Movie> _movies = []; 
  int _page = 1;
  bool _isLoading = false;
  bool _isFetching = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTopRatedMovies();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    
    print(_searchController.text);
    
  }

  Future<void> _fetchTopRatedMovies() async {
    setState(() {
      _isFetching = true;
    });

    try {
      final List<Movie> fetchedMovies = await MovieService.fetchTopRatedMovies(_apiKey, _page);
      setState(() {
        _isFetching = false;
        _movies.addAll(fetchedMovies);
        _page++;
      });
    } catch (error) {
      setState(() {
        _isFetching = false;
      });
      print(error);
    }
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (notification.metrics.pixels >= notification.metrics.maxScrollExtent && !_isFetching) {
        _fetchTopRatedMovies();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
        backgroundColor: const Color.fromARGB(255, 211, 154, 154),
      ),
      body: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : NotificationListener<ScrollNotification>(
                    onNotification: _onScrollNotification,
                    child: Stack(
                      children: [
                        if (_movies != null && _movies.isNotEmpty) // Check if _movies is not null or empty
                          MoviesList(_movies.take(5).toList()),
                        if (_isFetching)
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
