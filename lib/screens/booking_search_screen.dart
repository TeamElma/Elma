import 'package:flutter/material.dart';

class BookingSearchScreen extends StatefulWidget {
  const BookingSearchScreen({Key? key}) : super(key: key);

  @override
  _BookingSearchScreenState createState() => _BookingSearchScreenState();
}

class _BookingSearchScreenState extends State<BookingSearchScreen> {
  final List<String> turkishCities = [
    "Adana","Adıyaman","Afyonkarahisar","Ağrı","Amasya","Ankara","Antalya","Artvin","Aydın","Balıkesir",
    "Bilecik","Bingöl","Bitlis","Bolu","Burdur","Bursa","Çanakkale","Çankırı","Çorum","Denizli","Diyarbakır",
    "Edirne","Elâzığ","Erzincan","Erzurum","Eskişehir","Gaziantep","Giresun","Gümüşhane","Hakkâri","Hatay",
    "Isparta","Mersin","İstanbul","İzmir","Kars","Kastamonu","Kayseri","Kırklareli","Kırşehir","Kocaeli","Konya",
    "Kütahya","Malatya","Manisa","Kahramanmaraş","Mardin","Muğla","Muş","Nevşehir","Niğde","Ordu","Rize","Sakarya",
    "Samsun","Siirt","Sinop","Sivas","Tekirdağ","Tokat","Trabzon","Tunceli","Şanlıurfa","Uşak","Van","Yozgat","Zonguldak",
    "Aksaray","Bayburt","Karaman","Kırıkkale","Batman","Şırnak","Bartın","Ardahan","Iğdır","Yalova","Karabük","Kilis",
    "Osmaniye","Düzce"
  ];
  String selectedCity = '';
  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Choose a Location',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Autocomplete search bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.all(16),
            child: Autocomplete<String>(
              optionsBuilder: (TextEditingValue t) {
                if (t.text.isEmpty) return const [];
                return turkishCities.where((c) =>
                    c.toLowerCase().contains(t.text.toLowerCase()));
              },
              onSelected: (s) => setState(() => selectedCity = s),
              fieldViewBuilder: (ctx, ctl, fn, onSubmit) {
                return TextField(
                  controller: ctl,
                  focusNode: fn,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: 'Search a city…',
                    border: InputBorder.none,
                  ),
                );
              },
            ),
          ),

          if (selectedCity.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  'You selected: $selectedCity',
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: turkishCities.length,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(turkishCities[i]),
                onTap: () => setState(() => selectedCity = turkishCities[i]),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentBottomNavIndex,
        onTap: (i) => setState(() => _currentBottomNavIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.message_outlined), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
