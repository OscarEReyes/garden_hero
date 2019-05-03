import 'package:garden_hero/blocs/bloc_provider.dart';
import 'package:garden_hero/validators/description_validator.dart';
import 'package:garden_hero/validators/name_validator.dart';
import 'package:rxdart/rxdart.dart';


class NewGardenBloc extends Object with NameValidator, DescriptionValidator implements BlocBase {
  String _type;
  String get outType => _type;

  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _descriptionController = BehaviorSubject<String>();

  //  Inputs
  Function(String) get onNameChanged => _nameController.sink.add;
  Function(String) get onDescriptionChanged => _descriptionController.sink.add;

  // Validators
  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get description => _descriptionController.stream.transform(validateName);

  // Confirm button
  Stream<bool> get fieldValid => Observable.combineLatest2(
      name,
      description,
          (n, t) {
        _type = t;
        return true;
      }

  );

  @override
  void dispose() {
//    _nameController?.close();
//    _descriptionController?.close();
  }
}