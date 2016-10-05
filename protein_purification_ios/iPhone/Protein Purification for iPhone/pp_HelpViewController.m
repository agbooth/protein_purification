//
//  pp_HelpViewController.m
//  
//

#import "pp_HelpViewController.h"

//#define pp_InAppPurchaseUpgradeProductId @"com.agbooth.pp_iphone.in_app1"



@implementation pp_HelpViewController {
    
    bool masterWasShowing;
    
    UIAlertView *alert1;
    
}

@synthesize helpFile, webView, activityIndicator;

-(UIWebView *)webView
{
    return (UIWebView *)self.view;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    self.view = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.webView.delegate = self;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    self.navigationItem.titleView = self.activityIndicator;
    
   // self.webView.scalesPageToFit = YES;
    
    // Check that the file exists
	NSString *filePath = [[NSBundle mainBundle] pathForResource:self.helpFile ofType:@"html"];
	NSData *htmlData = [NSData dataWithContentsOfFile:filePath];

	if (htmlData) // Yes it exists
    {
		NSBundle *bundle = [NSBundle mainBundle]; 
		NSString *path = [bundle bundlePath];
        
        // Get the full path of the file including its filename
		NSString *fullPath = [NSBundle pathForResource:self.helpFile ofType:@"html" inDirectory:path];
        
        // Get the contents
        NSString* htmlString = [NSString stringWithContentsOfFile:fullPath 
                                               encoding:NSUTF8StringEncoding 
                                                  error:nil];
        
        // Trim off the filename component and use this as the base URL
        NSURL *baseURL = [[NSURL fileURLWithPath:fullPath] URLByDeletingLastPathComponent];
        
        // Show it in the webView and set the base URL
        [self.webView loadHTMLString:htmlString baseURL:baseURL];
	}
}

- (void) viewWillAppear:(BOOL)animated
{
    masterWasShowing = app.splitViewController.isShowingMaster;
    [self hideMasterView];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    
    if (masterWasShowing) [self showMasterView];
    [super viewWillDisappear:animated];
}


- (void)showMasterView
{
    if (!app.splitViewController.isShowingMaster)
    {
        [app.splitViewController toggleMasterView:self];
        app.splitViewController.showsMasterInLandscape = YES;
        app.splitViewController.showsMasterInPortrait = YES;

    }
}

- (void)hideMasterView
{
    if (app.splitViewController.isShowingMaster)
    {
        [app.splitViewController toggleMasterView:self];
        app.splitViewController.showsMasterInLandscape = NO;
        app.splitViewController.showsMasterInPortrait = NO;
 
    }
}



- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}


- (void) showReplacementFile:(NSString*) filename
{
    // Replacement file must have '1' added to name e.g. myfile.html becomes myfile1.html
    NSString *file = [filename stringByReplacingOccurrencesOfString:@".html" withString:@"1"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle bundlePath];
    
    // Get the full path of the file including its filename
    NSString *fullPath = [NSBundle pathForResource:file ofType:@"html" inDirectory:path];
    
    // Get the contents
    NSString* htmlString = [NSString stringWithContentsOfFile:fullPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    
    // Trim off the filename component and use this as the base URL
    NSURL *baseURL = [[NSURL fileURLWithPath:fullPath] URLByDeletingLastPathComponent];
    
    // Show it in the webView and set the base URL
    [self.webView loadHTMLString:htmlString baseURL:baseURL];
}



#pragma UIWebView delegate

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    // Disable long touch to prevent alert sheet appearing.
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';"];

    [activityIndicator stopAnimating];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        if([[[request mainDocumentURL] lastPathComponent] isEqualToString:@"Tutorial.html"])
        // Launch the tutorial in Safari.
        {
            NSURL *url = [NSURL URLWithString:NSLocalizedString(@"http://www.agbooth.com/pp_tut_iPad",@"")];
            
            [[UIApplication sharedApplication] openURL:url];
            
            return NO;
        }
    
    }
    
    return YES;
}

@end
