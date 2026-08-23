import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../../../core/t.dart';
import '../../../database/app_database.dart';
import 'widgets/autocomplete_field.dart';

class EditLiveSessionPage extends StatefulWidget {
  final AppDatabase database;
  final FishingSession session;

  const EditLiveSessionPage({
    super.key,
    required this.database,
    required this.session,
  });

  @override
  State<EditLiveSessionPage> createState() => _EditLiveSessionPageState();
}

class _EditLiveSessionPageState extends State<EditLiveSessionPage> {
  final temperaturaAcquaController = TextEditingController();

  final noteController = TextEditingController();

  final counterControllers = <int, TextEditingController>{};

  List<String> counterNames = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> editCounterName(int counter) async {
    final controller = TextEditingController(
      text: counterControllers[counter]?.text ?? "",
    );

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(T.counterNumber(counter)),
        content: SizedBox(
          width: 350,
          child: AutocompleteField(
            controller: controller,
            availableValues: counterNames,
            hintText: T.counterName,
            onChanged: (value) {
              controller.text = value;
            },
            onSelected: (value) {
              controller.text = value;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(T.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim(),
              );
            },
            child: Text(T.save),
          ),
        ],
      ),
    );

    if (result == null || result.isEmpty) return;

    final counterNameId = await widget.database.getOrCreateCounterName(result);

    await widget.database.updateSessionCounterName(
      widget.session.id,
      counter,
      counterNameId,
    );

    if (!mounted) return;

    setState(() {
      counterControllers[counter]?.text = result;
    });
  }

  Future<void> editNotes() async {
    final controller = TextEditingController(
      text: noteController.text,
    );

    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(T.notes),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: controller,
            maxLines: 6,
            autofocus: true,
            decoration: InputDecoration(
              hintText: T.notes,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(T.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              controller.text.trim(),
            ),
            child: Text(T.save),
          ),
        ],
      ),
    );

    if (result == null) return;

    setState(() {
      noteController.text = result;
    });
  }

  Future<void> saveChanges() async {
    await widget.database.updateSession(
      widget.session.copyWith(
        temperaturaAcqua: Value(
          temperaturaAcquaController.text.isEmpty
              ? null
              : double.tryParse(
                  temperaturaAcquaController.text,
                ),
        ),
        note: Value(
          noteController.text.trim(),
        ),
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    print("=== SALVATAGGIO CONTATORI ===");
    // <<< AGGIUNGI QUI
    final s = await widget.database.getSessionById(
      widget.session.id,
    );

    print("TEMP DB = ${s?.temperaturaAcqua}");
    print("NOTE DB = ${s?.note}");

    print("=== SALVATAGGIO CONTATORI ===");

    for (final entry in counterControllers.entries) {
      final name = entry.value.text.trim();

      if (name.isEmpty) continue;
      print(
        "Counter ${entry.key} = '${entry.value.text}'",
      );
      final counterNameId = await widget.database.getOrCreateCounterName(
        name,
      );

      await widget.database.saveSessionCounter(
        SessionCountersCompanion.insert(
          sessionId: widget.session.id,
          counterNumber: entry.key,
          counterNameId: counterNameId,
        ),
      );
    }

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  Future<void> loadData() async {
    final usedNames = await widget.database.getUsedCounterNames();

    final sessionNames = await widget.database.getSessionCounterNames(
      widget.session.id,
    );

    final maxCounter = await widget.database.getMaxCounterNumber(
      widget.session.id,
    );

    temperaturaAcquaController.text =
        widget.session.temperaturaAcqua?.toString() ?? "";

    noteController.text = widget.session.note ?? "";

    counterControllers.clear();

    for (int i = 1; i <= maxCounter; i++) {
      counterControllers[i] = TextEditingController(
        text: sessionNames[i] ?? "",
      );
    }

    if (!mounted) return;

    setState(() {
      counterNames = usedNames;
    });
  }

  @override
  void dispose() {
    temperaturaAcquaController.dispose();
    noteController.dispose();

    for (final controller in counterControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          T.editSessionDetails,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.water_drop,
                  color: Color(0xFF29B6F6),
                ),
                title: Text(
                  T.waterTemperature,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      temperaturaAcquaController.text.isEmpty
                          ? T.insert
                          : "${temperaturaAcquaController.text} °C",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () async {
                  final controller = TextEditingController(
                    text: temperaturaAcquaController.text,
                  );

                  final result = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(T.waterTemperature),
                      content: TextField(
                        controller: controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autofocus: true,
                        decoration: const InputDecoration(
                          suffixText: "°C",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(T.cancel),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(
                            context,
                            controller.text.trim(),
                          ),
                          child: Text(T.save),
                        ),
                      ],
                    ),
                  );

                  if (result == null) return;

                  setState(() {
                    temperaturaAcquaController.text = result;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: counterControllers.entries.map((entry) {
                  final counter = entry.key;
                  final controller = entry.value;

                  return ListTile(
                    leading: const Icon(
                      Icons.label_outline,
                    ),
                    title: Text(
                      T.counterNumber(counter),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    subtitle: controller.text.isEmpty
                        ? Text(
                            T.insert,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : Text(
                            controller.text,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => editCounterName(counter),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.notes,
                ),
                title: Text(
                  T.notes,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                subtitle: Text(
                  noteController.text.isEmpty ? T.insert : noteController.text,
                  style: noteController.text.isEmpty
                      ? TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        )
                      : Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: editNotes,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                icon: const Icon(Icons.save),
                label: Text(T.save),
                onPressed: saveChanges,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
