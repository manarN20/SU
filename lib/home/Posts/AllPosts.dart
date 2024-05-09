import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:su_project/config/config.dart';
import 'package:su_project/home/Posts/commentsPage.dart';
import 'package:su_project/home/Posts/uploadPost.dart';

class AllPosts extends StatefulWidget {
  const AllPosts({Key? key}) : super(key: key);

  @override
  State<AllPosts> createState() => _AllPostsState();
}

List<String> filterOptions = ['University', 'Course', 'Level'];

class _AllPostsState extends State<AllPosts> {
  String? selectedFilter = filterOptions.first;

  Stream<QuerySnapshot> getFilteredPosts() {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection('posts');
    if (selectedFilter != null) {
      query = query.where("uploadedFor", isEqualTo: selectedFilter);
    }
    return query.snapshots();
  }

  void selectFilter(String filter) {
    setState(() {
      if (selectedFilter == filter) {
        selectedFilter =
            null; // Toggle off filter if the same filter is clicked again
      } else {
        selectedFilter = filter;
      }
    });
  }

  Future<void> _incrementLikes(String postId, int currentLikes) async {
    await FirebaseFirestore.instance.collection("posts").doc(postId).update({
      "likesCount": FieldValue.increment(1),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Posts"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () =>
                  setState(() => selectedFilter = null)), // Clear filters
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                    width: (MediaQuery.of(context).size.width -
                            filterOptions.length * 100) /
                        2), // Calculate based on your chip width
                ...filterOptions
                    .map((option) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(option),
                            selected: selectedFilter == option,
                            onSelected: (_) => selectFilter(option),
                            selectedColor: SU.backgroundColor,
                            labelStyle: TextStyle(
                              color: selectedFilter == option
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ))
                    .toList(),
                SizedBox(
                    width: (MediaQuery.of(context).size.width -
                            filterOptions.length * 100) /
                        2), // Symmetric trailing space
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: StreamBuilder<QuerySnapshot>(
                stream: getFilteredPosts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> post =
                          document.data()! as Map<String, dynamic>;
                      return buildPostCard(post, context, document.id);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const UploadPost())),
        child: const Icon(
          Icons.add,
          color: SU.backGroundContainerColor,
        ),
        backgroundColor: SU.backgroundColor,
      ),
    );
  }

  Widget buildPostCard(
      Map<String, dynamic> post, BuildContext context, String documentId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['imageUrl'] != null && post['imageUrl'] != "")
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(post['imageUrl'], fit: BoxFit.cover),
              ),
            const SizedBox(height: 10),
            Text(
              post['postTitle'] ?? 'Untitled',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              post['postDescription'] ?? 'No Description',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () =>
                      _incrementLikes(documentId, post['likesCount'] ?? 0),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border, color: Colors.red),
                      Text(" ${post['likesCount'] ?? 0}"),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CommentsPage(postId: documentId)));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.comment, color: Colors.blue),
                      Text(" Comment"),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
