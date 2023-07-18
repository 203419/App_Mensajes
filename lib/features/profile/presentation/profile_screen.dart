import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_auth/features/profile/domain/entities/user.dart';
import 'package:app_auth/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/update_user_usecase.dart';

import 'package:app_auth/features/profile/domain/usecases/upload_image_usecase.dart';

class UserProfileScreen extends StatefulWidget {
  final String userId;

  UserProfileScreen({
    required this.userId,
  });

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String newImageUrl;
  late String newUsername;
  final TextEditingController usernameController = TextEditingController();

  void _selectProfileImage() async {
    final uploadProfileImageUseCase =
        Provider.of<UploadProfileImageUseCase>(context, listen: false);
    try {
      newImageUrl = await uploadProfileImageUseCase.call(widget.userId);
    } catch (e) {
      // Handle error...
    }
  }

  void _updateUserProfile() async {
    final updateUserUseCase =
        Provider.of<UpdateUserUseCase>(context, listen: false);
    newUsername = usernameController.text;
    await updateUserUseCase.call(
      widget.userId,
      UserProfile(
        imageProfileUrl: newImageUrl,
        username: newUsername,
        userId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final getUserUseCase = Provider.of<GetUserUseCase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Color(0xFF3A4E62),
      ),
      body: StreamBuilder<UserProfile>(
        stream: getUserUseCase.call(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            // imprimir error snapshot.hasData
            print('la data es: ${snapshot.hasData}');
            return Center(child: Text('No data'));
          } else {
            final user = snapshot.data!;

            newImageUrl = user.imageProfileUrl;
            newUsername = user.username;
            usernameController.text = newUsername;

            return Container(
              color: Color(0xFF2C3C4D),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  InkWell(
                    onTap: _selectProfileImage,
                    child: Container(
                      width: 165,
                      height: 165,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            newImageUrl.isEmpty
                                ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                                : newImageUrl,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(newUsername.isEmpty ? 'No username' : newUsername,
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  // sisebox
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'New username',
                        labelStyle: TextStyle(color: Colors.grey),
                      ),
                      // color: Colors.white,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _updateUserProfile,
                    child: Text('Update',
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
