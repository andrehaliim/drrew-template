import 'package:drrew_template/network/api_exception.dart';
import 'package:drrew_template/widgets/app_dialogs.dart';
import 'package:drrew_template/widgets/app_shimmer.dart';
import 'package:drrew_template/widgets/app_state_view.dart';
import 'package:flutter/material.dart';

enum _ViewState { loading, data, empty, error }

class _DummyNote {
  const _DummyNote({required this.title, required this.content});
  final String title;
  final String content;
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  _ViewState _state = _ViewState.loading;
  List<_DummyNote> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  Future<void> _loadDummyData() async {
    setState(() => _state = _ViewState.loading);

    // Simulasi network delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    _notes = List.generate(
      10,
      (index) => _DummyNote(
        title: 'Note ${index + 1}',
        content: 'Content of dummy note ${index + 1}',
      ),
    );

    setState(() => _state = _ViewState.data);
  }

  /// Cuma buat testing UI state manual, belum ada backend beneran.
  void _simulateState(_ViewState state) {
    if (state == _ViewState.loading) {
      _loadDummyData();
      return;
    }
    setState(() {
      _state = state;
      if (state == _ViewState.empty) _notes = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<_ViewState>(
            tooltip: 'Simulate state (dummy)',
            icon: const Icon(Icons.bug_report_outlined),
            onSelected: _simulateState,
            itemBuilder: (context) => const [
              PopupMenuItem(value: _ViewState.loading, child: Text('Loading')),
              PopupMenuItem(value: _ViewState.data, child: Text('Data')),
              PopupMenuItem(value: _ViewState.empty, child: Text('Empty')),
              PopupMenuItem(value: _ViewState.error, child: Text('Error')),
            ],
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_state) {
      case _ViewState.loading:
        return const AppShimmerListView();

      case _ViewState.empty:
        return AppStateView(
          type: AppStateType.empty,
          title: 'No notes yet',
          subtitle: 'Notes you create will show up here.',
        );

      case _ViewState.error:
        // Dummy ApiException, biar sekalian nunjukin factory-nya jalan.
        final dummyException = ApiException(
          message: 'Failed to load notes, please try again.',
          type: ApiExceptionType.unknown,
        );
        return AppStateView.fromException(
          dummyException,
          onRetry: _loadDummyData,
        );

      case _ViewState.data:
        return _buildList(context);
    }
  }

  Widget _buildList(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: _loadDummyData,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
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
                  note.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  note.content,
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
                    if (value == 'edit') {} else if (value == 'delete') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AppDialog(
                          subtitle:
                              'Are you sure you want to delete this note?',
                          onBack: () {
                            setState(() {
                              _notes.removeAt(index);
                              if (_notes.isEmpty) _state = _ViewState.empty;
                            });
                            Navigator.of(context).pop();
                          },
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
    );
  }
}