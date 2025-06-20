import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/summary_provider.dart';
import '../routes/app_routes.dart';

class GenerateSummaryScreen extends StatefulWidget {
  const GenerateSummaryScreen({super.key});

  @override
  State<GenerateSummaryScreen> createState() => _GenerateSummaryScreenState();
}

class _GenerateSummaryScreenState extends State<GenerateSummaryScreen> {
  final _topicController = TextEditingController();
  String _detailLevel = 'medio';

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Resumen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.summaryHistory);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Ingresa un tema para generar un resumen',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _topicController,
                      decoration: const InputDecoration(
                        labelText: 'Tema de estudio',
                        prefixIcon: Icon(Icons.school),
                        hintText: 'Ej: Revolución Mexicana',
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: _detailLevel,
                      decoration: const InputDecoration(
                        labelText: 'Nivel de detalle',
                        prefixIcon: Icon(Icons.layers),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'básico', child: Text('Básico')),
                        DropdownMenuItem(value: 'medio', child: Text('Medio')),
                        DropdownMenuItem(value: 'avanzado', child: Text('Avanzado')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _detailLevel = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (summaryProvider.isLoading)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Generando resumen...'),
                ],
              )
            else
              ElevatedButton(
                onPressed: () async {
                  if (_topicController.text.isNotEmpty) {
                    await summaryProvider.fetchSummary(
                      _topicController.text,
                      detailLevel: _detailLevel,
                    );
                    
                    if (summaryProvider.error.isEmpty && summaryProvider.currentSummary != null) {
                      Navigator.pushNamed(context, AppRoutes.summaryView);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor ingresa un tema'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: const Text('Generar Resumen'),
              ),
            if (summaryProvider.error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Error del servidor',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          summaryProvider.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}