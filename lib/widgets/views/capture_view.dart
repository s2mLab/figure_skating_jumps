import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/services/external_storage_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _isFullscreen = false;

  @override
  void initState() {
    _controller = CameraController(
      enableAudio: false,
      CameraService().rearCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();

    _resetOrientation();

    super.initState();
  }

  @override
  void dispose() {
    _resetOrientation();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isFullscreen
        ? Builder(builder: (context) {
            return Stack(
              children: [
                FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: _buildCameraPreview),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IceButton(
                      onPressed: () async {
                        try {
                          await _initializeControllerFuture;
                          XFile f = await _controller.stopVideoRecording();
                          if (mounted) {
                            _displayWaitingDialog(pleaseWait);
                            await ExternalStorageService().saveVideo(
                                f); // TODO: Save to localDataBase. and eventually Firebase?
                            _resetOrientation();
                          }
                        } catch (e) {
                          developer.log(e.toString());
                        }
                        if (mounted) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                        setState(() {
                          _isFullscreen = false;
                        });
                      },
                      text: "Stop la capture d'acquisition",
                      textColor: primaryColor,
                      color: primaryColor,
                      iceButtonImportance: IceButtonImportance.secondaryAction,
                      iceButtonSize: IceButtonSize.medium,
                    ),
                  ],
                )
              ],
            );
          })
        : Scaffold(
            appBar: const Topbar(isUserDebuggingFeature: false),
            drawerEnableOpenDragGesture: false,
            drawerScrimColor: Colors.transparent,
            drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
            body: Builder(builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageTitle(text: captureViewTitle),
                      const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: InstructionPrompt(
                            captureViewInstructions, secondaryColor),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: InstructionPrompt(
                            captureViewCameraInstruction, secondaryColor),
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
                              _displayWaitingDialog("Démarrage...");
                              await _controller.startVideoRecording();
                            } catch (e) {
                              developer.log(e.toString());
                            }
                            if (mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                            setState(() {
                              _isFullscreen = true;
                            });
                          },
                          text: captureViewStart,
                          textColor: primaryColor,
                          color: primaryColor,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.medium,
                        ),
                      ),
                    ]),
              );
            }),
          );
  }

  Widget _buildCameraPreview(
      BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if(_isFullscreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
        _controller.unlockCaptureOrientation();
      }
      Size screenSize = MediaQuery.of(context).size;
      double cameraHeight = screenSize.height;
      double cameraWidth = screenSize.height / _controller.value.aspectRatio;

      if (cameraWidth > screenSize.width) {
        cameraWidth = screenSize.width;
        cameraHeight = screenSize.width * _controller.value.aspectRatio;
      }
      if (!_isFullscreen) {
        //Reduce size to let place for other UI elements
        cameraWidth /= 2;
        cameraHeight /= 2;
      }

      return Center(
        child: SizedBox(
          width: _isFullscreen ? screenSize.width : cameraWidth,
          height:  _isFullscreen ? screenSize.height : cameraHeight,
          child: _controller.buildPreview(),
        ),
      );
    }
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _resetOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _displayWaitingDialog(String message) {
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
