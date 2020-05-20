import 'dart:io';
import 'package:cmp/services/APIHelper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  void onSelectFile() async {
    var file = await FilePicker.getFile(type: FileType.audio);
    if (file == null) return;

    var result = await APIHelper.uploadFile(
      'media/upload',
      file,
      onProgress: (bytes, total) {
        print('progress $bytes / $total');
      },
    );

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload'),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('Select File'),
            onPressed: onSelectFile,
          ),
        ),
      ),
    );
  }
}
