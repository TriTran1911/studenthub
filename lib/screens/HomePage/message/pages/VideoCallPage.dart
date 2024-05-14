import 'package:flutter/material.dart';
import 'package:studenthub/components/chatController.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({Key? key}) : super(key: key);
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  String conferenceID = 'conference_id';

  Future<void> checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        // The user did not grant the permission
        print('Permission Denied');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Camera Permission'),
              content: Text(
                  'This app needs camera permission to function. Please grant the permission in your settings.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkCameraPermission(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: ZegoUIKitPrebuiltVideoConference(
              appID: AppID,
              appSign: AppSign,
              userID: '123456',
              userName: 'Siuuuuu',
              conferenceID: conferenceID,
              config: ZegoUIKitPrebuiltVideoConferenceConfig(),
            ),
          );
        } else {
          // The Future is still running, show a loading spinner
          return CircularProgressIndicator();
        }
      },
    );
  }
}
