//
//  localizeQrViewController.h
//  localizeQr
//
//  Created by Mauro Bolis on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ZBarSDK.h"

@interface localizeQrViewController : UIViewController<ZBarReaderDelegate, MKMapViewDelegate> {
    UILabel *labelLatitudine;
    UILabel *latitudeLabel;
    UILabel *longitudeLabel;
    MKMapView *map;
}
@property (nonatomic, retain) IBOutlet UILabel *latitudeLabel;
@property (nonatomic, retain) IBOutlet UILabel *longitudeLabel;
@property (nonatomic, retain) IBOutlet MKMapView *map;

@property (retain, nonatomic) IBOutlet UIView *infoView;



-(void) showCamera:(UISwipeGestureRecognizer*)swipeGesture;
-(void) scanCompletatoConCodice:(NSString*)codice;

//background
-(void) avviaLoading:(NSString*)text;
@end
