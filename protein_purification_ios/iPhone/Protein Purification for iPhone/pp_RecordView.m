//
//  pp_RecordView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 25/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_RecordView.h"

@implementation pp_RecordView {

UIButton* mixtureButton;
UILabel* pureTitleP;
UILabel* methodHeader;
UILabel* proteinHeader;
UILabel* enzymeHeader;
UILabel* yieldHeader;
UILabel* enrichHeader;
UILabel* costHeader;
UIButton* reportButton;
UILabel* infoHeader;

UILabel* data[11][6];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mixtureButton = nil;
        pureTitleP = nil;
        methodHeader = nil;
        proteinHeader = nil;
        enzymeHeader = nil;
        yieldHeader = nil;
        enrichHeader = nil;
        costHeader = nil;
        reportButton = nil;
        infoHeader = nil;
        
        for (int i=0; i<11; i++)
            for (int j=0; j<6; j++)
                    data[i][j] = nil;
    }
    return self;
}

- (NSString*) getMethodString: (int) method
{
    switch (method)
    {
        case None:                      return NSLocalizedString(@"Initial",@"");
        case Ammonium_sulfate:          return NSLocalizedString(@"Ammonium sulfate",@"");
        case Heat_treatment:            return NSLocalizedString(@"Heat treatment",@"");
        case Gel_filtration:            return NSLocalizedString(@"Gel filtration",@"");
        case Ion_exchange:              return NSLocalizedString(@"Ion exchange",@"");
        case Hydrophobic_interaction:   return NSLocalizedString(@"Hydrophobic int.",@"");
        case Affinity:                  return NSLocalizedString(@"Affinity chrom.",@"");
        default:                        return @"Unknown";
    }
}

