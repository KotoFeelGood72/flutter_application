import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadStatus extends StatelessWidget {
  final UploadTask task;

  const UploadStatus({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentage = (progress * 100).toStringAsFixed(2);

          return Center(
            child: Container(
              width: 200,
              height: 100,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color.fromARGB(143, 208, 212, 241),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(value: progress),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
