import 'dart:async';

class NameValidator {
  final StreamTransformer<String,String> validateName =
  StreamTransformer<String,String>.fromHandlers(handleData: (name, sink){

    if (name.isEmpty){
      sink.addError('Enter a valid name.');
    } else {
      sink.add(name);
    }
  });
}