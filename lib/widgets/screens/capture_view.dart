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
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: _buildCameraPreview),
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
                  //https://stackoverflow.com/questions/66185696/how-to-convert-a-xfile-to-file-in-flutter
                  await _initializeControllerFuture;
                  XFile f = await _controller.stopVideoRecording();
                  if(mounted) {
                    showDialog(context: context, barrierDismissible: false, builder: (_) {
                      return SimpleDialog(
                        title: const Text("Sauvegarde en mémoire", textAlign: TextAlign.center,),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: SizedBox(width: 50, child: LinearProgressIndicator(color: primaryColor, backgroundColor: discreetText,)),
                              ),
                              Text("Veuillez patienter")
                            ],
                          )
                        ],

                      );
                    });
                  }

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
          ]),
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
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}
