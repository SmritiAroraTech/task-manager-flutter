import 'package:flutter/material.dart';
import 'package:task_manager/helpers/dbHelper.dart';
import 'package:task_manager/models/taskModel.dart';
import 'package:task_manager/widgets/taskCard.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<TaskModel> favoriteList = [];

  void fetchFavorites() async {
    favoriteList = await DBHelper.fetchFavorites(1);
    setState(() {});
  }

  void removeFromFavorite(TaskModel taskItem) async {
    await DBHelper.updateTask({
      'id': taskItem.id,
      'name': taskItem.name,
      'desc': taskItem.desc ?? 'null',
      'isFavorite': 0,
      'categoryName': taskItem.categoryName
    });
    fetchFavorites();
  }

  @override
  void initState() {
    fetchFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteList.isEmpty
          ? Center(
              child: Text('No favorites yet! Add some from your task list.'),
            )
          : ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (ctx, index) => TaskCard(
                    taskItem: favoriteList[index],
                    deleteItem: removeFromFavorite,
                    isFavoritesScreen: true,
                    toggleFavoriteStatus: null,
                  )),
    );
  }
}
