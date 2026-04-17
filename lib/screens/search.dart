import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';
import '../services/db_read_service.dart';

List<String> InteresiZaPretragu = [];

List<Map<String, dynamic>> PrikazaniPostovi = [];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

    final ScrollController _scrollController = ScrollController();
    final InterestsService _interestsService = InterestsService();
    final PostsService _postsService = PostsService();

   void _searchFor(String query) {
    debugPrint('Search requested for: $query');    
    setState(() {
      PrikazaniPostovi = PrikazaniPostovi
          .where((post) => post['interests'].contains(query))
          .toList();
    });
  }

  

  Future<void> _loadAllInterests() async {
    final interests = await _interestsService.loadAllInterests();
   
    if(mounted){setState(() => InteresiZaPretragu = interests);}
  }

  Future<void> _loadPosts() async{
    final posts = await _postsService.loadPosts(InteresiZaPretragu);

    if(mounted){setState(() => PrikazaniPostovi = posts);}
  }

  @override
  void initState() {
    super.initState();
    _loadAllInterests();
    _loadPosts();

    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent - 200){
        if(_postsService.morePostsAvailable){
          _loadPosts();
        }
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search, color: AppColors.primaryBackground,));
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final String input = controller.value.text;
              final Iterable<String> matches = input.isEmpty
                  ? InteresiZaPretragu.take(100)
                  : InteresiZaPretragu.where(
                      (s) => s.toLowerCase().contains(input.toLowerCase()));

              return matches.map((String item) {
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    controller.closeView(item);
                    _searchFor(item);
                  },
                );
              }).toList();
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(16.0),
            child: Container(),
          ),
        ),

        body: SafeArea(
        top: false,
        child: Column(
          children: [      
            // Postovi
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Text(
              'Postovi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PrikazaniPostovi.isEmpty
                    ? const Center(
                        child: Text(
                          'Nema postova za odabrane interese',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: PrikazaniPostovi.length,
                        itemBuilder: (context, index) {
                          final post = PrikazaniPostovi[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 25, 36, 54),
                              borderRadius: BorderRadius.circular(16),
                              
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(post['title']??'', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text(post['description']??'', style: TextStyle(color: Colors.white70),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post['authorId']??''}', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white60)),
                                    Wrap(
                                      spacing: 6,
                                      children: (post['interests'] as List<dynamic>? ?? []).cast<String>().map((i) => Chip(
                                        label: Text(i, style: TextStyle(color: Colors.white, fontSize: 12)),
                                        backgroundColor: Color.fromARGB(255, 16, 103, 234),
                                        padding: EdgeInsets.zero,
                                      )).toList(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),

        // bottom navigation bar
        bottomNavigationBar: const SharedBottomNavigationBar(currentIndex: 1),
      );
  }
}