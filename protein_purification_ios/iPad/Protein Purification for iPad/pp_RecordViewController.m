//
//  pp_RecordViewController.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 25/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_RecordViewController.h"
#import "pp_RecordView.h"


@implementation pp_RecordViewController

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Progress report",@"");

  //  [self didRotateFromInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] 
                                    initWithTitle: NSLocalizedString(@"Help",@"")
                                    style:0
                                    target:self
                                    action:@selector(showHelp)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // add the swipe and tape gesture recognizers
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handleSwipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(handleSwipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
    
    
    if (!app.splitViewController.isShowingMaster)
    {
        [self addMasterButton];
    }
    

}

- (void) loadView
{
    
    self.view = [[pp_RecordView alloc] initWithFrame: [[UIScreen mainScreen] applicationFrame]];
}



- (void)handleSwipeRight
{
    [self showMasterView];
}

- (void)handleSwipeLeft
{
    [self hideMasterView];
}

- (void)handleTap
{
    [self hideMasterView];
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

- (void)addMasterButton
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]
                                      initWithTitle:NSLocalizedString(@"Methods",@"")
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(showMasterView)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)removeMasterButton
{
    self.navigationItem.leftBarButtonItem = nil;
}

- (void) showHelp
{
    [app.commands showHelpPage:@"Main_Contents"];
    
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - Split view

#pragma mark -
#pragma mark MGSplit view support

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
}


- (void)splitViewController:(MGSplitViewController*)svc
	 willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem
	   forPopoverController: (UIPopoverController*)pc
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	[self addMasterButton];
    
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(MGSplitViewController*)svc
	 willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	[self removeMasterButton];
    
}


- (void)splitViewController:(MGSplitViewController*)svc
		  popoverController:(UIPopoverController*)pc
  willPresentViewController:(UIViewController *)aViewController
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willChangeSplitOrientationToVertical:(BOOL)isVertical
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (void)splitViewController:(MGSplitViewController*)svc willMoveSplitToPosition:(float)position
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
}


- (float)splitViewController:(MGSplitViewController *)svc constrainSplitPosition:(float)proposedPosition splitViewSize:(CGSize)viewSize
{
	//NSLog(@"%@", NSStringFromSelector(_cmd));
	return proposedPosition;
}





@end
