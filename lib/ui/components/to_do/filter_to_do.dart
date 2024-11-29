import 'package:flutter/material.dart';
import 'package:to_do/ui/assets/colors/colors.dart';

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
        dividerColor: Colors.transparent,
        labelColor: AppColors.primary,
        controller: _tabController,
        tabs: const [
          Tab(
            child: Text(
              'All task',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          Tab(
            child: Text(
              'Completed',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          Tab(
            child: Text(
              'Incompleted',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
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
