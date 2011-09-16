//
//  localizrQrAPIWrapper.h
//  localizeQr
//
//  Created by Mauro Bolis on 16/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define SERVER_URL @"http://applab.trizerodb.com/API/"
#define SAVE_PRESENCE_PAGE @"savePresence.php"


@interface LocalizrQrAPIWrapper : NSObject

typedef enum {
    
    ConnectionError = 0,
    ParamsError,
    QRCodeError,
    PositionError,
    DeviceIDError,
    OperationsOK
    
}APICallResult;



+ (APICallResult) savePosition:(NSString*)QrCode inPosition:(CLLocation*) position fromDevice:(NSString*)deviceID;
+ (NSString*) getLocalizedMessage:(APICallResult)res;

@end
