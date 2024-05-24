import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter AppBar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> universities = [
    {
      'name': 'Астана медицина университеті',
      'city': 'Нұр-Сұлтан',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/Астана.jpg',
      'programs': 'B001-Педагогика және психология'
    },
    {
      'name': 'С.Сейфуллин атындағы Қазақ агротехникалық университеті',
      'city': 'Нұр-Сұлтан',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/С.Суйфуллин.jpg',
      'programs': 'Agricultural Engineering, Agribusiness, etc.'
    },
    {
      'name':
          'Ш.Есенов атындағы Каспий мемлекеттік технологиялар және инжиниринг университеті',
      'city': 'Ақтау',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/Ш.Есенов.jpg',
      'programs': 'Engineering, Information Technology, etc.'
    },
    {
      'name':
          'М.Оспанов атындағы батыс қазақстан мемлекеттік медицина университеті',
      'city': 'Ақтөбе',
      'phone': '8(7172)53 94 24',
      'imagePath': 'assets/images/М.Оспанов.jpg',
      'programs': 'Medical programs, Health Sciences, etc.'
    },
  ];
  List<Map<String, String>> filteredUniversities = [];
  String? _selectedCity;
  @override
  void initState() {
    super.initState();
    filteredUniversities = universities;
    _searchController.addListener(_filterUniversities);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUniversities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredUniversities = universities.where((university) {
        final name = university['name']!.toLowerCase();
        final city = university['city']!;
        return name.contains(query) &&
            (_selectedCity == null || city == _selectedCity);
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select City'),
          content: SingleChildScrollView(
            child: Column(children: _buildFilterOptions()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedCity = null;
                  _filterUniversities();
                });
                Navigator.of(context).pop();
              },
              child: Text('Clear Filter'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildFilterOptions() {
    final cities =
        universities.map((university) => university['city']!).toSet().toList();
    return cities.map((city) {
      return RadioListTile<String>(
        title: Text(city),
        value: city,
        groupValue: _selectedCity,
        onChanged: (value) {
          setState(() {
            _selectedCity = value;
            _filterUniversities();
          });
          Navigator.of(context).pop();
        },
      );
    }).toList();
  }

  void _navigateToDetailScreen(Map<String, String> university) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UniversityDetailScreen(university: university),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('УНИВЕРСИТЕТТЕР ТІЗІМІ',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () => _searchController.clear()),
                IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: _showFilterDialog),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredUniversities.map((university) {
                return _buildUniversityCard(university);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUniversityCard(Map<String, String> university) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _navigateToDetailScreen(university),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(university['imagePath']!,
                    height: 200, width: 200),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(university['name']!,
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(university['city']!,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(university['phone']!,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UniversityDetailScreen extends StatelessWidget {
  final Map<String, String> university;

  UniversityDetailScreen({required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(university['name']!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(university['imagePath']!,
                width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(university['name']!,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(university['city']!,
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(university['phone']!,
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Programs:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(university['programs']!, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
