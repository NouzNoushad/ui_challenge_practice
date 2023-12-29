import 'package:flutter/material.dart';

import 'animated_fab.dart';

class FilterMenuScreen extends StatefulWidget {
  const FilterMenuScreen({super.key});

  @override
  State<FilterMenuScreen> createState() => _FilterMenuScreenState();
}

class _FilterMenuScreenState extends State<FilterMenuScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  double topHeight = 256.0;
  ListModel? listModel;
  bool showCompleted = false;

  @override
  void initState() {
    listModel = ListModel(listKey: listKey, items: tasks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _buildTimeLine(),
        _buildTopHeader(),
        _buildBottom(),
        _buildFab(),
      ]),
    );
  }

  void changeFilterState() {
    showCompleted = !showCompleted;
    tasks.where((task) => !task.completed!).forEach((task) {
      if (showCompleted) {
        listModel?.removeAt(listModel!.indexOf(task));
      } else {
        listModel?.insert(tasks.indexOf(task), task);
      }
    });
  }

  Widget _buildFab() => Positioned(
      top: topHeight - 100.0,
      right: -40.0,
      child: AnimatedFab(
        onClick: changeFilterState,
      ));

  Widget _buildBottom() => Padding(
      padding: EdgeInsets.only(top: topHeight),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - topHeight,
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildTitle(),
          _buildTaskList(),
        ]),
      ));

  Widget _buildTaskList() => Expanded(
      child: AnimatedList(
          key: listKey,
          initialItemCount: tasks.length,
          itemBuilder: (context, index, animation) {
            return TaskRow(
              task: tasks[index],
              animation: animation,
            );
          }));

  Widget _buildTitle() => const Padding(
        padding: EdgeInsets.only(left: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasks',
              style: TextStyle(
                fontSize: 35,
              ),
            ),
            Text(
              'December 28 2023',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      );

  Widget _buildTopHeader() => Positioned.fill(
        bottom: null,
        child: ClipPath(
          clipper: DiagonalClipper(),
          child: Container(
            height: topHeight,
            color: Colors.purple,
          ),
        ),
      );

  Widget _buildTimeLine() => Positioned(
      bottom: 0.0,
      top: 0.0,
      left: 32,
      child: Container(
        width: 1.0,
        color: Colors.grey.shade300,
      ));
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var h = size.height;
    var w = size.width;

    var path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, h * 0.8)
      ..lineTo(w, h)
      ..lineTo(w, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class TaskRow extends StatelessWidget {
  final Task task;
  final double dotSize = 12.0;
  final Animation<double> animation;

  const TaskRow({super.key, required this.task, required this.animation});
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
                child: Container(
                  height: dotSize,
                  width: dotSize,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: task.color),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.name ?? '',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      task.category ?? '',
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  task.time ?? '',
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Task {
  final String? name;
  final String? category;
  final String? time;
  final Color? color;
  final bool? completed;

  Task({this.name, this.category, this.time, this.color, this.completed});
}

List<Task> tasks = [
  Task(
      name: "Catch up with Brian",
      category: "Mobile Project",
      time: "5pm",
      color: Colors.orange,
      completed: false),
  Task(
      name: "Make new icons",
      category: "Web App",
      time: "3pm",
      color: Colors.cyan,
      completed: true),
  Task(
      name: "Design explorations",
      category: "Company Website",
      time: "2pm",
      color: Colors.pink,
      completed: false),
  Task(
      name: "Lunch with Mary",
      category: "Grill House",
      time: "12pm",
      color: Colors.cyan,
      completed: true),
  Task(
      name: "Teem Meeting",
      category: "Hangouts",
      time: "10am",
      color: Colors.cyan,
      completed: true),
];

class ListModel {
  ListModel({
    required this.listKey,
    required List<Task> items,
  }) : items = List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Task> items;

  AnimatedListState? get animatedList => listKey.currentState;

  void insert(int index, Task item) {
    items.insert(index, item);
    animatedList?.insertItem(index,
        duration: const Duration(milliseconds: 150));
  }

  Task removeAt(int index) {
    final Task removedItem = items.removeAt(index);
    animatedList?.removeItem(
        index,
        (context, animation) =>
            TaskRow(task: removedItem, animation: animation),
        duration:
            Duration(milliseconds: (150 + 200 * (index / length)).toInt()));
    return removedItem;
  }

  int get length => items.length;

  int indexOf(Task item) => items.indexOf(item);
}
