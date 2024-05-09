import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as DateFormatting;
import 'package:su_project/config/config.dart';
import 'package:su_project/widgets/customTextFieldRegsiterPage.dart';
import 'package:su_project/widgets/errorDialog.dart';
import 'package:su_project/widgets/loadingDialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadPost extends StatefulWidget {
  const UploadPost({Key? key}) : super(key: key);

  @override
  State<UploadPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  TextEditingController _postTitle = TextEditingController();
  TextEditingController _postDescription = TextEditingController();
  TextEditingController _level = TextEditingController();
  TextEditingController _colleges = TextEditingController();
  File? _image;
  File? _video;
  bool _uploadImage = false;
  bool _uploadVideo = false;
  String? _selectedFilter;
  List<String> filterOptions = ['University', 'Course', 'Level'];
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    callingTheData();
  }

  callingTheData() async {
    String? currentUser = SU.firebaseAuth?.currentUser?.uid;
    await SU.firestore?.collection("users").doc(currentUser).get().then(
      (results) {
        _colleges.text = results['College'];
        _level.text = results['Level'];
      },
    );
    print(_colleges.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Post & Note",
                  style: TextStyle(
                    color: SU.primaryColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: TextStyle(
                          color: SU.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      customTextFieldRegsiterPage(
                        isSecure: false,
                        enabledEdit: true,
                        textEditingController: _postTitle,
                        textInputType: TextInputType.text,
                        hint: "School Campus",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Description",
                        style: TextStyle(
                          color: SU.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: SU.backgroundColor,
                            width: 1.0,
                          ),
                        ),
                        child: TextField(
                          controller: _postDescription,
                          maxLines: 8,
                          decoration: InputDecoration(
                            hintText: "My Parking has a problem",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: SU.backgroundColor, width: 1.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                  color: SU.primaryColor, width: 1.0),
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 16,
                              top: 8,
                              bottom: 8,
                              right: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: SU.backgroundColor,
                            width: 1.0,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          hint: const Text("Select Type"),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue;
                            });
                          },
                          items: filterOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Checkbox(
                            value: _uploadImage,
                            onChanged: (value) {
                              setState(() {
                                _uploadImage = value!;
                                if (value) _uploadVideo = false;
                              });
                            },
                          ),
                          const Text('Upload Image'),
                          const SizedBox(width: 20),
                          Checkbox(
                            value: _uploadVideo,
                            onChanged: (value) {
                              setState(() {
                                _uploadVideo = value!;
                                if (value) _uploadImage = false;
                              });
                            },
                          ),
                          const Text('Upload Video'),
                        ],
                      ),
                      if (_uploadImage)
                        ElevatedButton(
                          onPressed: pickImage,
                          child: const Text('Choose Image'),
                        ),
                      if (_uploadVideo)
                        ElevatedButton(
                          onPressed: pickVideo,
                          child: const Text('Choose Video'),
                        ),
                      if (_image != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Image.file(
                            _image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      if (_video != null)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.video_library,
                            size: 200,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(SU.primaryColor),
                          ),
                          onPressed: savePost,
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
    }
  }

  Future<void> savePost() async {
    if (_postDescription.text.isNotEmpty && _postTitle.text.isNotEmpty) {
      uploadData();
    } else {
      displayDialog("Please fill in all the fields.");
    }
  }

  void displayDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        return ErrorDialogCustom(message: message);
      },
    );
  }

  Future<void> uploadData() async {
    String? currentUser = SU.firebaseAuth?.currentUser?.uid;

    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialogCustom(
            message: "Uploading Post Please Wait...");
      },
    );

    String imageUrl = '';
    String videoUrl = '';

    if (_uploadImage && _image != null) {
      imageUrl = await uploadFileToFirebaseStorage(_image!, 'images');
    }

    if (_uploadVideo && _video != null) {
      videoUrl = await uploadFileToFirebaseStorage(_video!, 'videos');
    }

    await SU.firestore!.collection("posts").add({
      "uploadedBy": currentUser,
      "postTitle": _postTitle.text.trim(),
      "postDescription": _postDescription.text.trim().toLowerCase(),
      "uploadedOn": DateFormatting.DateFormat('dd-MM-yyyy')
          .format(DateTime.now())
          .toString(),
      "likesCount": 0,
      'College': _colleges.text.trim(),
      'Level': _level.text.trim(),
      "imageUrl": imageUrl,
      "videoUrl": videoUrl,
      "uploadedFor": _selectedFilter // Save the selected filter option
    }).then((value) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post was uploaded successfully'),
        ),
      );
      clearPostFields();
    });
  }

  void clearPostFields() {
    setState(() {
      _postTitle.clear();
      _postDescription.clear();
      _image = null;
      _video = null;
      _uploadImage = false;
      _uploadVideo = false;
    });
  }

  Future<String> uploadFileToFirebaseStorage(
      File file, String folderPath) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('$folderPath/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }
}
