import 'package:flutter/material.dart';

enum TabFilterToDo { allTask, completed, incompleted }

class FilterToDo extends StatefulWidget {
  final Function(TabFilterToDo) onChange;

  const FilterToDo({
    super.key,
    required this.onChange,
  });

  @override
  State<FilterToDo> createState() => _FilterToDoState();
}

class _FilterToDoState extends State<FilterToDo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final currentTab = TabFilterToDo.values[_tabController.index];
      widget.onChange(currentTab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'All task'),
          Tab(text: 'Completed'),
          Tab(text: 'Incompleted'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
