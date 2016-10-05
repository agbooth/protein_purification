//
//  pp_AppDelegate.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 18/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_AppDelegate.h"
#import "pp_ProteinData.h"
#import "pp_Commands.h"

#import "pp_SplashViewController.h"
#import "pp_MainMenuViewController.h"

@implementation pp_AppDelegate

@synthesize window = _window;

@synthesize proteinData;
@synthesize commands;
@synthesize separation;
@synthesize account;

@synthesize splitViewController;
@synthesize masterViewController;
@synthesize detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self updateFileNames];
    
    self.commands = [[pp_Commands alloc] init ];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor colorWithRed:0.84765625 green:0.859375 blue:0.87890625 alpha:1.0];
    
    self.splitViewController = [[MGSplitViewController alloc]initWithNibName:nil bundle:(NSBundle *)nil];
    
    self.masterViewController = [[pp_GetMixtureController alloc] initWithStyle:UITableViewStyleGrouped];
    self.detailViewController = [[pp_SplashViewController alloc] init];
    
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [self.window setTintColor:[UIColor colorWithRed:0 green:0.25 blue:0.25 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.25 green:0.75 blue:0.75 alpha:1]];
    
    self.splitViewController.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailNavigationController, nil];
    self.splitViewController.delegate = (id) detailViewController;
    
    self.window.rootViewController = self.splitViewController;
    
    self.splitViewController.showsMasterInLandscape = NO;
    self.splitViewController.showsMasterInPortrait = NO;

    [self.window makeKeyAndVisible];
    
  
    return YES;
}

- (void) updateFileNames  // renames any files that don't have the correct suffix
{
    
    NSFileManager* fm = [[NSFileManager alloc] init];
    
    NSString* docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSArray* filesInDocs = [fm contentsOfDirectoryAtPath:docs error:nil];
    
    
    
    if (filesInDocs)
    {
        for (NSString* file in filesInDocs)
        {
            // check the attributes of the file
            
            NSString* path = [docs stringByAppendingPathComponent:file];
            NSDictionary *attribs = [fm attributesOfItemAtPath:path error: NULL];
            NSString* fileType = [attribs objectForKey: NSFileType];
            
            
            if (![file hasPrefix:@"."] && ![fileType isEqualToString:NSFileTypeDirectory] )  // don't modify hidden files or directories
            {
                if (![file hasSuffix:@".ppmixture"]) // rename files that don't have the correct suffix
                {
                    
                    NSString* oldPath = [docs stringByAppendingPathComponent:file];
                    NSString* newPath = [docs stringByAppendingPathComponent:[file stringByAppendingString:@".ppmixture"]];
                    [fm moveItemAtPath:oldPath toPath:newPath error:nil];
                    
                }
            }
        }
    }
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
