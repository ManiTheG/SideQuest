import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String? userBio;
  final List<String> userInterests;
  // List of maps with keys: 'naslov','opis','autor','interesi'
  final List<Map<String, dynamic>> userPosts;

  const ProfilePage({
    super.key,
    required this.userName,
    this.userBio,
    required this.userInterests,
    required this.userPosts,
  });

  // Preset constructor with sample data
  const ProfilePage.preset({super.key})
      : userName = 'Slađana B.',
        userBio = 'Puzzle Master',
        userInterests = const ['Puzzles', 'D&D', 'Archery', 'Putovanja', 'Tehnologija'],
        userPosts = const [
          {
            'naslov': 'Prvo rješenje zagonetke',
            'opis': 'Podijelila sam rješenje moje omiljene zagonetke.',
            'autor': 'Slađana B.',
            'interesi': ['Puzzles', 'Tehnologija'],
          },
          {
            'naslov': 'D&D kampanja - savjeti',
            'opis': 'Kako voditi zanimljivu kampanju za početnike.',
            'autor': 'Slađana B.',
            'interesi': ['D&D'],
          },
          {
            'naslov': 'Putovanje u Sloveniju',
            'opis': 'Mali vodič i preporuke za putovanje.',
            'autor': 'Slađana B.',
            'interesi': ['Putovanja'],
          },
          {
            'naslov': 'Arhery basics',
            'opis': 'Osnove streličarstva za početnike.',
            'autor': 'Slađana B.',
            'interesi': ['Archery', 'Fitness'],
          },
        ];

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 2;

  void _onTap(int index) {
    if (index == 0) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Home nije dostupan za povratak')),
        );
      }
      return;
    }

    if (index == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Search nije implementiran')),
      );
      setState(() => _currentIndex = index);
      return;
    }

    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final posts = widget.userPosts;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings tapped')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // glavni profil kartica
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 36,
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              if (widget.userBio != null && widget.userBio!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(widget.userBio!, style: const TextStyle(color: Colors.white70)),
                                ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit profile')));
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatColumn(posts.length.toString(), 'Posts'),
                        _buildStatColumn('12', 'Responses'),
                        _buildStatColumn('15', 'Connections'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // lista interesa
              const Text('Your Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.userInterests.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final interest = widget.userInterests[i];
                    return FilterChip(
                      label: Text(interest),
                      selected: false,
                      onSelected: (_) {},
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // lista postova
              const Text('Your Posts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (posts.isEmpty)
              // prikaz kada nema postova
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.insert_drive_file, size: 48, color: Colors.grey),
                        const SizedBox(height: 8),
                        const Text('No Posts yet', style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Create post')));
                          },
                          child: const Text('Create Your First Post'),
                        ),
                      ],
                    ),
                  ),
                )
              else
              // prikaz postova ako ih ima
                Column(
                  children: posts.map((p) {
                    final naslov = p['naslov'] ?? '';
                    final opis = p['opis'] ?? '';
                    final autor = p['autor'] ?? '';
                    final interesi = (p['interesi'] as List<dynamic>? ?? []).cast<String>();
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(naslov, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(opis),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Autor: $autor', style: const TextStyle(fontStyle: FontStyle.italic)),
                              Wrap(
                                spacing: 6,
                                children: interesi.map((i) => Chip(label: Text(i))).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}