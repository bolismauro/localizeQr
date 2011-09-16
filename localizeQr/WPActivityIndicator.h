#import <UIKit/UIKit.h>
#import "TKLoadingView.h"

@interface WPActivityIndicator : NSObject {
	IBOutlet UIWindow *window;
	TKLoadingView* loading;
}

@property (nonatomic, readonly) UIWindow *window;

+ (WPActivityIndicator *)sharedActivityIndicator;

- (void)showWithText:(NSString*) textToShow ;
- (void)hide;
- (void) hideWithMessage:(NSString*)message;

-(void) postAlert:(NSString*)message;

@end
