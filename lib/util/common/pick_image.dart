import 'package:file_picker/file_picker.dart';

Future<FilePickerResult?> pickImage() async {
  final file = await FilePicker.platform.pickFiles(type: FileType.image);
  return file;
}
