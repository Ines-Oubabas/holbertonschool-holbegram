import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../home.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> selectImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> uploadPost() async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final NavigatorState navigator = Navigator.of(context);
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    if (_image == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
        ),
      );
      return;
    }

    if (userProvider.getUser == null) {
      await userProvider.refreshUser();
    }

    final user = userProvider.getUser;

    if (user == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('User not found'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final String res = await PostStorage().uploadPost(
      _captionController.text.trim(),
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (res == 'ok') {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Post Added'),
        ),
      );

      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Image',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : uploadPost,
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontFamily: 'Billabong',
                        fontSize: 38,
                        color: _isLoading
                            ? Colors.grey
                            : const Color.fromARGB(218, 226, 37, 24),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Add Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Choose an image from your gallery or take a one.',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _captionController,
                decoration: const InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 205,
                  height: 205,
                  color: const Color.fromARGB(255, 240, 240, 240),
                  child: _image != null
                      ? Image.memory(
                          _image!,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          'https://cdn.pixabay.com/photo/2017/11/10/05/24/add-2935429_960_720.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 100,
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: selectImageFromGallery,
                    icon: const Icon(
                      Icons.image,
                      size: 34,
                      color: Color.fromARGB(218, 226, 37, 24),
                    ),
                  ),
                  const SizedBox(width: 18),
                  IconButton(
                    onPressed: selectImageFromCamera,
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 34,
                      color: Color.fromARGB(218, 226, 37, 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}