import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(initSettings);

    // Timezone setup for iOS/Android for accurate scheduling
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final result = await ios.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }
    // Android 13+ needs POST_NOTIFICATIONS permission; plugin handles runtime prompt if declared.
    return true;
  }

  Future<void> showNow({int id = 0, String title = 'Recordatorio', String body = '¡Vuelve a tu Pokédex!'}) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'pokedex_daily',
          'Pokedex Notificaciones',
          channelDescription: 'Recordatorios de la Pokédex',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleDaily({
    required int id,
    required TimeOfDay time,
    String title = 'Recordatorio diario',
    String body = 'Explora nuevos Pokémon hoy',
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    final first = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    final scheduled = first.isBefore(now) ? first.add(const Duration(days: 1)) : first;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'pokedex_daily',
          'Pokedex Notificaciones',
          channelDescription: 'Recordatorios de la Pokédex',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repite diariamente a la misma hora
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // TESTING: Schedule notifications every 30 seconds for a limited duration.
  // Note: iOS allows a maximum of 64 pending notifications; we'll cap to that.
  Future<void> scheduleEvery30sTesting({int minutes = 30}) async {
    final now = tz.TZDateTime.now(tz.local);
    int totalCount = (minutes * 60) ~/ 30; // notifications to schedule

    // iOS pending notifications limit
    if (!Platform.isAndroid) {
      totalCount = totalCount.clamp(1, 64);
    }

    for (int i = 0; i < totalCount; i++) {
      final when = now.add(Duration(seconds: 30 * (i + 1)));
      await _plugin.zonedSchedule(
        2000 + i, // testing series ids
        'Recordatorio de prueba',
        'Notificación cada 30 segundos',
        when,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'pokedex_testing',
            'Pokedex Testing',
            channelDescription: 'Notificaciones de prueba cada 30s',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}
