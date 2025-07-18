import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2cXZlb3RzY29vdHVhYXJ1cGxrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA5MTg4NjQsImV4cCI6MjA2NjQ5NDg2NH0.HKn7JP4qvnMCQLW8guV4uzWrzv5ft_gBZo_HKeFDW3U',
        'Content-Type': 'application/json',
      },
    ),
  );
});
