import 'package:drrew_template/widgets/app_buttons.dart';
import 'package:drrew_template/widgets/app_dialogs.dart';
import 'package:drrew_template/widgets/app_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _noteFormKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Notes'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AppDialog(
                  subtitle: 'Are you sure you want to delete this note?',
                  onBack: () {
                    _titleController.clear();
                    _contentController.clear();
                    Navigator.of(context).pop();
                  },
                  type: AppDialogType.confirmation,
                  title: 'Delete Note',
                  buttonLabel: 'Yes',
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Form(
        key: _noteFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppTextFormField(
                        label: 'Title',
                        controller: _titleController,
                        focusNode: _titleFocus,
                        type: AppTextFieldType.normal,
                      ),
                      SizedBox(height: 8),
                      AppTextFormField(
                        label: 'Content',
                        controller: _contentController,
                        focusNode: _contentFocus,
                        type: AppTextFieldType.normal,
                        maxLines: 20,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: AppButtons.filledButton(
                  context: context,
                  label: 'Save',
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_noteFormKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() => _isLoading = false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
