//
//  localizeQrViewController.m
//  localizeQr
//
//  Created by Mauro Bolis on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "localizeQrViewController.h"
#import "WPActivityIndicator.h"
#import "LocalizrQrAPIWrapper.h"

@implementation localizeQrViewController
@synthesize latitudeLabel;
@synthesize longitudeLabel;
@synthesize map;
@synthesize infoView;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //add the listener for gesture
    UILongPressGestureRecognizer *longTouchGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCamera:)] autorelease];
    longTouchGesture.numberOfTouchesRequired = 1;
        
    [self.map addGestureRecognizer:longTouchGesture];    
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSLog(@"here");
    
    //show info view
    [UIView animateWithDuration:1 animations:^{
        
        [self.infoView setFrame:CGRectMake(0, 377, 320, 83)];
        
    } 
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:1 
                                               delay:15 
                                             options:UIViewAnimationCurveLinear 
                                          animations:^{
                                              [self.infoView setFrame:CGRectMake(0, 470, 320, 83)];
                                          } 
                                          completion:^(BOOL finished){}];
                     }
     ];
}


- (void)viewDidUnload
{
    [self setLatitudeLabel:nil];
    [self setLongitudeLabel:nil];
    [self setMap:nil];
    [self setInfoView:nil];
    [self setInfoView:nil];
    [self setInfoView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [labelLatitudine release];
    [latitudeLabel release];
    [longitudeLabel release];
    [map release];
    [infoView release];
    [infoView release];
    [infoView release];
    [super dealloc];
}

-(void) showCamera:(UISwipeGestureRecognizer*)swipeGesture{
 
     if(![CLLocationManager locationServicesEnabled]){
         //if the localization service is disable we can't get the user location so the app can't be used
         
         UIAlertView* alert = [[UIAlertView alloc] 
                                            initWithTitle:NSLocalizedString(@"Attenzione" ,@"")
                                            message:NSLocalizedString(@"Questa applicazione necessita dell'utilizzo della localizzazione. Questa funzione è stata disabilitata per localizeQR. Riattivala usando le impostazioni che troverai in Impostazioni > Localizzazione", @"")
                                            delegate:nil 
                                            cancelButtonTitle:NSLocalizedString(@"Ok",@"") 
                                            otherButtonTitles:nil];
         [alert show];
         [alert release];
         
         return;
     }    
    
    ZBarReaderViewController* photoReader = [ZBarReaderViewController new];
    photoReader.tracksSymbols = YES;
    [photoReader.readerView.captureReader.captureOutput setValue:nil forKey:@"videoSettings"];
    photoReader.readerDelegate = self;
    
    ZBarImageScanner *scanner = photoReader.scanner;
    
    // show EAN variants as such
    [scanner setSymbology: ZBAR_UPCA
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    [scanner setSymbology: ZBAR_UPCE
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    [scanner setSymbology: ZBAR_ISBN13
                   config: ZBAR_CFG_ENABLE
                       to: 1];
    
    // disable rarely used i2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController:photoReader animated:YES];
    [photoReader release];


}


-(void) scanCompletatoConCodice:(NSString*)codice{
    
    [self performSelectorInBackground:@selector(avviaLoading:) withObject:NSLocalizedString(@"Contatto il server", @"")];
     
    //get the current location
    CLLocation* currentLocation = self.map.userLocation.location;
    
    //get the UID
    UIDevice *myDevice = [UIDevice currentDevice];
	NSString *deviceUDID = [myDevice uniqueIdentifier];
    
    NSLog(@"device ID %@", deviceUDID);
    
    //make the API call
    APICallResult res = [LocalizrQrAPIWrapper savePosition:codice inPosition:currentLocation fromDevice:deviceUDID];
     
    [[WPActivityIndicator sharedActivityIndicator] hide];
    
    
    NSString* messageToDisplay = [LocalizrQrAPIWrapper getLocalizedMessage:res];
    
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Messaggio", @"") 
                                                    message:messageToDisplay 
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", @"") 
                                          otherButtonTitles:nil];
    
    [alert show];
    [alert release];
    
    
}

#pragma mark ZBar delegato
- (void) imagePickerController:(UIImagePickerController*)picker 
 didFinishPickingMediaWithInfo:(NSDictionary*)infos{
 
    
    /*[UIView animateWithDuration:0 animations:^{
        
        picker.view.alpha = 0;
        
    } 
                     completion:^(BOOL finished){
                         
      */                   [picker dismissModalViewControllerAnimated:NO];/*
                     }
     ];
    */
    
	id<NSFastEnumeration> results = [infos objectForKey: ZBarReaderControllerResults];
    
	for(ZBarSymbol *s in results){
		@try {
            NSLog(@"read string: %@", s.data);
			[self scanCompletatoConCodice:s.data];
		}
		@catch (NSException * e) {
            NSLog(@"An exception occurred %@",e);
		}
	}
}


-(void) dismissPicker:(UIImagePickerController*)picker{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[picker dismissModalViewControllerAnimated:YES];
	[pool release];  
}


-(void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry{
    //manage errors
}


#pragma map delegate
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == mv.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1; 
            
            CLLocationCoordinate2D location=mv.userLocation.coordinate;
            
            region.span=span;
            region.center=location;
            
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
        }
    }
}


#pragma gestures recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {   
    return YES;
}


#pragma loading_backgroud_function
-(void) avviaLoading:(NSString*)text{
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[[WPActivityIndicator sharedActivityIndicator] showWithText:text];
	[pool release];
}

@end
