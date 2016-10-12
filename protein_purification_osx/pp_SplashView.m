//
//  pp_SplashView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 21/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_SplashView.h"

@implementation pp_SplashView

NSTextField* title;
NSTextField* author;
NSTextField* licensee;


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float ratio = self.bounds.size.height/788.0;
   
        title = [[[NSTextField alloc] initWithFrame:NSMakeRect(25, (600*ratio)-1, 800, 50*ratio)] autorelease];
        [title setEditable:NO];
        [title setBordered:NO];
        title.stringValue = NSLocalizedString(@"Program Title",@"");
        title.textColor = [NSColor lightGrayColor];
        [title setDrawsBackground:NO];
        title.font = [NSFont fontWithName:@"Helvetica-Bold" size:40*ratio];
        [self addSubview:title];
        
        title = [[[NSTextField alloc] initWithFrame:NSMakeRect(25, 600*ratio, 800, 50*ratio)] autorelease];
        [title setEditable:NO];
        [title setBordered:NO];
        title.stringValue = NSLocalizedString(@"Program Title",@"");
        title.textColor = [NSColor blackColor];
        [title setDrawsBackground:NO];
        title.font = [NSFont fontWithName:@"Helvetica-Bold" size:40*ratio];
        [self addSubview:title];
  
        author = [[[NSTextField alloc] initWithFrame:NSMakeRect(25, 0, 800, 550*ratio)] autorelease];
        [author setEditable:NO];
        [author setBordered:NO];
        author.stringValue = NSLocalizedString(@"Program Author",@"");
        author.textColor = [NSColor lightGrayColor];
        [author setDrawsBackground:NO];
        author.font = [NSFont fontWithName:@"Helvetica-Bold" size:33*ratio];
        [self addSubview:author];
        
        
        author = [[[NSTextField alloc] initWithFrame:NSMakeRect(25, 1, 800, 550*ratio)] autorelease];
        [author setEditable:NO];
        [author setBordered:NO];
        author.stringValue = NSLocalizedString(@"Program Author",@"");
        author.textColor = [NSColor blackColor];
        [author setDrawsBackground:NO];
        author.font = [NSFont fontWithName:@"Helvetica-Bold" size:33*ratio];
        [self addSubview:author];
        
        licensee = [[[NSTextField alloc] initWithFrame:NSMakeRect(25, 10, 800, 50*ratio)] autorelease];
        [licensee setEditable:NO];
        [licensee setBordered:NO];
        licensee.stringValue = NSLocalizedString(@"Registration",@"");
        licensee.textColor = [NSColor lightGrayColor];
        [licensee setDrawsBackground:NO];
        licensee.font = [NSFont fontWithName:@"Helvetica-Bold" size:20*ratio];
        [self addSubview:licensee];
        
        
        licensee = [[[NSTextField alloc] initWithFrame:NSMakeRect(25, 11, 800, 50*ratio)] autorelease];
        [licensee setEditable:NO];
        [licensee setBordered:NO];
        licensee.stringValue = NSLocalizedString(@"Registration",@"");
        licensee.textColor = [NSColor blackColor];
        [licensee setDrawsBackground:NO];
        licensee.font = [NSFont fontWithName:@"Helvetica-Bold" size:20*ratio];
        [self addSubview:licensee];
        
        NSString* Licensee = NSLocalizedString(@"Registration",@"");
        if ([Licensee isEqualToString:@""])
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Default Mixture" ofType:@"txt"];
            
            if (!([filePath hasPrefix:@"/Applications/"] || [filePath hasPrefix:@"/Users/"]))
            {
                NSAlert* alert = [[[NSAlert alloc] init] autorelease];
                [alert addButtonWithTitle:NSLocalizedString(@"OK",@"")];
                [alert setAlertStyle:NSCriticalAlertStyle];
                [alert setMessageText:NSLocalizedString(@"Sorry",@"")];
                [alert setMessageText:NSLocalizedString(@"Local",@"")];
                [alert.window setBackgroundColor:app.bgColor];
                [alert runModal];
                
                [NSApp terminate:self];

            }
            
        }
        else
        {
            app.Registered = YES;
        }
    }
    return self;
}

@end
