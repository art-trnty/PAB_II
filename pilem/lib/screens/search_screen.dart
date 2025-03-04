import 'package:flutter/material.dart';
import 'package:pilem/models/movie.dart';
import 'package:pilem/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _searchResults = [];

  @override
  void intiState(){
    super.initState();
    _searchController.addListener(_searchMovie);
  }

  @override
  void dispose(){
    super.dispose();
    _searchController.dispose();
  }

  void _searchMovie() async {
    if(_searchController.text.isEmpty){
      setState(() {
        _searchController.clear();
      });
      return;
    }
    final List<Map<String, dynamic>> _searchData =
    await _apiService.searchMovies(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Movies...",
                      border: InputBorder.none,
                    ),
                  ),),
                  Visibility(
                    visible: _searchController.text.isNotEmpty,
                    child: IconButton(
                      onPressed: (){
                        _searchController.clear();
                        setState(() {
                          _searchResults.clear();
                        });
                      },
                      icon: Icon(Icons.clear),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context,index){
                        final Movie movie = _searchResults[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Image.network('https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(movie.title),
                            onTap: (){},
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
