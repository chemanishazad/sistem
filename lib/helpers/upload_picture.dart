// import 'package:amplify_flutter/amplify_flutter.dart';

// Future<void> uploadPicture() async {
//   const dataString = 'Example file contents';

//   try {
//     final result = await Amplify.Storage.uploadFile
//     (
//       data: S3DataPayload.string(dataString),
//       key: 'ExampleKey',
//       onProgress: (progress) {
//         safePrint('Transferred bytes: ${progress.transferredBytes}');
//       },
//     ).result;

//     safePrint('Uploaded data to location: ${result.uploadedItem.key}');
//   } on StorageException catch (e) {
//     safePrint(e.message);
//   }
// }