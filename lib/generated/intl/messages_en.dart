// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(name) => "${name} cannot be empty";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "abort": MessageLookupByLibrary.simpleMessage("Abort"),
        "accessToken": MessageLookupByLibrary.simpleMessage("Access Token"),
        "appName": MessageLookupByLibrary.simpleMessage("CoTally"),
        "authenticationFailed":
            MessageLookupByLibrary.simpleMessage("Authentication failed"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cannotBeEmpty": m0,
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Confirm Deletion?"),
        "create": MessageLookupByLibrary.simpleMessage("Create"),
        "createBook": MessageLookupByLibrary.simpleMessage("Create Book"),
        "detail": MessageLookupByLibrary.simpleMessage("detail"),
        "done": MessageLookupByLibrary.simpleMessage("Done"),
        "empty": MessageLookupByLibrary.simpleMessage("Empty"),
        "encryptionSettings":
            MessageLookupByLibrary.simpleMessage("Encryption Settings"),
        "enterPwd": MessageLookupByLibrary.simpleMessage("Enter password"),
        "enterPwdAgain":
            MessageLookupByLibrary.simpleMessage("Enter password again"),
        "failed": MessageLookupByLibrary.simpleMessage("Operation Failed"),
        "goOn": MessageLookupByLibrary.simpleMessage("Go on"),
        "loading": MessageLookupByLibrary.simpleMessage("loading"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "public": MessageLookupByLibrary.simpleMessage("Public"),
        "reconfirm": MessageLookupByLibrary.simpleMessage("Reconfirm"),
        "removeCompletely":
            MessageLookupByLibrary.simpleMessage("Completely Delete"),
        "removeLocal": MessageLookupByLibrary.simpleMessage("Remove Local"),
        "reset": MessageLookupByLibrary.simpleMessage("Reset"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "summary": MessageLookupByLibrary.simpleMessage("Summary"),
        "twoPwdDifferent": MessageLookupByLibrary.simpleMessage(
            "The two passwords entered are different"),
        "user": MessageLookupByLibrary.simpleMessage("User"),
        "verify": MessageLookupByLibrary.simpleMessage("Verify"),
        "wrongAccessToken":
            MessageLookupByLibrary.simpleMessage("Wrong Access Token")
      };
}
