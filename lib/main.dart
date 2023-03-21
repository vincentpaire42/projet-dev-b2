import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Connexion.dart';
import 'Inscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Flutter Firebase',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase'),
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context){
                return const  InscriptionPage();
              },)
            );
          }
          ,
        ),
      ),

      body: MoviesInformation(),
    );
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({Key? key}) : super(key: key);
  @override
  _MoviesInformationState createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final Stream<QuerySnapshot> userstream =
      FirebaseFirestore.instance.collection('user').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: userstream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> user =
                document.data()! as Map<String, dynamic>;
            String? name = user['name'];
            if (name == null) {
              return const SizedBox.shrink();
            }
            return ListTile(
              title: Text(name),
              
            );
          }).toList(),
        );
      },
    );
  }
}
