import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/summary_response.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class SummaryProvider with ChangeNotifier {
   bool _isSaving = false;
  
  bool get isSaving => _isSaving;
  
  void setSaving(bool value) {
    _isSaving = value;
    notifyListeners();
  }

  SummaryResponse? _currentSummary;
  bool _isLoading = false;
  String _error = '';
  List<SummaryResponse> _history = [];

  SummaryResponse? get currentSummary => _currentSummary;
  bool get isLoading => _isLoading;
  String get error => _error;
  List<SummaryResponse> get history => _history;

  Future<void> fetchSummary(String topic, {String detailLevel = "medio"}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://07bwpv2s-3000.usw3.devtunnels.ms/generate-summary'), 
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'topic': topic,
          'detailLevel': detailLevel,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _currentSummary = SummaryResponse.fromJson(data);
        
        // Guardar en el historial
        if (!_history.any((s) => s.topic == topic && s.detailLevel == detailLevel)) {
          _history.add(_currentSummary!);
        }
        
        _error = '';
      } else {
        _error = 'Error al generar resumen: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSummary() async {
    if (_currentSummary == null) return;

    try {
      // Crear el documento PDF
      final pdf = pw.Document();
      
      // Agregar contenido al PDF
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  child: pw.Text(
                    _currentSummary!.topic,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Text(
                      'Nivel de detalle: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(_currentSummary!.getDetailLevelName()),
                  ],
                ),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text(
                  _currentSummary!.summary,
                  style: const pw.TextStyle(fontSize: 14),
                  textAlign: pw.TextAlign.justify,
                ),
                pw.SizedBox(height: 30),
                pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text(
                    'Generado por Quiz Genius App de Jose Guadalupe :)',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontStyle: pw.FontStyle.italic,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Guardar el archivo
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/resumen_${_currentSummary!.topic}.pdf");
      await file.writeAsBytes(await pdf.save());

      // Abrir el archivo
      await OpenFile.open(file.path);

      // Notificar éxito
      _error = '';
    } catch (e) {
      _error = 'Error al guardar PDF: $e';
    } finally {
      notifyListeners();
    }
  }


  void loadFromHistory(SummaryResponse summary) {
    _currentSummary = summary;
    notifyListeners();
  }

  void clearCurrentSummary() {
    _currentSummary = null;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}