import 'package:drrew_template/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
              child: Material(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                clipBehavior: Clip.antiAlias,
                elevation: 1,
                shadowColor: colorScheme.shadow,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    'Note $index',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Content of note $index',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  onTap: () {},
                  trailing: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    color: colorScheme.surfaceContainerHigh,
                    onSelected: (value) {
                      if (value == 'edit') {
                        // TODO: edit note
                      } else if (value == 'delete') {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AppDialog(
                            subtitle:
                                'Are you sure you want to delete this note?',
                            onBack: () => Navigator.of(context).pop(),
                            type: AppDialogType.confirmation,
                            title: 'Delete Note',
                            buttonLabel: 'Yes',
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
