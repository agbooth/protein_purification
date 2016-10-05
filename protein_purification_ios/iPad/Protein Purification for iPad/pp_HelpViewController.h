//
//  pp_HelpViewController.h
//  
//

#import <UIKit/UIKit.h>
#import "pp_AppDelegate.h"

@interface pp_HelpViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain, readonly) UIWebView *webView;
@property (nonatomic, retain) NSString* helpFile;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

@end

