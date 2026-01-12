import 'package:freezed_annotation/freezed_annotation.dart';
import '../../core/utils/json_converters.dart';
import '../../domain/entities/alert_item.dart' as domain;

part 'alert_item.freezed.dart';
part 'alert_item.g.dart';

enum AlertItemType { bill, risk, save }

@freezed
class AlertItemModel with _$AlertItemModel {
  const factory AlertItemModel({
    required String id,
    required AlertItemType type,
    required String title,
    required String detail,
    @DateTimeIsoConverter() required DateTime date,
    @Default(false) bool read,
  }) = _AlertItemModel;

  const AlertItemModel._();

  factory AlertItemModel.fromJson(Map<String, dynamic> json) =>
      _$AlertItemModelFromJson(json);

  domain.AlertItem toEntity() => domain.AlertItem(
        id: id,
        type: domain.AlertType.values[type.index],
        title: title,
        detail: detail,
        date: date,
        read: read,
      );

  static AlertItemModel fromEntity(domain.AlertItem entity) => AlertItemModel(
        id: entity.id,
        type: AlertItemType.values[entity.type.index],
        title: entity.title,
        detail: entity.detail,
        date: entity.date,
        read: entity.read,
      );
}