- (void) drawButton:(CGRect) rect
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextSetStrokeColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-20.0,rect.origin.y,1500.0,rect.size.height+2.0) cornerRadius:10.0];
    [path fill];
    CGContextRestoreGState(con);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float xOffset;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
 /*
    if (app.splitViewController.isLandscape)
    {
        if (app.splitViewController.isShowingMaster) xOffset = 0.0;
        else xOffset = 150;
    }
    else
    {
        if (app.splitViewController.isShowingMaster) xOffset = 0.0;
        else xOffset = 30;
    }
  */
    xOffset = 0.0;
    
    CGFloat width = 480;
    UIScreen *screen = [UIScreen mainScreen];
    
    if ((screen.bounds.size.height == 568) || (screen.bounds.size.width == 568))
    {
        width = 568;
    }
    
    if (!mixtureButton)
    {
        mixtureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mixtureButton.backgroundColor = [UIColor clearColor];
        [mixtureButton setEnabled:NO];
        [self addSubview:mixtureButton];
    }
    mixtureButton.frame = CGRectMake(10+xOffset, 4, width-20, 40);

    if (!pureTitleP)
    {  
        pureTitleP = [[UILabel alloc] init];
        pureTitleP.text = [NSString stringWithFormat:NSLocalizedString(@"Purification of protein %d from %@",@""),app.proteinData.enzyme, app.proteinData.mixtureName];
        pureTitleP.textAlignment = NSTextAlignmentCenter;
        pureTitleP.backgroundColor = [UIColor clearColor];
        pureTitleP.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        pureTitleP.numberOfLines = 1;
        [self addSubview:pureTitleP];
    }
    pureTitleP.frame = CGRectMake(20+xOffset, 14, width-40, 20);
    
    if (!methodHeader)
    {
        methodHeader = [[UILabel alloc] init];
        methodHeader.text = NSLocalizedString(@"Method", @"");
        methodHeader.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        methodHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        methodHeader.shadowColor = [UIColor whiteColor];
        methodHeader.shadowOffset = CGSizeMake(0.0,0.5);
        methodHeader.backgroundColor = [UIColor clearColor];
        methodHeader.numberOfLines =  2;
        [self addSubview:methodHeader];
    }
    methodHeader.frame = CGRectMake(23+xOffset, 38, 150, 60);
    
    if (!proteinHeader)
    {
        proteinHeader = [[UILabel alloc] init];
        proteinHeader.text = NSLocalizedString(@"Protein (mg)", @"");
        proteinHeader.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        proteinHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        proteinHeader.shadowColor = [UIColor whiteColor];
        proteinHeader.shadowOffset = CGSizeMake(0.0,0.5);
        proteinHeader.backgroundColor = [UIColor clearColor];
        proteinHeader.numberOfLines =  2;
        proteinHeader.textAlignment = NSTextAlignmentCenter;
        [self addSubview:proteinHeader];
    }
    proteinHeader.frame = CGRectMake(100+xOffset, 38, 110, 60);
    
    if (!enzymeHeader)
    {
        enzymeHeader = [[UILabel alloc] init];
        enzymeHeader.text = NSLocalizedString(@"Enzyme (Units)", @"");
        enzymeHeader.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        enzymeHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        enzymeHeader.shadowColor = [UIColor whiteColor];
        enzymeHeader.shadowOffset = CGSizeMake(0.0,0.5);
        enzymeHeader.backgroundColor = [UIColor clearColor];
        enzymeHeader.numberOfLines =  2;
        enzymeHeader.textAlignment = NSTextAlignmentCenter;
        [self addSubview:enzymeHeader];
    }
    enzymeHeader.frame = CGRectMake(170+xOffset, 38, 110, 60);
    
    if (!yieldHeader)
    {
        yieldHeader = [[UILabel alloc] init];
        yieldHeader.text = NSLocalizedString(@"Yield (%)", @"");
        yieldHeader.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        yieldHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        yieldHeader.shadowColor = [UIColor whiteColor];
        yieldHeader.shadowOffset = CGSizeMake(0.0,0.5);
        yieldHeader.backgroundColor = [UIColor clearColor];
        yieldHeader.numberOfLines =  2;
        yieldHeader.textAlignment = NSTextAlignmentCenter;
        [self addSubview:yieldHeader];
    }
    yieldHeader.frame = CGRectMake(250+xOffset, 38, 80, 60);
        
    if (!enrichHeader)
    {
        enrichHeader = [[UILabel alloc] init];
        enrichHeader.text = NSLocalizedString(@"Enrichment", @"");
        enrichHeader.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        enrichHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        enrichHeader.shadowColor = [UIColor whiteColor];
        enrichHeader.shadowOffset = CGSizeMake(0.0,0.5);
        enrichHeader.backgroundColor = [UIColor clearColor];
        enrichHeader.numberOfLines =  2;
        [self addSubview:enrichHeader];
    }
    enrichHeader.frame = CGRectMake(328+xOffset, 38, 100, 60);
    
    if (!costHeader)
    {
        costHeader = [[UILabel alloc] init];
        costHeader.text = NSLocalizedString(@"Cost", @"");
        costHeader.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        costHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        costHeader.shadowColor = [UIColor whiteColor];
        costHeader.shadowOffset = CGSizeMake(0.0,0.5);
        costHeader.backgroundColor = [UIColor clearColor];
        costHeader.numberOfLines =  2;
        [self addSubview:costHeader];
    }
    costHeader.frame = CGRectMake(410+xOffset, 38, 100, 60);

    
    int step = app.proteinData.step;

    
    if (!reportButton)
    {
        reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reportButton.backgroundColor = [UIColor clearColor];
        [reportButton setEnabled:NO];
        [self addSubview:reportButton];
    }
    reportButton.frame = CGRectMake(10+xOffset, 85, width-20, 30+(15*step));

    [self drawButton:CGRectMake(10+xOffset, 85, width-20, 30+(15*step))];
    
    for (int i=0; i<=step; i++)
    {

        pp_StepRecord* record = [app.account getStepRecord:i];


        NSString* method = [self getMethodString:[record getStepType]];

        // Method
        if (! data[i][0])
        {
            data[i][0] = [[UILabel alloc] initWithFrame:CGRectMake(25+xOffset, 90+(15*i), 640, 20)];
            data[i][0].text = method;

            data[i][0].backgroundColor = [UIColor clearColor];
            data[i][0].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][0].numberOfLines = 1;
            [self addSubview:data[i][0]];
        }
        else
        {
            data[i][0].frame = CGRectMake(25+xOffset, 90+(15*i), 640, 20);
            data[i][0].text = method;
            data[i][0].backgroundColor = [UIColor clearColor];
            data[i][0].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][0].numberOfLines = 1;
        }
        
        // Protein
        if (! data[i][1])
        {
            data[i][1] = [[UILabel alloc] initWithFrame:CGRectMake(100+xOffset, 90+(15*i), 110, 20)];
            data[i][1].text = [NSString stringWithFormat:@"%d", (int)round([record getProteinAmount])];
            if ([record getProteinAmount]==0.0) data[i][1].text = @"0";
            data[i][1].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][1].textAlignment = NSTextAlignmentCenter;
            data[i][1].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][1]];
        }
        else
            data[i][1].frame = CGRectMake(100+xOffset, 90+(15*i), 110, 20);
        // Enzyme Units
        if (! data[i][2])
        {
            data[i][2] = [[UILabel alloc] initWithFrame:CGRectMake(160+xOffset, 90+(15*i), 130, 20)];
            data[i][2].text = [NSString stringWithFormat:@"%d", (int)round([record getEnzymeUnits])];
            if ([record getEnzymeUnits]==0.0) data[i][2].text = @"0";
            data[i][2].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][2].textAlignment = NSTextAlignmentCenter;
            data[i][2].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][2]];
        }
        else
            data[i][2].frame = CGRectMake(160+xOffset, 90+(15*i), 130, 20);
        // Enzyme Yield
        if (! data[i][3])
        {
            data[i][3] = [[UILabel alloc] initWithFrame:CGRectMake(250+xOffset, 90+(15*i), 80, 20)];
            data[i][3].text = [NSString stringWithFormat:@"%.1f", [record getEnzymeYield]];
            if ([record getEnzymeYield]==0.0) data[i][3].text = @"0";
            if ([record getEnzymeYield]==100.0) data[i][3].text = @"100";
            data[0][3].text = @"100";
            data[i][3].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][3].textAlignment = NSTextAlignmentCenter;
            data[i][3].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][3]];
        }
        else
            data[i][3].frame = CGRectMake(250+xOffset, 90+(15*i), 80, 20);
        // Enrichment
        if (! data[i][4])
        {
            data[i][4] = [[UILabel alloc] initWithFrame:CGRectMake(310+xOffset, 90+(15*i), 100, 20)];
            data[i][4].text = [NSString stringWithFormat:@"%.1f", [record getEnrichment]];
            if ([record getEnrichment]==0.0) data[i][4].text = @"!";
            data[i][4].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][4].textAlignment = NSTextAlignmentCenter;
            data[i][4].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][4]];
        }
        else
            data[i][4].frame = CGRectMake(310+xOffset, 90+(15*i), 100, 20);
        // Cost
        if (! data[i][5])
        {
            data[i][5] = [[UILabel alloc] initWithFrame:CGRectMake(375+xOffset, 90+(15*i), 100, 20)];
            data[i][5].text = [NSString stringWithFormat:@"%.3f", [record getCosting]];
            if ([record getCosting]==0.0) data[i][5].text = @"0";
            data[i][5].font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
            data[i][5].textAlignment = NSTextAlignmentCenter;
            data[i][5].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][5]];
        }
        else
            data[i][5].frame = CGRectMake(375+xOffset, 90+(15*i), 100, 20);

    }

    if (step == 0)
    {
        if (!infoHeader)
        {
            infoHeader = [[UILabel alloc] initWithFrame:CGRectMake(25+xOffset, 130, 750, 20)];
            infoHeader.text = NSLocalizedString(@"Records of subsequent purification steps will be added here.", @"");
            infoHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
            infoHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
            infoHeader.shadowColor = [UIColor whiteColor];
            infoHeader.shadowOffset = CGSizeMake(0.0,0.5);
            infoHeader.backgroundColor = [UIColor clearColor];
            [self addSubview:infoHeader];
        }
        else infoHeader.frame = CGRectMake(25+xOffset, 140, 750, 20);
    }
        
}


@end
