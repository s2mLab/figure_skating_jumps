import 'package:camera/camera.dart';

class CameraService {
  static final CameraService _cameraService = CameraService._internal();
  static CameraDescription? _rearCamera;
  factory CameraService() {
    return _cameraService;
  }

  CameraService._internal();

  set rearCamera(CameraDescription camera) {
    _rearCamera ??= camera;
  }

  CameraDescription get rearCamera {
    return _rearCamera!;
  }
}