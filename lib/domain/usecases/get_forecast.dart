import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:smartspend_ai/data/repositories/finance_repository_impl.dart';

import '../entities/forecast_point.dart';
import '../repositories/finance_repository.dart';
import '../../services/predictive_engine.dart';

class GetForecastUseCase {
  GetForecastUseCase(this._repository, this._engine);

  final FinanceRepository _repository;
  final PredictiveEngine _engine;

  Future<List<ForecastPoint>> call(int horizon) async {
    final transactions = await _repository.getRecentTransactions();
    return _engine.forecast(transactions, horizon);
  }
}

final getForecastProvider =
    FutureProvider.family.autoDispose<List<ForecastPoint>, int>((ref, horizon) {
  final repository = ref.watch(financeRepositoryProvider);
  final engine = ref.watch(predictiveEngineProvider);
  final useCase = GetForecastUseCase(repository, engine);
  return useCase(horizon);
});
