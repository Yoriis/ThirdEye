import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTClientWrapper {
  // Unchanged MQTT code, only replaced with own credentials
  late MqttServerClient _client;
  Function(String)? onMessage;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;
  
  void prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
  }

  Future<void> _connectClient() async {
    try {
      print("Connecting to client...");
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await _client.connect('horus', '@Allcapsyara2');
    } on Exception catch (e) {
      print('Exception: $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      _client.disconnect();
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      print('Client connected successfully!');
    } else {
      print('Client connection failed - disconnecting, state is ${_client.connectionStatus?.state}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      _client.disconnect();
    }
  }

  void _setupMqttClient() {
    _client = MqttServerClient.withPort('6e704fe9f9b14890bb45d7b2c01ef772.s1.eu.hivemq.cloud',
      'horus',
      8883);
    _client.secure = true;
    _client.securityContext = SecurityContext.defaultContext;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
  }

  void subscribe(String topic) {
    print("Subscribing to topic: $topic");
    _client.subscribe(topic, MqttQos.atMostOnce);
    _client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      var message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message:$message from topic: ${c[0].topic}>');

      if (onMessage != null) {
        onMessage!(message);
      }
    });
  }

  void publish(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    print('Publishing message "$message" to topic "$topic"');
    _client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
  }

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.CONNECTED; 
    print("Client connection successful.");
  }

  void _onDisconnected() {
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
    print("Client disconnected.");
  }
}

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState {
  IDLE,
  SUBSCRIBED,
}