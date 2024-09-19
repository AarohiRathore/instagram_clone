import 'package:clone/features/home/presentation/screens/database_manager.dart';
import 'package:flutter/material.dart';

class FirebaseStorageService extends StatefulWidget {
  const FirebaseStorageService({super.key});

  @override
  _FirebaseStorageServiceState createState() => _FirebaseStorageServiceState();
}

class _FirebaseStorageServiceState extends State<FirebaseStorageService> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Image'),
      ),
      body: FutureBuilder(
          future: FireStoreDataBase().getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Image.network(snapshot.data.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}

void main() {
  runApp(FirebaseStorageService());
}
