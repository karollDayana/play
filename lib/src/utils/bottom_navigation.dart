import 'package:flutter/material.dart';

// se establecen los items que van a haber en boton de la barra
enum TabItem { series, inicio, peliculas, perfil }

// mapa para nombrar cada item
Map<TabItem, String> tabName = {
  TabItem.series    : 'Series',
  TabItem.inicio    : 'Home',
  TabItem.peliculas : 'Peliculas',
  TabItem.perfil    : 'Perfil',
};

Map<TabItem, IconData> seleccionarTabIcono = {
  TabItem.series    : Icons.tv,
  TabItem.inicio    : Icons.home,
  TabItem.peliculas : Icons.movie,
  TabItem.perfil    : Icons.people,
};

class BottomNavigation extends StatelessWidget {
  BottomNavigation({this.currentTab, this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.brown[400],
      type: BottomNavigationBarType.fixed,
      items: [
        _crearItem(tabItem: TabItem.series),
        _crearItem(tabItem: TabItem.inicio),
        _crearItem(tabItem: TabItem.peliculas),
        _crearItem(tabItem: TabItem.perfil),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _crearItem({TabItem tabItem}) {
    String text = tabName[tabItem];
    IconData icon = seleccionarTabIcono[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      ),
      title: Text(
        text,
        style: TextStyle(
          color: _colorTabMatching(item: tabItem),
        ),
      ),
    );
  }

  // Asigna el color al item que es seleccionado y los otros quedan grises
  Color _colorTabMatching({TabItem item}) {
    return currentTab == item ? Colors.white : Colors.black;
  }
}