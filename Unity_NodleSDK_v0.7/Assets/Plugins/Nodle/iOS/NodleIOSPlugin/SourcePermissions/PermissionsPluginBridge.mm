#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#include "UnityFramework/UnityFramework-Swift.h"
#import "UnityInterface.h"



extern "C" {
    
#pragma mark - Functions

    int _InitPermissionsPlugin( char *strSendEvents, char *strPermissionsEvents)  {
        NSString* sendEvents=@(strSendEvents);
        NSString* permissionsEvents=@(strPermissionsEvents);
        int result =(int)[[PermissionsPlugin shared] InitPermissionsPluginWithSendEvents:(sendEvents)  permissionsEvents:(permissionsEvents)];
        return result;
    }

    int _RequestPermissionsBluetooth() {
        int result = (int)[[PermissionsPlugin shared] RequestPermissionsBluetooth];
        return result;
    }

    int _RequestPermissionsLocation() {
        int result = (int)[[PermissionsPlugin shared] RequestPermissionsLocation];
        return result;
    }

}
