import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/summary_provider.dart';
import '../routes/app_routes.dart';

class SummaryHistoryScreen extends StatelessWidget {
  const SummaryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(context);
    final history = summaryProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Resúmenes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                'No hay resúmenes en el historial',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final summary = history[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(summary.topic),
                    subtitle: Text(summary.preview),
                    trailing: Chip(
                      label: Text(summary.detailLevelName),
                      backgroundColor: _getDetailLevelColor(summary.detailLevel),
                    ),
                    onTap: () {
                      summaryProvider.loadFromHistory(summary);
                      Navigator.pushNamed(context, AppRoutes.summaryView);
                    },
                  ),
                );
              },
            ),
    );
  }

  Color _getDetailLevelColor(String level) {
    switch (level) {
      case 'básico': return Colors.green[100]!;
      case 'medio': return Colors.blue[100]!;
      case 'avanzado': return Colors.purple[100]!;
      default: return Colors.grey[200]!;
    }
  }
}