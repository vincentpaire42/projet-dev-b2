import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projet_dev_b2/authentication_service.dart';
import 'package:projet_dev_b2/nav_bar.dart';
import 'package:projet_dev_b2/post.dart';
import 'package:projet_dev_b2/post_detail_page.dart';

import 'CreatePostPage.dart';

class HomePage extends StatelessWidget {
  Stream<List<Post>> getPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Post> posts = [];

      for (var postSnapshot in snapshot.docs) {
        Map<String, dynamic> postData =
            postSnapshot.data() as Map<String, dynamic>;

        // Récupérer les informations de l'auteur
        DocumentSnapshot authorSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(postData['authorId'])
            .get();
        Map<String, dynamic> authorData =
            authorSnapshot.data() as Map<String, dynamic>;

        posts.add(
          Post(
            id: postSnapshot.id,
            title: postData['title'],
            description: postData['description'],
            authorFirstName: authorData['first_name'],
            authorLastNameInitial: authorData['last_name']
                [0], // Prendre la première lettre du nom de famille
          ),
        );
      }

      return posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
            await context.read<AuthenticationService>().signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, '/sign-in', (Route<dynamic> route) => false);
          },
          ),
        ],
      ),
      body: StreamBuilder<List<Post>>(
        stream: getPosts(),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              Post post = snapshot.data![index];
              return ListTile(
                title: Text(
                    '${post.authorFirstName} ${post.authorLastNameInitial}.'),
                subtitle: Text('${post.title} '
                    '${post.description}'),
                // Afficher les informations de l'auteur
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(post: post),
                    ),
                  );
                },
                // Ajoutez le bouton de suppression pour l'administrateur
                trailing: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(context
                          .read<AuthenticationService>()
                          .getCurrentUser()
                          ?.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.hasError) {
                      return Text("Erreur: ${userSnapshot.error}");
                    }

                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    Map<String, dynamic>? userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;
                    bool isAdmin = userData != null &&
                        userData.containsKey('isAdmin') &&
                        userData['isAdmin'];
                    return isAdmin
                        ? IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(post.id)
                                  .delete();
                            },
                          )
                        : SizedBox.shrink();
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostPage()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Créer un post',
      ),
    );
  }
}
