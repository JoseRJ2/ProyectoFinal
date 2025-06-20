import 'package:flutter/material.dart';

class SummaryResponse {
  final String topic;
  final String detailLevel;
  final String summary;
  final DateTime createdAt;
  bool isSaved;

  SummaryResponse({
    required this.topic,
    required this.detailLevel,
    required this.summary,
    DateTime? createdAt,
    this.isSaved = false,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      topic: json['topic'] ?? '',
      detailLevel: json['detailLevel'] ?? 'medio',
      summary: json['summary'] ?? '',
    );
  }

    String getDetailLevelName() {
    switch (detailLevel.toLowerCase()) {
      case 'básico': return 'Básico';
      case 'medio': return 'Medio';
      case 'avanzado': return 'Avanzado';
      default: return detailLevel;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'detailLevel': detailLevel,
      'summary': summary,
      'createdAt': createdAt.toIso8601String(),
      'isSaved': isSaved,
    };
  }

    String get detailLevelName {
    switch (detailLevel) {
      case 'básico': return 'Básico';
      case 'medio': return 'Medio';
      case 'avanzado': return 'Avanzado';
      default: return detailLevel;
    }
  }

  String get formattedDate {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  String get preview {
    if (summary.length <= 100) return summary;
    return '${summary.substring(0, 100)}...';
  }
  
  Color get detailLevelColor {
    switch (detailLevel) {
      case 'básico': return Colors.green;
      case 'medio': return Colors.blue;
      case 'avanzado': return Colors.purple;
      default: return Colors.grey;
    }
  }
}