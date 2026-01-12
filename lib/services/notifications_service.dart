import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsService {
  NotificationsService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;
  static bool _initialized = false;

  static Future<void> ensureInitialized() async {
    if (_initialized) {
      return;
    }

    try {
      tz.initializeTimeZones();
      final plugin = FlutterLocalNotificationsPlugin();
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );

      await plugin.initialize(initializationSettings);
      _instance = NotificationsService(plugin);
    } catch (_) {
      _instance = _NoopNotificationsService();
    } finally {
      _initialized = true;
    }
  }

  static NotificationsService? _instance;

  static NotificationsService get instance {
    if (_instance == null) {
      throw StateError('NotificationsService not initialized');
    }
    return _instance!;
  }

  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> scheduleBillReminder({
    required String id,
    required DateTime dueDate,
    required String title,
    required String body,
  }) async {
    final scheduleDate =
        tz.TZDateTime.from(dueDate.subtract(const Duration(days: 3)), tz.local)
            .add(const Duration(hours: 8));
    await _scheduleWithFallback(
      id: id.hashCode,
      title: title,
      body: body,
      date: scheduleDate,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'bill_reminders',
          'Bill Reminders',
          channelDescription: 'Reminder sebelum tagihan jatuh tempo',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleSafeDay({
    required DateTime date,
    required double amount,
  }) async {
    final scheduleDate =
        tz.TZDateTime.from(date, tz.local).add(const Duration(hours: 8));
    await _scheduleWithFallback(
      id: scheduleDate.hashCode,
      title: 'Safe Day Saving',
      body:
          'Sisihkan ${amount.toStringAsFixed(0)} hari ini untuk mencapai target.',
      date: scheduleDate,
      details: const NotificationDetails(
        android: AndroidNotificationDetails(
          'autosave',
          'Auto Saving',
          channelDescription: 'Pengingat jadwal autosave',
          importance: Importance.high,
        ),
      ),
    );
  }

  Future<void> _scheduleWithFallback({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime date,
    required NotificationDetails details,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        date,
        details,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    } on PlatformException catch (error) {
      final code = error.code.toLowerCase();
      if (code != 'exact_alarms_not_permitted') {
        return;
      }
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          date,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
        );
      } on PlatformException {
        return;
      }
    } catch (_) {
      return;
    }
  }
}

final notificationsServiceProvider = Provider<NotificationsService>((ref) => NotificationsService.instance);

class _NoopNotificationsService extends NotificationsService {
  _NoopNotificationsService() : super(FlutterLocalNotificationsPlugin());

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> scheduleBillReminder({
    required String id,
    required DateTime dueDate,
    required String title,
    required String body,
  }) async {}

  @override
  Future<void> scheduleSafeDay({
    required DateTime date,
    required double amount,
  }) async {}
}
