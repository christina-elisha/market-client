

import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';


void main() => runApp(const SearchBarApp());

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  bool isDark = false;
  late int selectedStoreId;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        brightness: isDark ? Brightness.dark : Brightness.light);

    return MaterialApp(
      theme: themeData,
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.navigate_next_outlined),
                label: 'navigate'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'favorite'),
          ],
          backgroundColor: Theme.of(context).primaryColorLight,
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Stack(
            children: <Widget>[
              const Center(
                  // google map api to replace Icon
                  child: Icon(Icons.directions_bike)
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return ListView.separated(
                        controller: scrollController,
                        itemBuilder: (_, index) =>
                          ElevatedButton(
                            onPressed: () {
                              selectedStoreId = index;
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => StoreDetailPage(
                                    storeId: selectedStoreId
                                  )));
                            },
                              child: Text('Store $index')),
                        separatorBuilder: (_, index) =>
                          const Divider(),
                        itemCount: 20);
                  }),
              SearchAnchor(
              builder: (BuildContext context, SearchController controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    controller.openView();
                  },
                  leading: const Icon(Icons.search),
                  trailing: <Widget>[
                    Tooltip(
                      message: 'Change brightness mode',
                      child: IconButton(
                        isSelected: isDark,
                        onPressed: () {
                          setState(() {
                            isDark = !isDark;
                          });
                        },
                        icon: const Icon(Icons.wb_sunny_outlined),
                        selectedIcon: const Icon(Icons.brightness_2_outlined),
                      ),
                    )
                  ],
                );
              }, suggestionsBuilder:
              (BuildContext context, SearchController controller) {
            return List<ListTile>.generate(5, (int index) {
              final String item = 'item $index';
              return ListTile(
                title: Text(item),
                onTap: () {
                  setState(() {
                    controller.closeView(item);
                  });
                },
              );
            });
          }),
        ]
        ),
      ),
    )
    );
  }
}

class StoreDetailPage extends StatefulWidget{
  final int storeId;
  const StoreDetailPage({super.key, required this.storeId});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('store ${widget.storeId}')),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('item'),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 8,
                      ),
                      child: SwipeButton(
                        trackPadding: const EdgeInsets.all(6),
                        activeThumbColor: Colors.blue,
                        activeTrackColor: Colors.blue[100],
                        thumb: const Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        ),
                        elevationThumb: 2,
                        elevationTrack: 2,
                        child: const Text(
                          "Swipe to buy...",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onSwipe: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Swiped"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    ),]
          ),
        ),

    );
  }
}
