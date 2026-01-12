import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_item.freezed.dart';

enum AlertType { bill, risk, save }

@freezed
class AlertItem with _$AlertItem {
  const factory AlertItem({
    required String id,
    required AlertType type,
    required String title,
    required String detail,
    required DateTime date,
    @Default(false) bool read,
  }) = _AlertItem;
}
