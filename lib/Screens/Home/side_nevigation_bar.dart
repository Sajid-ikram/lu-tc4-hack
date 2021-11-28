import 'package:bit_by_bit/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_controller.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({Key? key}) : super(key: key);

  @override
  _SideNavigationBarState createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  int _selectedIndex = 3;
  var padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
            child: NavigationRail(
              minWidth: 56.0,
              groupAlignment: 1.0,
              backgroundColor: Color(0xff2D3035),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                Provider.of<HomeController>(context, listen: false)
                    .changeIndex(index);
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              leading: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 53,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("profile");
                    },
                    child: Center(
                      child: Consumer<ProfileProvider>(
                        builder: (context, provider, child) {
                          return provider.profileUrl != ""
                              ? CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 16,
                                  backgroundImage: NetworkImage(
                                      Provider.of<ProfileProvider>(context,
                                              listen: false)
                                          .profileUrl),
                                )
                              : const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 16,
                                  backgroundImage:
                                      AssetImage("assets/profile.jpg"),
                                );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  RotatedBox(
                    quarterTurns: -1,
                    child: IconButton(
                      icon: const Icon(Icons.tune),
                      color: const Color(0xffFCCFA8),
                      onPressed: () {},
                    ),
                  ),
                  Consumer<ProfileProvider>(
                    builder: (context, provider, child) {
                      return provider.role == "Seller"
                          ? IconButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed("AddProduct");
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xffFCCFA8),
                              ))
                          : const SizedBox();
                    },
                  )
                ],
              ),
              selectedLabelTextStyle: const TextStyle(
                color: Color(0xffFCCFA8),
                fontSize: 13,
                letterSpacing: 0.8,
                decoration: TextDecoration.underline,
                decorationThickness: 2.0,
              ),
              unselectedLabelTextStyle: const TextStyle(
                  fontSize: 13, letterSpacing: 0.8, color: Colors.white),
              destinations: [
                buildRotatedTextRailDestination("Fashion", padding),
                buildRotatedTextRailDestination("Electronics", padding),
                buildRotatedTextRailDestination("Accessories", padding),
                buildRotatedTextRailDestination("All", padding),
              ],
            ),
          ),
        ),
      );
    });
  }

  NavigationRailDestination buildRotatedTextRailDestination(
      String text, double padding) {
    return NavigationRailDestination(
      icon: SizedBox.shrink(),
      label: Padding(
        padding: EdgeInsets.symmetric(vertical: padding),
        child: RotatedBox(
          quarterTurns: -1,
          child: Text(text),
        ),
      ),
    );
  }
}
