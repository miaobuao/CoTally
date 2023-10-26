class EventBus {
  final Map<dynamic, List<Function>> listener = {};

  void listen(dynamic event, Function call) {
    if (listener.containsKey(event)) {
      listener[event]!.add(call);
    } else {
      listener[event] = [call];
    }
  }

  void emit(dynamic event) {
    if (listener.containsKey(event)) {
      for (var element in listener[event]!) {
        element();
      }
    }
  }
}
