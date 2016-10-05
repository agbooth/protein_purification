//
//  pp_SplashView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 21/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_SplashView.h"

@implementation pp_SplashView {
    
    UILabel* title;
    UILabel* author;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        title = nil;
        author = nil;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    // Create the labels.
    
    if (!title)
    {
        title = [[UILabel alloc] initWithFrame:CGRectMake(180, 320, 700, 50)];
        title.text = NSLocalizedString(@"Program Title",@"");
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.shadowColor = [UIColor colorWithWhite:0 alpha:0.5] ;
        title.shadowOffset = CGSizeMake(0.0,1.0);
        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
        title.numberOfLines = 1;
        
        [self addSubview: title];
    }
    else
        title.frame = CGRectMake(180, 320, 700, 50);
    
    if (!author)
    {
        author= [[UILabel alloc] initWithFrame:CGRectMake(180, 310, 500, 500)];
        author.text = NSLocalizedString(@"Program Author",@"");
        author.textColor = [UIColor blackColor];
        author.backgroundColor = [UIColor clearColor];
        author.shadowColor = [UIColor colorWithWhite:0 alpha:0.5] ;
        author.shadowOffset = CGSizeMake(0.0,1.0);
        author.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
        author.numberOfLines = 12;
        
        [self addSubview: author];
    }
    else
        author.frame = CGRectMake(180, 310, 500, 500);
}

- (void) layoutSubviews
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    // Correct the size for the status bar
    UIApplication *application = [UIApplication sharedApplication];
    
    // Don't know why this works, but it does...
    size.height += MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    
    CGRect contentRect = CGRectMake(0, 0, size.width, size.height);
    
    // iOS8 layout issue
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[versionCompatibility objectAtIndex:0] intValue] >= 8)
        if (app.splitViewController.landscape)
        {
            contentRect.origin.x += 128.0;
            contentRect.origin.y -= 128.0;
        }
    
    self.bounds = contentRect;

}

@end
