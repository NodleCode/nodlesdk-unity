import Foundation
import SwiftCBOR
import SwiftProtobuf
import NodleSDK
import SQLite
import CoreLocation
import CoreBluetooth

@objc public class PermissionsPlugin : NSObject, CLLocationManagerDelegate, CBCentralManagerDelegate, CBPeripheralManagerDelegate {
    @objc public static let shared = PermissionsPlugin();
    
    private let locationManager = CLLocationManager()
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheralManager?
    var goSendEvents: String="";
    var PermissionsEvents:String="PermissionsEvents";
    
    @objc public func InitPermissionsPlugin(sendEvents:String, permissionsEvents:String="PermissionsEvents") -> Int {
        self.goSendEvents=sendEvents;
        self.PermissionsEvents=permissionsEvents;
        let statusMessage = "initiated";
        
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.PermissionsEvents,
                message: statusMessage)
        }
        return 1;
    }
    
    @objc public func RequestPermissionsLocation() -> Int {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization();
        let statusMessage = "requested_location";
        
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.PermissionsEvents,
                message: statusMessage)
        }
        return 1;
    }
    
    @objc public func RequestPermissionsBluetooth() -> Int {
        let showPermissionAlert = 1
        let options = [CBCentralManagerOptionShowPowerAlertKey: showPermissionAlert]
        peripheral = CBPeripheralManager(delegate: self, queue: nil, options: options)
        let statusMessage = "requested_bluetooth";
        
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.PermissionsEvents,
                message: statusMessage)
        }
        return 1;
    }
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        var statusMessage = ""
      
            switch peripheral.state {
            case .poweredOn:
                statusMessage = "powered_on"
                break
            case .poweredOff:
                statusMessage = "powered_off"
                break
            case .resetting:
                statusMessage = "resetting"
                break
            case .unauthorized:
                statusMessage = "unauthorized"
                break
            case .unsupported:
                statusMessage = "unsupported"
                break
            case .unknown:
                statusMessage = "unknown"
            @unknown default:
                print("UNKNOWN_ERROR")
                statusMessage = "unknown_error"
            }

            print(statusMessage)

            if peripheral.state == .poweredOff {
                //TODO: Update this property in an App Manager class
            }
            if let uf = UnityFramework.getInstance() {
                   uf.sendMessageToGO(
                    withName: self.goSendEvents,
                    functionName: self.PermissionsEvents,
                       message: statusMessage)
            }
    }
    
    @objc public  func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var statusMessage = ""
      
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            statusMessage="authorized_when_use"
            locationManager.requestAlwaysAuthorization()
            // ask for bluetooth permissions
            centralManager = CBCentralManager(delegate: self, queue: nil)
            break
        case .authorizedAlways:
            statusMessage="authorized_always"
            locationManager.requestAlwaysAuthorization()
            // ask for bluetooth permissions
            centralManager = CBCentralManager(delegate: self, queue: nil)
            break
        case .notDetermined:
            statusMessage="authorized_always"
            // ask for permissions/ request always if testing background
            locationManager.requestAlwaysAuthorization()
            break
        default:
            statusMessage="authorization_denied"
            print("Location permission denied")
            break;
        }
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.PermissionsEvents,
                message: statusMessage)
        }
    }
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
}
