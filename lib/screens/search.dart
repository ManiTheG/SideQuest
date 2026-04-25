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
      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200){
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
          toolbarHeight: 130,
          title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explore', style: TextStyle(
              color: AppColors.textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 8),
          SearchAnchor(
            viewBackgroundColor: AppColors.secondary,
            viewSurfaceTintColor: Colors.transparent,
            headerTextStyle: TextStyle(color: AppColors.textColor),
            headerHintStyle: TextStyle(color: AppColors.textColorOpis),
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                onTap: () => controller.openView(),
                onChanged: (_) => controller.openView(),
                backgroundColor: WidgetStatePropertyAll(AppColors.selectButtonColor),
                shadowColor: WidgetStatePropertyAll(Colors.transparent),
                leading: const Icon(Icons.search, color: AppColors.textColorOpis),
                hintText: 'Search...',
                hintStyle: WidgetStatePropertyAll(TextStyle(color: AppColors.textColorOpis)),
                textStyle: WidgetStatePropertyAll(TextStyle(color: AppColors.textColor)),
              );
            },
            suggestionsBuilder: (context, controller) {
            final String input = controller.value.text;
            final Iterable<String> matches = input.isEmpty
                ? InteresiZaPretragu.take(100)
                : InteresiZaPretragu.where(
                    (s) => s.toLowerCase().contains(input.toLowerCase()));

            return matches.map((String item) {
              final int matchIndex = item.toLowerCase().indexOf(input.toLowerCase());
              
              return Column(
                children: [
                  Container(
                    color: AppColors.secondary,
                    child: ListTile(
                      leading: Container(
                        width: 6,
                        height: 6,
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          shape: BoxShape.circle,
                          ),
                        ),
                      minLeadingWidth: 6,
                      title: matchIndex < 0 || input.isEmpty
                          ? Text(item, style: TextStyle(color: AppColors.textColor))
                          : RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: item.substring(0, matchIndex),
                                    style: TextStyle(color: AppColors.textColorOpis),
                                  ),
                                  TextSpan(
                                    text: item.substring(matchIndex, matchIndex + input.length),
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item.substring(matchIndex + input.length),
                                    style: TextStyle(color: AppColors.textColorOpis),
                                  ),
                                ],
                              ),
                            ),
                      onTap: () {
                        controller.closeView(item);
                        _searchFor(item);
                      },
                    ),
                  ),
                  Divider(height: 1, thickness: 0.5, 
                    color: AppColors.textColorOpis.withValues(alpha: 0.2),
                    indent: 16, endIndent: 16),
                ],
              );
            }).toList();
          },
          ),
        ],
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('Results', style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  )),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: PrikazaniPostovi.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded, size: 56, color: AppColors.textColorOpis),
                            const SizedBox(height: 12),
                            Text('No results found', style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                            const SizedBox(height: 4),
                            Text('Try searching for something else', style: TextStyle(
                              color: AppColors.textColorOpis,
                              fontSize: 13,
                            )),
                          ],
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
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(16),
                              
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(post['title']??'', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textColor)),
                                const SizedBox(height: 6),
                                Text(post['description']??'', style: TextStyle(color: AppColors.textColorOpis),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post['authorId']??''}', style: const TextStyle(fontStyle: FontStyle.italic, color: AppColors.textColorOpis)),
                                    Wrap(
                                      spacing: 6,
                                      children: (post['interests'] as List<dynamic>? ?? []).cast<String>().map((i) => Chip(
                                        label: Text(i, style: TextStyle(color: AppColors.textColor, fontSize: 12)),
                                        backgroundColor: AppColors.buttonColor,
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