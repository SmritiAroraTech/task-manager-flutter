import 'package:flutter/material.dart';
import 'package:task_manager/helpers/dbHelper.dart';
import 'package:task_manager/models/categoryModel.dart';
import 'package:task_manager/screens/favoriteScreen.dart';
import '/screens/taskListScreen.dart';

class TaskCategories extends StatefulWidget {
  TaskCategories({Key? key}) : super(key: key);

  @override
  _TaskCategoriesState createState() => _TaskCategoriesState();
}

class _TaskCategoriesState extends State<TaskCategories> {
  List<CategoryModel> categories = [];
  bool isLoading = true;

  void fetchData() async {
    categories = await DBHelper.getCategoryData();
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void deleteCategory(CategoryModel category) async {
    await DBHelper.deleteCategory(category.id, category.name);
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var textFieldController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (ctx) => FavoriteScreen()));
            },
          ),
          title: const Text(
            'Task Categories',
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Enter Category Name'),
                      content: TextField(
                        controller: textFieldController,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              DBHelper.insertCategory({
                                'id': DateTime.now().toString(),
                                'name': textFieldController.text
                              });

                              fetchData();

                              Navigator.of(dialogContext).pop();
                            },
                            child: Text('Add')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                            },
                            child: Text('Cancel'))
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.add)),
          ]),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : categories.isEmpty
              ? Center(
                  child: Text('No categories. Add a new one!'),
                )
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (ctx, index) => Card(
                        child: ListTile(
                          title: Text(categories[index].name),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteCategory(categories[index]);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => TaskListScreen(
                                        categories[index].name)));
                          },
                        ),
                      )),
    );
  }
}
