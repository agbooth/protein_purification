//
//  pp_AmmSulfViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//


#import "pp_AmmSulfViewController.h"


@implementation pp_AmmSulfViewController

- (void) loadView
{
    self.view = [[pp_AmmSulfView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle: NSLocalizedString(@"Done",@"")
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(setValueAndGo)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    [((pp_ElutionViewController*)app.splitViewController.delegate).view setNeedsDisplay];
}



// Needed because of a bug in UIAlertView in which the message is not shown
// on an iPhone in landscape if the UIALertView has three or more buttons
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    // Expand the alertView
    alertView.frame = CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y-45
                                 ,alertView.frame.size.width, alertView.frame.size.height+80);
    
    // Iterate through its subviews
    for (UIView* v in alertView.subviews)
    {
        // Find the UIAlertButtons and move them down
        if ([v isKindOfClass:[UIButton class]])
        {
            v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y+80, v.frame.size.width, v.frame.size.height);
        }
        // Find the message label, change its alpha and expand it
        if ([v isKindOfClass:[UILabel class]])
        {
            NSString* title = ((UILabel*)v).text;
            
            // Check it is the message label
            if ([title hasPrefix:NSLocalizedString(@"You have precipitated",@"")])
            {
                ((UILabel*)v).numberOfLines = 6;
                v.alpha = 1.0;
                v.frame = CGRectMake(v.frame.origin.x, v.frame.origin.y-5, v.frame.size.width, v.frame.size.height+100);
            }
        }
    }

}


- (void) setValueAndGo
{
   
    [app.commands doAmmoniumSulfate:((pp_AmmSulfView*)self.view).ammsulfFloatValue];
    NSString* message = [app.commands checkASPrecipitate];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Ammonium sulfate",@"")
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:
                                            NSLocalizedString(@"Use the precipitated material",@""),
                                            NSLocalizedString(@"Use the soluble material",@""),
                                            nil];

    
    [alert show];
    
    
    

}


- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [app.commands finishAmmoniumSulfate: buttonIndex];    
}


@end
