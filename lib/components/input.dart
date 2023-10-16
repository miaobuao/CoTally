import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';

final Counter = defineFC((props) {
  final (counter, setCounter) = useState(0);
  return ElevatedButton(
      onPressed: () {
        setCounter(counter + 1);
      },
      child: Text("$counter"));
});
