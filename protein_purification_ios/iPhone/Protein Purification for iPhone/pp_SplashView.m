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

float x;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        title = nil;
        author = nil;
        x = 0;
    }
    return self;
}

- (void) layoutSubviews
{
    
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    CGFloat xoffset, yoffset = 0.0;
    
    NSArray *versionCompatibility = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[versionCompatibility objectAtIndex:0] intValue] < 8)
    {
        yoffset = 100.0;
        xoffset = -100.0;
    }
    
    // Create the labels.
    
    if (!title)
    {
        title = [[UILabel alloc] initWithFrame:CGRectMake(5+xoffset, 0+yoffset, 300, 150)];
        title.text = NSLocalizedString(@"Program Title",@"");
        title.textColor = [UIColor blackColor];
        title.backgroundColor = [UIColor clearColor];
        title.shadowColor = [UIColor colorWithWhite:0 alpha:0.5] ;
        title.shadowOffset = CGSizeMake(0.0,1.0);
        title.font = [UIFont fontWithName:@"Helvetica-Bold" size:33];
        title.numberOfLines = 2;
        [self addSubview: title];
    }
    else
        title.frame = CGRectMake(5+xoffset, 0+yoffset, 300, 150);
    
    if (!author)
    {
        author = [[UILabel alloc] initWithFrame:CGRectMake(5+xoffset, 80+yoffset, 300, 200)];
        author.text = NSLocalizedString(@"Program Author",@"");
        author.textColor = [UIColor blackColor];
        author.backgroundColor = [UIColor clearColor];
        author.shadowColor = [UIColor colorWithWhite:0 alpha:0.5] ;
        author.shadowOffset = CGSizeMake(0.0,1.0);
        author.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        author.numberOfLines = 5;
        [self addSubview: author];
    }
    else
        author.frame = CGRectMake(5+xoffset, 80+yoffset, 300, 200);
}

@end
