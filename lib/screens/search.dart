import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';
import '../services/db_read_service.dart';

List<String> InteresiZaPretragu = [];

List<Map<String, dynamic>> PrikazaniPostovi = [];
List<Map<String, dynamic>> Postovi = [];

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
      if(query == ''){
        PrikazaniPostovi = Postovi;
        return;
      }
      PrikazaniPostovi = Postovi
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
    if(mounted){setState(() => PrikazaniPostovi = posts); setState(() => Postovi = posts);}
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
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          backgroundColor: AppColors.secondary,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: SearchAnchor(
            viewBackgroundColor: AppColors.secondary,
            viewSurfaceTintColor: Colors.transparent,
            headerTextStyle: TextStyle(color: AppColors.textColor),
            headerHintStyle: TextStyle(color: AppColors.textColorOpis),
            builder: (context, controller) {
               return SearchBar(
                controller: controller,
                textInputAction: TextInputAction.search,
               onTap: () {
                 controller.value = const TextEditingValue(text: '');
                 controller.openView();
               },
               onChanged: (_) => controller.openView(),
                onSubmitted: (value) {
                  controller.closeView(value);
                  _searchFor(value);
                },
                backgroundColor: WidgetStatePropertyAll(AppColors.selectButtonColor),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                leading: const Icon(Icons.search, color: AppColors.textColorOpis),
                hintText: 'Search...',
                hintStyle: WidgetStatePropertyAll(TextStyle(color: AppColors.textColorOpis)),
                textStyle: WidgetStatePropertyAll(TextStyle(color: AppColors.textColor)),
              );
            },
            suggestionsBuilder:
            (BuildContext context, SearchController controller) {
              final String input = controller.value.text;
              final Iterable<String> matches = input.isEmpty
                  ? InteresiZaPretragu.take(100)
                  : InteresiZaPretragu.where(
                          (s) => s.toLowerCase().contains(input.toLowerCase()));
              final List<Widget> tiles = [];
                tiles.add(Container(
                  color: AppColors.secondary,
                  child: ListTile(
                    title: Text('Show all', style: TextStyle(color: AppColors.textColor)),
                    onTap: () {
                      controller.closeView('Show all');
                      _searchFor(input);
                    },
                  ),
                ));
              tiles.addAll(matches.map((String item) {
                return Container(
                  color: AppColors.secondary,
                  child: ListTile(
                    title: Text(item, style: TextStyle(color: AppColors.textColor)),
                    onTap: () {
                      controller.closeView(item);
                      _searchFor(item);
                    },
                  ),
                );
              }).toList());

              return tiles;
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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Results', style: TextStyle(
                color: AppColors.textColorOpis,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PrikazaniPostovi.isEmpty
                    ? const Center(
                        child: Text(
                          'No posts for selected interests',
                          style: TextStyle(color: AppColors.textColorOpis)
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
                                
                                Text(post['title']??'', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                const SizedBox(height: 6),
                                Text(post['description']??'', style: TextStyle(color: Colors.white70),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post['authorId']??''}', style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textColorOpis)),
                                    Wrap(
                                      spacing: 6,
                                      children: (post['interests'] as List<dynamic>? ?? []).cast<String>().map((i) => Chip(
                                        label: Text(i, style: TextStyle(color: AppColors.textColor, fontSize: 12)),
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