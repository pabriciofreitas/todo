import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/domain/entities/entities.dart';
import 'package:to_do/presentation/presentations/to_do/provider_to_do_presenter.dart';

import '../../assets/colors/colors.dart';
import '../../assets/text_style/text_style.dart';
import '../../components/to_do/filter_to_do.dart';
import '../../components/to_do/task_widget.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({
    super.key,
  });

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<ProviderToDoPresenter>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'tasked',
                style: AppTextStyles.title,
              ),
            ),
            FilterToDo(
              onChange: (filter) async {
                await presenter.changeFilterTask(filter);
              },
            ),
            presenter.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.builder(
                    itemCount: presenter.listTask.length,
                    itemBuilder: (context, index) {
                      return TaskWidget(
                        task: presenter.listTask[index],
                      );
                    },
                  )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () async {
            if (presenter.isEditing()) {
              FocusScope.of(context).unfocus();
            } else {
              await presenter.addTask(TaskEntity(title: '', isEditing: true));
            }
          },
          child: Icon(presenter.isEditing() ? Icons.save : Icons.add,
              color: AppColors.background),
        ),
      ),
    );
  }
}
