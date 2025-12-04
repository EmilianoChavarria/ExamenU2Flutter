import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _lastTitle = 'Sin notificaciones';
  String _lastBody = '';
  String _token = 'Obteniendo token...';

  @override
  void initState() {
    super.initState();

    _getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (notification != null) {
        setState(() {
          _lastTitle = notification.title ?? 'Sin título';
          _lastBody = notification.body ?? 'Sin contenido';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notificación: ${notification.title ?? 'Sin título'}',
            ),
            backgroundColor: Colors.deepPurple.shade400,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  }

  Future<void> _getToken() async {
    try {
      NotificationSettings settings = await FirebaseMessaging.instance
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      print('Permission status: ${settings.authorizationStatus}');
      String? token = await FirebaseMessaging.instance.getToken();

      setState(() {
        _token = token ?? 'No se pudo obtener el token';
      });

      print('Token FCM: $token');
    } catch (e) {
      setState(() {
        _token = 'Error al obtener token: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Colors.deepPurple;
    final secondary = Colors.blue.shade600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 1,
        title: const Text(
          'Notificaciones',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Última notificación:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primary.shade700,
              ),
            ),
            const SizedBox(height: 16),

            // ---------- CARD DE NOTIFICACIÓN ----------
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Título',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_lastTitle, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 18),
                      Text(
                        'Contenido',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _lastBody.isEmpty ? 'Sin contenido' : _lastBody,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ---------- TOKEN ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Token FCM',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(_token, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _getToken,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Actualizar Token'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
