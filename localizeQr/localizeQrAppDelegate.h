//
//  localizeQrAppDelegate.h
//  localizeQr
//
//  Created by Mauro Bolis on 16/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class localizeQrViewController;

#define MainWindow ((UIWindow *)[[UIApplication sharedApplication] delegate]).window


@interface localizeQrAppDelegate : NSObject <UIApplicationDelegate>


@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet localizeQrViewController *viewController;

@end
