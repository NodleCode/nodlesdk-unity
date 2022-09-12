
import Foundation
import SwiftCBOR
import SwiftProtobuf
import NodleSDK
import SQLite
import CoreLocation
import CoreBluetooth

@objc public class NodlePlugin : NSObject {
    let nodle = Nodle.sharedInstance
    @objc public static let shared = NodlePlugin()
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheralManager?
    var goSendEvents: String="";
    var NodleEvents:String="NodleEvents";
    
    @objc public func InitPlugin(sendEvents:String, nodleEvents:String="NodleEvents") -> Int {
        self.goSendEvents=sendEvents;
        self.NodleEvents=nodleEvents;
        
        let statusMessage = self.toJSON(stringEvent:"initiated", typeId:-1,version:"",status: "") ;

        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
        return 1;
    }
 
    @objc public func Start(key:String,tag:String) {
        nodle.start(devKey: key, tags: tag)
   
        let statusMessage = self.toJSON(stringEvent:"started", typeId:-4,version:"",status: "") ;

        
        
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
      
    }
    @objc public func isStarted() -> Bool {
        
        let status = nodle.isStarted();
       print (status)
        let statusMessage = self.toJSON(stringEvent:"is_started", typeId:-6,version:"",status: (status ? "true": "false")) ;
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
        return status;
    }
    @objc public func isScanning() -> Bool {
        let status = nodle.isScanning();
        let statusMessage = self.toJSON(stringEvent:"is_scanning", typeId:-7,version:"",status: (status ? "true": "false")) ;

        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
        return status;
    }

    @objc public func ScheduleNodleBackgroundTask(){
       nodle.scheduleNodleBackgroundTask();
       
        let statusMessage = self.toJSON(stringEvent:"schedule_nodle_background_task", typeId:-30,version:"",status: "") ;
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
    }
    @objc public func RegisterNodleBackgroundTask(){
        nodle.registerNodleBackgroundTask();
        let statusMessage = self.toJSON(stringEvent:"register_nodle_background_task", typeId:-20,version:"",status: "") ;
        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
    }
    
    @objc public func GetVersion() {
        let statusMessage = self.toJSON(stringEvent:"version", typeId:-3,version:nodle.getVersion(),status: "") ;

        if let uf = UnityFramework.getInstance() {
               uf.sendMessageToGO(
                withName: self.goSendEvents,
                functionName: self.NodleEvents,
                message: statusMessage)
        }
    }
    
    @objc public func GetEvents() {
        var statusMessage = "";
        
        nodle.getEvents { event in
            switch event.type {
                case .BlePayloadEvent:
                    let payload = event as! NodleBluetoothRecord
                    print("Bluetooth payload available")
                    //statusMessage="BlePayloadEvent-\(payload.device).\(payload.type).\(payload.rssi)"
                    statusMessage=self.toJSONPayload(bluet: payload, typeName: "BlePayloadEvent"  ) as String;
                    break
                case .BleStartSearching:
                    print("Bluetooth started searching \(Date())")
                 
                    statusMessage=self.toJSON(stringEvent: "BleStartSearching", typeId:event.type.rawValue,version: "",status: "")  ;
                    break
                case .BleStopSearching:
                    print("Bluetooth stopped searching \(Date())")
                  
                    statusMessage=self.toJSON(stringEvent: "BleStopSearching", typeId:event.type.rawValue,version: "",status: "")  ;
                    break
                case .BeaconPayloadEvent:
                    let payload = event as! NodleBeaconRecord
                    print("iBeacon payload available \(payload.identifier) major: \(payload.major) minor: \(payload.minor) delivered at \(Date())")
                statusMessage=self.toJSONPayload(beacon:payload, typeName: "BeaconPayloadEvent") as String  ;
                break
                case .BeaconStartSeaching:
                    print("iBeacon started searching \(Date())")
                statusMessage=self.toJSON(stringEvent: "BeaconStartSeaching", typeId:event.type.rawValue,version: "",status: "")  ;

                    break
                case .BeaconStopSearching:
                    print("iBeacon stop searching \(Date())")
                statusMessage=self.toJSON(stringEvent:"BeaconStopSearching", typeId:event.type.rawValue,version:"",status: "");
                
                    break
            @unknown default:
                    print("Failed to get any event")
                    statusMessage=self.toJSON(stringEvent:"Unkown", typeId:-10,version:"",status: "") ;
            
            }
            if let uf = UnityFramework.getInstance() {
                   uf.sendMessageToGO(
                    withName: self.goSendEvents,
                    functionName: self.NodleEvents,
                       message:   statusMessage )
            }
        }
    }
    
    @objc public func ConfigInt(key:String,value: Int) {
        nodle.config(key: key, value: value);
    }
    @objc public func ConfigString(key:String,value:String) {
        nodle.config(key: key, value: value);
    }
    @objc public func ConfigBool(key:String,value:Bool) {
        nodle.config(key: key, value: value);
    }
    @objc public func Stop() {
        nodle.stop()
    }
    
    
    func toJSON( stringEvent:String,  typeId:Int,  version:String,  status:String) -> String {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue(stringEvent, forKey: "type_name")
        jsonObject.setValue(typeId, forKey: "type_id")
    
        if (!version.isEmpty) {
            jsonObject.setValue(version, forKey: "version")
        }
        if (!status.isEmpty) {
            jsonObject.setValue(status, forKey: "status")
        }
        let jsonData: NSData;
        var jsonString : String = "";
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            print("json string = \(jsonString)")

        } catch _ {
            print ("JSON Failure")
        }
        return jsonString;
        
    }
    func toJSONPayload(beacon:NodleBeaconRecord, typeName:String) -> NSString {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue(typeName, forKey: "type_name")
        jsonObject.setValue(beacon.type.rawValue, forKey: "type_id")
        jsonObject.setValue(beacon.rssi, forKey: "rssi")
        jsonObject.setValue(beacon.accuracy, forKey: "accuracy")
        jsonObject.setValue(beacon.major, forKey: "major")
        jsonObject.setValue(beacon.minor, forKey: "minor")
        jsonObject.setValue(beacon.proximity, forKey: "proximity")
        jsonObject.setValue(beacon.identifier, forKey: "identifier")
        jsonObject.setValue(beacon.timestamp, forKey: "timestamp")
        
        
        let jsonData: NSData;
        var jsonString : String = "";
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String;
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }
        return NSString(string: jsonString);
        
    }
    func toJSONPayload(bluet:NodleBluetoothRecord, typeName:String) -> NSString {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()

        jsonObject.setValue(typeName, forKey: "type_name")
        jsonObject.setValue(bluet.type.rawValue, forKey: "type_id")
        jsonObject.setValue(bluet.rssi, forKey: "rssi")
        jsonObject.setValue(bluet.device, forKey: "device")
        jsonObject.setValue(bluet.bytes, forKey: "bytes")
       // jsonObject.setValue(bluet.manufacturerSpecificData, forKey: "manufacturerSpecificData")
       // jsonObject.setValue(bluet.serviceUuids, forKey: "serviceUuids")
   
        let jsonData: NSData;
        var jsonString : String = "";
        
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String;
            print("json string = \(jsonString)")
        } catch _ {
            print ("JSON Failure")
        }
        return NSString(string: jsonString);
        
    }
}
