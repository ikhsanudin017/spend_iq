import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/metas/facade/accounts_read_facade.dart';
import 'accounts_meta_providers.dart';

final accountViewsProvider =
    StreamProvider.autoDispose<List<AccountView>>((ref) {
  final facade = ref.watch(accountsReadFacadeProvider);
  return facade.watchAccountViews();
});

final totalBalanceProvider = Provider.autoDispose<int>((ref) {
  final viewsAsync = ref.watch(accountViewsProvider);
  return viewsAsync.maybeWhen(
    data: (views) => views.fold<int>(0, (sum, v) => sum + v.balance),
    orElse: () => 0,
  );
});



