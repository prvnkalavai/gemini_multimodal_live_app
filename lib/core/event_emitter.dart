// lib/core/event_emitter.dart
class EventEmitter {
  final _listeners = <String, List<Function>>{};

  void on(String event, Function callback) {
    _listeners[event] ??= [];
    _listeners[event]!.add(callback);
  }

  void emit(String event, [dynamic data]) {
    if (_listeners[event] != null) {
      for (var callback in _listeners[event]!) {
        callback(data);
      }
    }
  }

  void off(String event, [Function? callback]) {
    if (callback == null) {
      _listeners.remove(event);
    } else {
      _listeners[event]?.remove(callback);
    }
  }
}