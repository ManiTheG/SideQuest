import 'package:flutter/material.dart';
import '../widget/bottom.dart';
import '../services/color_service.dart';

List<Post> PrikazaniPostovi = [];

List<String> InteresiZaPretragu = [
  'interes1',
  'interes2',
  'interes3',
  'interes4',
];

class Post {
  final String naslov;
  final String opis;
  final String autor;
  final List<String> interesi;

  Post({
    required this.naslov,
    required this.opis,
    required this.autor,
    required this.interesi,
  });
}

final List<Post> Postovi = [
  Post(
    naslov: 'Moj prvi post',
    opis: 'Opis posta',
    autor: 'Ivan',
    interesi: ['interes1', 'interes2'],
  ),
  Post(
    naslov: 'Drugi post',
    opis: 'Neki opis',
    autor: 'Ana',
    interesi: ['interes2', 'interes3'],
  ),
  Post(
    naslov: 'Treći post',
    opis: 'Još jedan opis',
    autor: 'Marko',
    interesi: ['interes4'],
  ),
  Post(
    naslov: 'Putovanja i avanture',
    opis: 'Koristan vodič za budžetno putovanje po Europi.',
    autor: 'Luka',
    interesi: ['interes1', 'interes3'],
  ),
  Post(
    naslov: 'Recept dana',
    opis: 'Brzi recept za ukusnu vegansku tjesteninu.',
    autor: 'Maja',
    interesi: ['interes2'],
  ),
  Post(
    naslov: 'Tehnologija 2026',
    opis: 'Pregled najzanimljivijih trendova u mobilnom razvoju.',
    autor: 'Petar',
    interesi: ['interes3', 'interes4'],
  ),
  Post(
    naslov: 'Fit & zdravlje',
    opis: 'Jednostavan plan treninga za početnike kod kuće.',
    autor: 'Sara',
    interesi: ['interes1', 'interes4'],
  ),
  Post(
    naslov: 'Knjiga koju vrijedi pročitati',
    opis: 'Kratka recenzija i citati iz najbolje prodavane knjige.',
    autor: 'Ivona',
    interesi: ['interes2', 'interes3'],
  ),
];

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

   void _searchFor(String query) {
    debugPrint('Search requested for: $query');    
    setState(() {
      PrikazaniPostovi = Postovi
          .where((post) => post.interesi.contains(query))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
      PrikazaniPostovi = Postovi;
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
                leading: const Icon(Icons.search, color: Colors.black26),
              );
            },
            suggestionsBuilder:
                (BuildContext context, SearchController controller) {
              final String input = controller.value.text;
              final Iterable<String> matches = input.isEmpty
                  ? InteresiZaPretragu.take(5)
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
                                Text(post.naslov, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text(post.opis, style: TextStyle(color: Colors.white70),),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Autor: ${post.autor}', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white60)),
                                    Wrap(
                                      spacing: 6,
                                      children: post.interesi.map((i) => Chip(
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