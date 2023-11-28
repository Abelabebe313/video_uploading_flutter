import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            toolbarHeight: 70,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Discover Page'),
              centerTitle: true,
            ),
          ),
          SliverFillRemaining(
            child: Center(
              child: Text(
                'Discovery Page',
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
