import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/topbar.dart';

class CaptureView extends StatefulWidget {
  const CaptureView({
    Key? key,
  }) : super(key: key);

  @override
  State<CaptureView> createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    _controller = CameraController(
      CameraService().rearCamera,
      ResolutionPreset.ultraHigh,
    );
    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(
              _controller,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IceButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        await _controller.startVideoRecording();
                      } catch (e) {
                        print(e);
                      }
                    },
                    text: "Démarrez la capture d'acquisition",
                    textColor: primaryColor,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.medium,
                  ),
                  IceButton(
                    onPressed: () async {
                      try {
                        await _initializeControllerFuture;
                        XFile f = await _controller.stopVideoRecording();
                        f.saveTo("test.mp4");
                      } catch (e) {
                        print(e);
                      }
                    },
                    text: "Stop la capture d'acquisition",
                    textColor: primaryColor,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.medium,
                  )
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        })
      ]),
    );
  }
}
