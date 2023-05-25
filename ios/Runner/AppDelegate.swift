import UIKit
import Flutter


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let xSensDotDeviceScanner = XSensDotDeviceScanner()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    FlutterMethodChannel(
      name: "scan-method-channel", 
      binaryMessenger: controller.binaryMessenger
    ).setMethodCallHandler({
        (call, result) -> Void in self.handleScanCalls(call: call, result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    /**
     * Handles the Scan Method channel calls
     *
     * @param call The method to call and its parameters
     * @param result The result to send back to the flutter project
     */
    private func handleScanCalls(call: FlutterMethodCall, result: FlutterResult){
        switch call.method {
        case "startScan": self.xSensDotDeviceScanner.startScan(result: result)
        default: result(FlutterMethodNotImplemented)
    }
}
}

public class XSensDotDeviceScanner: NSObject {
   /**
     * Starts a XSens Dot bluetooth scan
     */
    public func startScan(result: FlutterResult) {
        // TODO Implement this Android code
        // val activity = mainActivity?.context as Activity

        // val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)

        // try {
        //     activity.startActivityForResult(intent, 1)
        // }
        // catch (e: SecurityException) {
        //     Log.e("Android", e.message!!)
        // }
        // mXsScanner.setScanMode(ScanSettings.SCAN_MODE_LOW_LATENCY)
        // mXsScanner.startScan()
        result("starting scan")
    }
}