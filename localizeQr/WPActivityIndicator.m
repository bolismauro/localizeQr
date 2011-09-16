#import "WPActivityIndicator.h"
#import "TKAlertCenter.h"

@implementation WPActivityIndicator
@synthesize window;

static WPActivityIndicator *activityIndicator;

- (id) init
{
	self = [super init];
	if (self != nil) {
		[[NSBundle mainBundle] loadNibNamed:@"WPActivityIndicator" owner:self options:nil];
		loading = [[TKLoadingView alloc] initWithTitle:@""];
		loading.center = CGPointMake(self.window.bounds.size.width/2, self.window.bounds.size.height/2);
		[window addSubview:loading];
	}
	return self;
}

+ (WPActivityIndicator *)sharedActivityIndicator {

	if (!activityIndicator){
		
		NSLog(@"Alloco WPA");
		activityIndicator = [[WPActivityIndicator alloc] init];
		activityIndicator.window.windowLevel = UIWindowLevelAlert;
	}
	return activityIndicator;
}

- (void)showWithText:(NSString*) textToShow{
	
	loading.title = textToShow;
	[loading startAnimating];
	[window makeKeyAndVisible];
	window.hidden = NO;
	return;
	


}

- (void)hide {
	NSLog(@"hide WPA");	
	[loading stopAnimating];
	[window resignKeyWindow];
	window.hidden = YES;
}

-(void) hideWithMessage:(NSString*)message{
	
	NSLog(@"hide WPA");	
	[loading stopAnimating];
	[window resignKeyWindow];
	window.hidden = YES;
	[self postAlert:message];
}

-(void)postAlert:(NSString *)message{

		[[TKAlertCenter defaultCenter]postAlertWithMessage:message image:[UIImage imageNamed:@"ok"]];
	
}


@end
