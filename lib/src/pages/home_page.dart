import 'package:flutter/material.dart';
import 'package:play/src/utils/bottom_navigation.dart';
import 'package:play/src/pages/tab_navigator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 TabItem _currentTab = TabItem.inicio;
  Map<TabItem, GlobalKey<NavigatorState>> _navigatorKeys = {
    TabItem.series: GlobalKey<NavigatorState>(),
    TabItem.inicio: GlobalKey<NavigatorState>(),
    TabItem.peliculas: GlobalKey<NavigatorState>(),
    TabItem.perfil: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      _navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentTab].currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (_currentTab != TabItem.series) {
            // select 'main' tab
            _selectTab(TabItem.series);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(children: <Widget>[
          _buildOffstageNavigator(TabItem.series),
          _buildOffstageNavigator(TabItem.inicio),
          _buildOffstageNavigator(TabItem.peliculas),
          _buildOffstageNavigator(TabItem.perfil),
        ]),
        bottomNavigationBar: BottomNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}