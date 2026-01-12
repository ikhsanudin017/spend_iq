import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

import '../entities/alert_item.dart';
import '../repositories/finance_repository.dart';

class GetAlertsUseCase {
  GetAlertsUseCase(this._repository);

  final FinanceRepository _repository;

  Future<List<AlertItem>> call([AlertType? filter]) async {
    final alerts = await _repository.getAlerts();
    if (filter == null) {
      return alerts;
    }
    return alerts.where((alert) => alert.type == filter).toList();
  }
}

final getAlertsProvider = FutureProvider.family
    .autoDispose<List<AlertItem>, AlertType?>((ref, filter) async {
  final repository = ref.watch(financeRepositoryProvider);
  final useCase = GetAlertsUseCase(repository);
  return useCase(filter);
});
