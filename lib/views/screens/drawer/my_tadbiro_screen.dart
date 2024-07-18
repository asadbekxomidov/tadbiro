import 'package:flutter/material.dart';
import 'package:tadbiro/views/screens/drawer/widgets/bekorqilinganlar_widgets.dart';
import 'package:tadbiro/views/screens/drawer/widgets/ishtiroketilganlar_widgets.dart';
import 'package:tadbiro/views/screens/drawer/widgets/tashkilqilinganlar_widgets.dart';
import 'package:tadbiro/views/screens/drawer/widgets/yaninda_widgets.dart';
import 'package:tadbiro/views/widgets/custom_drawer_widget.dart';

class MyTadbiroScreen extends StatelessWidget {
  const MyTadbiroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Mening tadbirlarim'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications_none_outlined),
            ),
          ],
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
              Tab(text: 'Tashkil qilinganlar'),
              Tab(text: 'Yaqinda'),
              Tab(text: 'Ishtirok etganlarim'),
              Tab(text: 'Bekor qilinganlar'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TashkilQilinganlar(),
            YaqindaWidgets(),
            IshtiroketilganlarWidget(),
            BekorqilinganlarWidget(),
          ],
        ),
      ),
    );
  }
}
