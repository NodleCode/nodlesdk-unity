#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#include "UnityFramework/UnityFramework-Swift.h"
#import "UnityInterface.h"



extern "C" {
    
#pragma mark - Functions

    int _initPlugin( char *strSendEvents, char *strNodleEvents)  {
        NSString* sendEvents=@(strSendEvents);

        NSString* nodleEvents=@(strNodleEvents);
        
        int result =(int)[[NodlePlugin shared] InitPluginWithSendEvents:(sendEvents) nodleEvents:(nodleEvents)];
        return result;
    }

    void _start( char *strKey,char *strTag) {
        NSString* key=@(strKey);
        NSString* tag=@(strTag);
        [[NodlePlugin shared] StartWithKey:(key) tag:(tag)];
    }

    bool _isStarted() {
        bool result = [[NodlePlugin shared] isStarted];
        return result;
    }

    bool _isScanning() {
        bool result = [[NodlePlugin shared] isScanning];
        return result;
    }

    void _scheduleNodleBackgroundTask( ) {
        [[NodlePlugin shared] ScheduleNodleBackgroundTask];
    }
    
    void _configString( char *strKey, char* strValue) {
        NSString* key=@(strKey);
        NSString* value=@(strValue);
        [[NodlePlugin shared] ConfigStringWithKey: (key) value: (value)];
    }
    void _configInt( char *strKey, int value) {
        NSString* key=@(strKey);
        [[NodlePlugin shared] ConfigIntWithKey: (key) value: (value)];
    }

    void _configBool( char *strKey, bool value) {
        NSString* key=@(strKey);
        [[NodlePlugin shared] ConfigBoolWithKey:(key) value: (value)];
    }

    void _registerNodleBackgroundTask( ) {
        [[NodlePlugin shared] RegisterNodleBackgroundTask];
    }
    void _stop( ) {
        [[NodlePlugin shared] Stop];
    }

    void _getEvents( ) {
        [[NodlePlugin shared] GetEvents];
    }
    void _getVersion( ) {
        [[NodlePlugin shared] GetVersion];
    }
}
