import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/services/external_storage_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';
import '../../constants/lang_fr.dart';
import '../layout/scaffold/ice_drawer_menu.dart';
import '../layout/scaffold/topbar.dart';
import 'dart:developer' as developer;

import '../titles/page_title.dart';

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
      ResolutionPreset.high,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(text: captureViewTitle),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: InstructionPrompt(captureViewInstructions, secondaryColor),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: InstructionPrompt(captureViewCameraInstruction, secondaryColor),
              ),
              FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: _buildCameraPreview),
              Center(
                child: IceButton(
                  onPressed: () async {
                    // TODO: ADD when eventchannels are merged displayWaitingDialog("Démarrage...");
                    try {
                      await _initializeControllerFuture;
                      await _controller.startVideoRecording();
                    } catch (e) {
                      developer.log(e.toString());
                    }
                    if (mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  },
                  text: captureViewStart,
                  textColor: primaryColor,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.secondaryAction,
                  iceButtonSize: IceButtonSize.medium,
                ),
              ),
              /*IceButton(
                onPressed: () async {
                  try {
                    await _initializeControllerFuture;
                    XFile f = await _controller.stopVideoRecording();
                    if (mounted) {
                      displayWaitingDialog(pleaseWait);
                      await ExternalStorageService().saveVideo(
                          f); // TODO: Save to localDataBase. and eventually Firebase?
                    }
                    if (mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  } catch (e) {
                    developer.log(e.toString());
                    if (mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  }
                },
                text: "Stop la capture d'acquisition",
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.medium,
              )*/
            ]),
      ),
    );
  }

  Widget _buildCameraPreview(
      BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      Size screenSize = MediaQuery.of(context).size;
      double cameraHeight = screenSize.height;
      double cameraWidth = screenSize.height / _controller.value.aspectRatio;

      if (cameraWidth > screenSize.width) {
        cameraWidth = screenSize.width;
        cameraHeight = screenSize.width * _controller.value.aspectRatio;
      }
      //Reduce size to let place for other UI elements
      cameraWidth /= 2;
      cameraHeight /= 2;

      return Center(
        child: SizedBox(
          width: cameraWidth,
          height: cameraHeight,
          child: _controller.buildPreview(),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  void displayWaitingDialog(String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return SimpleDialog(
            title: Text(
              message,
              textAlign: TextAlign.center,
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                        width: 50,
                        child: LinearProgressIndicator(
                          color: primaryColor,
                          backgroundColor: discreetText,
                        )),
                  ),
                  Text(pleaseWait)
                ],
              )
            ],
          );
        });
  }
}
