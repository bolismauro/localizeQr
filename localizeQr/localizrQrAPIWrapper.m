//
//  localizrQrAPIWrapper.m
//  localizeQr
//
//  Created by Mauro Bolis on 16/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LocalizrQrAPIWrapper.h"
#import "JSON.h"

@implementation LocalizrQrAPIWrapper



+ (APICallResult) savePosition:(NSString*)QrCode inPosition:(CLLocation*) position fromDevice:(NSString*)deviceID{
    
 	
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,SAVE_PRESENCE_PAGE]];
	
	NSLog(@"%@",url);
	
	NSData* body = [[NSString stringWithFormat:@"code=%@&latitude=%f&longitude=%f&deviceID=%@",
					 QrCode,position.coordinate.latitude,position.coordinate.longitude,deviceID] dataUsingEncoding: NSASCIIStringEncoding];
	
	
	NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:body];
	
	[request setTimeoutInterval:30000];
	
	NSError *error = nil;
	NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
	NSLog(@"-->%@",error);
	
	[request release];
	
	NSString* responseString = [[NSString alloc] initWithData:response encoding: NSASCIIStringEncoding];
	
	NSLog(@"RESPONSE %@",responseString);
	
	if(response == nil){
		return ConnectionError;
    }
	
	@try {
		
		NSString* responseString = [[NSString alloc] initWithData:response encoding: NSASCIIStringEncoding];
       NSDictionary* ret = [responseString JSONValue];
        int result = [[ret objectForKey:@"resultCode"] intValue];
        return (APICallResult)result;
        
	}	
	@catch (NSException * e) {
		return ConnectionError;
	}
	
	return ConnectionError;
    
}




+ (NSString*) getLocalizedMessage:(APICallResult)res{

    switch (res) {
        case ConnectionError: return NSLocalizedString(@"Si è verificato un errore durante la connessione al server, si prega di rieffettuare il salvataggio", @"");
        case ParamsError: return NSLocalizedString(@"ATTENZIONE:::QUESTO ERRORE NON DEVE MAI AVVENIRE IN PRODUZIONE", @"");
        case QRCodeError: return NSLocalizedString(@"Il codice letto non esiste ", @"");
        case PositionError: return NSLocalizedString(@"Il codice letto si trova in una posizione diversa da quella rilevata dal dispositivo", @"");
        case DeviceIDError: return NSLocalizedString(@"Il dispositivo non esiste oppure non è associato all'account a cui il codice letto è collegato", @"");
        case OperationsOK: return NSLocalizedString(@"Salvataggio effettuato", @"");
            
    }
    
    return NSLocalizedString(@"Errore sconosciuto",@"");

}

@end
