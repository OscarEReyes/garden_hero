import 'dart:async';

class DescriptionValidator {
  final StreamTransformer<String,String> validateDescription =
  StreamTransformer<String,String>.fromHandlers(handleData: (description, sink){

    if (description.isEmpty){
      sink.addError('Enter a valid description that is not empty.');
    } else {
      sink.add(description);
    }
  });
}