import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens/recording/recorder_state.dart';
import 'package:figure_skating_jumps/enums/models/season.dart';
import 'package:figure_skating_jumps/interfaces/i_recorder_state_subscriber.dart';
import 'package:figure_skating_jumps/models/local_db/global_settings.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/services/external_storage_service.dart';
import 'package:figure_skating_jumps/services/local_db/global_settings_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_recording_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/dialogs/capture/analysis_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/capture/capture_error_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/capture/device_not_ready_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/capture/no_camera_recording_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/capture/export_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/capture/start_recording_dialog.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet_topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as developer;

class CaptureView extends StatefulWidget {
  const CaptureView({
    Key? key,
  }) : super(key: key);

  @override
  State<CaptureView> createState() => _CaptureViewState();
}

class _CaptureViewState extends State<CaptureView>
    implements IRecorderSubscriber {
  bool _cameraInError = false;
  final XSensDotRecordingService _xSensDotRecordingService =
      XSensDotRecordingService();
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  RecorderState _lastState = RecorderState.idle;
  bool _isFullscreen = false;
  bool _isCameraActivated = true;
  Season _selectedSeason = GlobalSettingsManager().settings?.season ??
      XSensDotRecordingService.season;

  @override
  void initState() {
    _lastState = _xSensDotRecordingService.subscribe(this);
    _controller = CameraController(
      enableAudio: false,
      CameraService().rearCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _xSensDotRecordingService.unsubscribe(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        bool canPop =
            _xSensDotRecordingService.recorderState == RecorderState.idle ||
                _xSensDotRecordingService.recorderState == RecorderState.full;
        return Future<bool>.value(canPop);
      },
      child: _isFullscreen
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
                      Center(
                        child: IceButton(
                          onPressed: () async {
                            await _onCaptureStopPressed();
                          },
                          text: stopCaptureButton,
                          textColor: primaryColor,
                          color: primaryColor,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.medium,
                        ),
                      ),
                    ],
                  )
                ],
              );
            })
          : Scaffold(
              appBar: ReactiveLayoutHelper.isTablet()
                  ? const TabletTopbar(isUserDebuggingFeature: false)
                      as PreferredSizeWidget
                  : const Topbar(isUserDebuggingFeature: false),
              drawerEnableOpenDragGesture: false,
              drawerScrimColor: Colors.transparent,
              drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
              body: Builder(builder: (context) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          ReactiveLayoutHelper.getWidthFromFactor(24, true),
                      vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PageTitle(text: captureViewStartLabel),
                        Padding(
                          padding: EdgeInsets.only(
                              top:
                                  ReactiveLayoutHelper.getHeightFromFactor(20)),
                          child: const InstructionPrompt(
                              captureViewInfo, secondaryColor),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  ReactiveLayoutHelper.getHeightFromFactor(20)),
                          child: const InstructionPrompt(
                              captureViewCameraInfo, secondaryColor),
                        ),
                        Expanded(
                            child: _isCameraActivated && !_cameraInError
                                ? FutureBuilder<void>(
                                    future: _initializeControllerFuture,
                                    builder: _buildCameraPreview)
                                : _noCameraIcon()),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                captureViewCameraSwitchLabel,
                                style: TextStyle(
                                    fontSize: ReactiveLayoutHelper
                                        .getHeightFromFactor(16)),
                              ),
                              Switch(
                                  value: _isCameraActivated,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCameraActivated = val;
                                    });
                                  })
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right:
                                        ReactiveLayoutHelper.getWidthFromFactor(
                                            8)),
                                child: Text(selectSeasonLabel,
                                    style: TextStyle(
                                        fontSize: ReactiveLayoutHelper
                                            .getHeightFromFactor(16))),
                              ),
                              DropdownButton<Season>(
                                  selectedItemBuilder: (context) {
                                    return Season.values
                                        .map<Widget>((Season item) {
                                      // This is the widget that will be shown when you select an item.
                                      // Here custom text style, alignment and layout size can be applied
                                      // to selected item string.
                                      return Container(
                                        constraints: BoxConstraints(
                                            minWidth: ReactiveLayoutHelper
                                                .getWidthFromFactor(80)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.displayedString,
                                              style: TextStyle(
                                                  fontSize: ReactiveLayoutHelper
                                                      .getHeightFromFactor(16),
                                                  color: darkText,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList();
                                  },
                                  value: _selectedSeason,
                                  menuMaxHeight:
                                      ReactiveLayoutHelper.getWidthFromFactor(
                                          300),
                                  items: List.generate(Season.values.length,
                                      (index) {
                                    return DropdownMenuItem<Season>(
                                      value: Season.values[index],
                                      child: Text(
                                        Season.values[index].displayedString,
                                        style: TextStyle(
                                            fontSize: ReactiveLayoutHelper
                                                .getHeightFromFactor(16)),
                                      ),
                                    );
                                  }),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedSeason = val!;
                                      GlobalSettingsManager().saveSettings(
                                          GlobalSettings(
                                              season: _selectedSeason));
                                      XSensDotRecordingService.season =
                                          _selectedSeason;
                                    });
                                  }),
                            ]),
                        Padding(
                          padding: EdgeInsets.only(
                              top: ReactiveLayoutHelper.getHeightFromFactor(8)),
                          child: Center(
                            child: IceButton(
                              onPressed: () async {
                                await _onCaptureStartPressed();
                              },
                              text: captureViewStartLabel,
                              textColor: primaryColor,
                              color: primaryColor,
                              iceButtonImportance:
                                  IceButtonImportance.secondaryAction,
                              iceButtonSize: IceButtonSize.medium,
                            ),
                          ),
                        ),
                      ]),
                );
              }),
            ),
    );
  }

  Future<void> _onCaptureStopPressed() async {
    try {
      _displayStepDialog(const ExportDialog());
      await _initializeControllerFuture;
      String videoPath = "";
      if (_isCameraActivated) {
        XFile f = await _controller.stopVideoRecording();
        videoPath = await ExternalStorageService().saveVideo(f);
      }
      await _xSensDotRecordingService.stopRecording(
          _isCameraActivated, videoPath);
    } catch (e) {
      developer.log(e.toString());
    }
    setState(() {
      _isFullscreen = false;
    });
  }

  Future<void> _onCaptureStartPressed() async {
    if (!XSensDotConnectionService().isInitialized) {
      await _displayStepDialog(const DeviceNotReadyDialog());
      return;
    }

    try {
      await _initializeControllerFuture;
      await _xSensDotRecordingService.startRecording();
      _displayStepDialog(const StartRecordingDialog()).then((_) async {
        if (_xSensDotRecordingService.recorderState !=
            RecorderState.recording) {
          return;
        }

        if (!_isCameraActivated) {
          _displayStepDialog(NoCameraRecordingDialog())
              .then((value) async {
            await _onCaptureStopPressed();
          });
          return;
        }

        setState(() {
          _isFullscreen = true;
        });
        await _controller.startVideoRecording();
      });
    } catch (e) {
      developer.log(e.toString());
    }
  }

  Widget _buildCameraPreview(
      BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      try {
        Size screenSize = MediaQuery.of(context).size;
        double cameraHeight = screenSize.height;
        double cameraWidth = screenSize.height / _controller.value.aspectRatio;

        if (cameraWidth > screenSize.width) {
          cameraWidth = screenSize.width;
          cameraHeight = screenSize.width * _controller.value.aspectRatio;
        }

        if (!_isFullscreen) {
          double cameraScalingFactor =
              ReactiveLayoutHelper.getCameraScalingFactor(
                  width: cameraWidth, height: cameraHeight);
          //Reduce size to let place for other UI elements=
          cameraWidth = cameraWidth / (cameraScalingFactor);
          cameraHeight = cameraHeight / (cameraScalingFactor);
        }

        return Center(
          child: SizedBox(
            width: cameraWidth,
            height: cameraHeight,
            child: _controller.buildPreview(),
          ),
        );
      } catch (e) {
        _cameraInError = true;
        return _noCameraIcon();
      }
    }
    return const Center(child: CircularProgressIndicator());
  }

  Future<void> _displayStepDialog(Widget dialog) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return dialog;
        });
  }

  Widget _noCameraIcon() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.no_photography_outlined, size: 56),
        if (_cameraInError)
          Text(
            missingPermsCameraInfo,
            style: TextStyle(
                fontSize: ReactiveLayoutHelper.getHeightFromFactor(14)),
          )
      ],
    ));
  }

  @override
  void onStateChange(RecorderState state) {
    if (state == RecorderState.error) {
      Navigator.of(context, rootNavigator: true).pop();
      _displayStepDialog(const CaptureErrorDialog());
      _lastState = state;
      return;
    }

    if (state == RecorderState.analyzing) {
      Navigator.of(context, rootNavigator: true).pop();
      _displayStepDialog(const AnalysisDialog());
    }

    if (_lastState == RecorderState.analyzing) {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushNamed(context, '/EditAnalysis',
          arguments: _xSensDotRecordingService.currentCapture);
    }

    _lastState = state;
  }
}
