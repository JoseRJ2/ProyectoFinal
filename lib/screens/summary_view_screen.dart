import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/summary_provider.dart';
import '../routes/app_routes.dart';
import '../models/summary_response.dart';

class SummaryViewScreen extends StatelessWidget {
  const SummaryViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(context);
    final summary = summaryProvider.currentSummary;

    if (summary == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Resumen no disponible'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.deepPurple),
                const SizedBox(height: 20),
                const Text(
                  'No se encontró el resumen solicitado',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Volver atrás', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen Generado'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: summaryProvider.isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.download, color: Colors.white),
            onPressed: () async {
              // Mostrar estado de carga
              summaryProvider.setSaving(true);
              
              await summaryProvider.saveSummary();
              
              // Ocultar estado de carga
              summaryProvider.setSaving(false);
            },
            tooltip: 'Guardar resumen',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con tema y nivel de detalle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary.topic,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: const Color(0xFF3A0CA3),
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Nivel de detalle:  ${summary.getDetailLevelName()}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDetailLevelColor(summary.detailLevel),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      summary.detailLevel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Contenido del resumen con scroll
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text(
                    summary.summary,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: Color(0xFF495057),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Refinar',
                  color: Colors.blue.shade700,
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      AppRoutes.generateSummary,
                      arguments: summary,
                    );
                  },
                ),
                _buildActionButton(
                  icon: Icons.quiz,
                  label: 'Generar Preguntas',
                  color: Colors.deepPurple,
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      AppRoutes.generateQuestions,
                      arguments: summary.topic,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 170,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  String _getDetailLevelName(String level) {
    switch (level) {
      case 'básico': return 'Básico';
      case 'medio': return 'Medio';
      case 'avanzado': return 'Avanzado';
      default: return level;
    }
  }

  Color _getDetailLevelColor(String level) {
    switch (level) {
      case 'básico': return Colors.green.shade100;
      case 'medio': return Colors.blue.shade100;
      case 'avanzado': return Colors.purple.shade100;
      default: return Colors.grey.shade200;
    }
  }
}