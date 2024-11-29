// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:to_do/domain/entities/entities.dart';
import 'package:to_do/ui/assets/text_style/text_style.dart';

import '../../../presentation/presentations/presentations.dart';
import '../../assets/colors/colors.dart';

class TaskWidget extends StatefulWidget {
  final TaskEntity task;
  const TaskWidget({
    super.key,
    required this.task,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<ProviderToDoPresenter>();
    final task = widget.task;
    String text = task.title;
    Size size = MediaQuery.of(context).size;

    return Dismissible(
      key: Key(task.id.toString()),
      confirmDismiss: (DismissDirection direction) async {
        if (DismissDirection.startToEnd == direction) {
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Icon(
                  Icons.warning,
                  size: size.width * .1,
                ),
                content: const Text(
                  "Do you really want to delete?",
                  textAlign: TextAlign.center,
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("No")),
                      TextButton(
                        onPressed: () async {
                          await presenter.removeTask(
                            task.id!,
                          );
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          await presenter.editTask(
            widget.task.copyWith(isEditing: true),
          );
          return false;
        }
      },
      direction: DismissDirection.horizontal,
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: const Alignment(-0.9, 0),
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Theme.of(context).primaryColor,
        child: const Align(
          alignment: Alignment(0.9, 0),
          child: Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
      ),
      child: Container(
        color: task.isEditing ? AppColors.cardBackground : Colors.transparent,
        height: 50,
        child: Row(
          children: [
            Checkbox(
              value: task.isCheck,
              onChanged: (value) async {
                await presenter.editTask(widget.task.copyWith(isCheck: value));
              },
              activeColor: AppColors.highlight,
              checkColor: AppColors.background,
              side: BorderSide.none,
              fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors
                        .highlight; // Cor de fundo quando desabilitado
                  }
                  return AppColors.disabled; // Cor padrão
                },
              ),
            ),
            task.isEditing
                ? Expanded(
                    child: TextFormField(
                      autofocus: task.isEditing,
                      initialValue: task.title,
                      style: AppTextStyles.item,
                      decoration: InputDecoration(
                        hintText: 'White text',
                        hintStyle: AppTextStyles.item.copyWith(
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      onChanged: (value) async {
                        text = value;
                      },
                      onSaved: (newValue) async {
                        await presenter.editTask(
                          widget.task.copyWith(
                              title: newValue ?? '', isEditing: false),
                        );
                        FocusScope.of(context).unfocus();
                      },
                      onTapOutside: (event) async {
                        await presenter.editTask(
                          widget.task
                              .copyWith(title: text ?? '', isEditing: false),
                        );
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  )
                : Text(
                    task.title,
                    style: AppTextStyles.item,
                  ),
          ],
        ),
      ),
    );
  }
}
