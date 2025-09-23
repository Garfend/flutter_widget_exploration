import 'package:flutter/material.dart';

class InterActiveDismisableLists extends StatefulWidget {
  const InterActiveDismisableLists({super.key});

  @override
  State<InterActiveDismisableLists> createState() =>
      _InterActiveDismisableListsState();
}

class _InterActiveDismisableListsState
    extends State<InterActiveDismisableLists> {
  final List<String> _tasks = ['Buy groceries', 'Walk the dog', 'Read a book'];
  final List<bool> _checked = [false, false, false];
  String? _recentlyDeletedTask;
  int? _recentlyDeletedTaskIndex;
  bool? _recentlyDeletedChecked;

  Future<bool> _showConfirmDialog(BuildContext context, String task) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "$task"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _deleteTask(int index) {
    setState(() {
      _recentlyDeletedTask = _tasks[index];
      _recentlyDeletedTaskIndex = index;
      _recentlyDeletedChecked = _checked[index];
      _tasks.removeAt(index);
      _checked.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              if (_recentlyDeletedTask != null &&
                  _recentlyDeletedTaskIndex != null) {
                _tasks.insert(
                  _recentlyDeletedTaskIndex!,
                  _recentlyDeletedTask!,
                );
                _checked.insert(
                  _recentlyDeletedTaskIndex!,
                  _recentlyDeletedChecked ?? false,
                );
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager')),
      body: ReorderableListView.builder(
        itemCount: _tasks.length,

        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _tasks.removeAt(oldIndex);
            final checked = _checked.removeAt(oldIndex);
            _tasks.insert(newIndex, item);
            _checked.insert(newIndex, checked);
          });
        },
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final checked = _checked[index];
          return Dismissible(
            key: ValueKey('dismissible_$task$index'),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => _showConfirmDialog(context, task),
            onDismissed: (_) => _deleteTask(index),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(
                task,
                style: checked
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      )
                    : null,
              ),
              leading: ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
              trailing: Checkbox(
                value: checked,
                onChanged: (value) {
                  setState(() {
                    _checked[index] = value ?? false;
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}