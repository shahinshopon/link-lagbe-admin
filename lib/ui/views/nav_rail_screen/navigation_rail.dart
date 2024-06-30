import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:link_lagbe_update/model/navigation_rail_destinations.dart';
import 'package:link_lagbe_update/ui/views/nav_rail_screen/all_catagory_screen.dart';
import 'package:link_lagbe_update/ui/views/nav_rail_screen/version_control_screen.dart';
import 'package:link_lagbe_update/ui/views/nav_rail_screen/viral_news_screen.dart';

class NevigationRailScreen extends StatefulWidget {
  NevigationRailScreen({super.key});

  @override
  State<NevigationRailScreen> createState() => _NevigationRailScreenState();
}

class _NevigationRailScreenState extends State<NevigationRailScreen> {
  final List<NavigationRailDestination> destinationList = [
    destination(Icons.category_outlined, "All categoris"),
    destination(Icons.newspaper_outlined, "Viral News"),
    destination(Icons.numbers, "version controll"),
  ];

  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
        ),
        body: Obx(() => SafeArea(
                child: Row(
              children: [
                NavigationRail(
                    extended: true,
                    onDestinationSelected: (value) {
                      selectedIndex.value = value;
                    },
                    destinations: destinationList,
                    selectedIndex: selectedIndex.value),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                    child: selectedIndex.value == 0
                        ? AllCategoryScreen()
                        : selectedIndex.value == 1
                            ? ViralNews()
                            : VersionControlScreen())
              ],
            ))));
  }
}
