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
        case Hydrophobic_interaction:   return NSLocalizedString(@"Hydrophobic interaction",@"");
        case Affinity:                  return NSLocalizedString(@"Affinity chromatography",@"");
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
    
       
    if (!mixtureButton)
    {
        mixtureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mixtureButton.backgroundColor = [UIColor clearColor];
        [mixtureButton setEnabled:NO];
        [self addSubview:mixtureButton];
    }
    mixtureButton.frame = CGRectMake(10+xOffset, 34, 680, 40);

    if (!pureTitleP)
    {  
        pureTitleP = [[UILabel alloc] initWithFrame:CGRectMake(25+xOffset, 40, 640, 30)];
        pureTitleP.text = [NSString stringWithFormat:NSLocalizedString(@"Purification of protein %d from %@",@""),app.proteinData.enzyme, app.proteinData.mixtureName];
        pureTitleP.textAlignment = NSTextAlignmentCenter;
        pureTitleP.backgroundColor = [UIColor clearColor];
        pureTitleP.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        pureTitleP.numberOfLines = 1;
        [self addSubview:pureTitleP];
    }
    else
        pureTitleP.frame = CGRectMake(25+xOffset, 44, 640, 20);
    
    if (!methodHeader)
    {
        methodHeader = [[UILabel alloc] initWithFrame:CGRectMake(25+xOffset, 100, 150, 20)];
        methodHeader.text = NSLocalizedString(@"Method", @"");
        methodHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        methodHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        methodHeader.shadowColor = [UIColor whiteColor];
        methodHeader.shadowOffset = CGSizeMake(0.0,0.5);
        methodHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:methodHeader];
    }
    else methodHeader.frame = CGRectMake(25+xOffset, 100, 150, 20);
    
    if (!proteinHeader)
    {
        proteinHeader = [[UILabel alloc] initWithFrame:CGRectMake(200+xOffset, 100, 110, 20)];
        proteinHeader.text = NSLocalizedString(@"Protein (mg)", @"");
        proteinHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        proteinHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        proteinHeader.shadowColor = [UIColor whiteColor];
        proteinHeader.shadowOffset = CGSizeMake(0.0,0.5);
        proteinHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:proteinHeader];
    }
    else proteinHeader.frame = CGRectMake(200+xOffset, 100, 110, 20);
    
    if (!enzymeHeader)
    {
        enzymeHeader = [[UILabel alloc] initWithFrame:CGRectMake(310+xOffset, 100, 150, 20)];
        enzymeHeader.text = NSLocalizedString(@"Enzyme (Units)", @"");
        enzymeHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        enzymeHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        enzymeHeader.shadowColor = [UIColor whiteColor];
        enzymeHeader.shadowOffset = CGSizeMake(0.0,0.5);
        enzymeHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:enzymeHeader];
    }
    else enzymeHeader.frame = CGRectMake(310+xOffset, 100, 130, 20);
    
    if (!yieldHeader)
    {
        yieldHeader = [[UILabel alloc] initWithFrame:CGRectMake(440+xOffset, 100, 80, 20)];
        yieldHeader.text = NSLocalizedString(@"Yield (%)", @"");
        yieldHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        yieldHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        yieldHeader.shadowColor = [UIColor whiteColor];
        yieldHeader.shadowOffset = CGSizeMake(0.0,0.5);
        yieldHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:yieldHeader];
    }
    else yieldHeader.frame = CGRectMake(440+xOffset, 100, 80, 20);
        
    if (!enrichHeader)
    {
        enrichHeader = [[UILabel alloc] initWithFrame:CGRectMake(520+xOffset, 100, 100, 20)];
        enrichHeader.text = NSLocalizedString(@"Enrichment", @"");
        enrichHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        enrichHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        enrichHeader.shadowColor = [UIColor whiteColor];
        enrichHeader.shadowOffset = CGSizeMake(0.0,0.5);
        enrichHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:enrichHeader];
    }
    else enrichHeader.frame = CGRectMake(520+xOffset, 100, 100, 20);
    
    if (!costHeader)
    {
        costHeader = [[UILabel alloc] initWithFrame:CGRectMake(620+xOffset, 100, 100, 20)];
        costHeader.text = NSLocalizedString(@"Cost", @"");
        costHeader.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        costHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        costHeader.shadowColor = [UIColor whiteColor];
        costHeader.shadowOffset = CGSizeMake(0.0,0.5);
        costHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:costHeader];
    }
    else costHeader.frame = CGRectMake(620+xOffset, 100, 100, 20);

    
    int step = app.proteinData.step;

    /*
    if (!reportButton)
    {
        reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        reportButton.backgroundColor = [UIColor clearColor];
        [reportButton setEnabled:NO];
        [self addSubview:reportButton];
    }
    reportButton.frame = CGRectMake(10+xOffset, 125, 680, 30+(20*step));
    */
    [self drawButton:CGRectMake(10+xOffset, 125, 680, 30+(20*step))];

    
    for (int i=0; i<=step; i++)
    {

        pp_StepRecord* record = [app.account getStepRecord:i];


        NSString* method = [self getMethodString:[record getStepType]];

        // Method
        if (! data[i][0])
        {
            data[i][0] = [[UILabel alloc] initWithFrame:CGRectMake(25+xOffset, 130+(20*i), 640, 20)];
            data[i][0].text = method;

            data[i][0].backgroundColor = [UIColor clearColor];
            data[i][0].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][0].numberOfLines = 1;
            [self addSubview:data[i][0]];
        }
        else
        {
            data[i][0].frame = CGRectMake(25+xOffset, 130+(20*i), 640, 20);
            data[i][0].text = method;
            data[i][0].backgroundColor = [UIColor clearColor];
            data[i][0].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][0].numberOfLines = 1;
        }
        // Protein
        if (! data[i][1])
        {
            data[i][1] = [[UILabel alloc] initWithFrame:CGRectMake(185+xOffset, 130+(20*i), 110, 20)];
            data[i][1].text = [NSString stringWithFormat:@"%d", (int)round([record getProteinAmount])];
            if ([record getProteinAmount]==0.0) data[i][1].text = @"0";
            data[i][1].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][1].textAlignment = NSTextAlignmentCenter;
            data[i][1].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][1]];
        }
        else
            data[i][1].frame = CGRectMake(185+xOffset, 130+(20*i), 110, 20);
        // Enzyme Units
        if (! data[i][2])
        {
            data[i][2] = [[UILabel alloc] initWithFrame:CGRectMake(300+xOffset, 130+(20*i), 130, 20)];
            data[i][2].text = [NSString stringWithFormat:@"%d", (int)round([record getEnzymeUnits])];
            if ([record getEnzymeUnits]==0.0) data[i][2].text = @"0";
            data[i][2].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][2].textAlignment = NSTextAlignmentCenter;
            data[i][2].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][2]];
        }
        else
            data[i][2].frame = CGRectMake(300+xOffset, 130+(20*i), 130, 20);
        // Enzyme Yield
        if (! data[i][3])
        {
            data[i][3] = [[UILabel alloc] initWithFrame:CGRectMake(430+xOffset, 130+(20*i), 80, 20)];
            data[i][3].text = [NSString stringWithFormat:@"%.1f", [record getEnzymeYield]];
            if ([record getEnzymeYield]==0.0) data[i][3].text = @"0";
            if ([record getEnzymeYield]==100.0) data[i][3].text = @"100";
            data[0][3].text = @"100";
            data[i][3].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][3].textAlignment = NSTextAlignmentCenter;
            data[i][3].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][3]];
        }
        else
            data[i][3].frame = CGRectMake(430+xOffset, 130+(20*i), 80, 20);
        // Enrichment
        if (! data[i][4])
        {
            data[i][4] = [[UILabel alloc] initWithFrame:CGRectMake(510+xOffset, 130+(20*i), 100, 20)];
            data[i][4].text = [NSString stringWithFormat:@"%.1f", [record getEnrichment]];
            if ([record getEnrichment]==0.0) data[i][4].text = @"!";
            data[i][4].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][4].textAlignment = NSTextAlignmentCenter;
            data[i][4].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][4]];
        }
        else
            data[i][4].frame = CGRectMake(510+xOffset, 130+(20*i), 100, 20);
        // Cost
        if (! data[i][5])
        {
            data[i][5] = [[UILabel alloc] initWithFrame:CGRectMake(588+xOffset, 130+(20*i), 100, 20)];
            data[i][5].text = [NSString stringWithFormat:@"%.3f", [record getCosting]];
            if ([record getCosting]==0.0) data[i][5].text = @"0";
            data[i][5].font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
            data[i][5].textAlignment = NSTextAlignmentCenter;
            data[i][5].backgroundColor = [UIColor clearColor];
            [self addSubview:data[i][5]];
        }
        else
            data[i][5].frame = CGRectMake(588+xOffset, 130+(20*i), 100, 20);

    }

    if (step == 0)
    {
        if (!infoHeader)
        {
            infoHeader = [[UILabel alloc] initWithFrame:CGRectMake(25+xOffset, 170, 750, 20)];
            infoHeader.text = NSLocalizedString(@"Records of subsequent purification steps will be added here.", @"");
            infoHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
            infoHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
            infoHeader.shadowColor = [UIColor whiteColor];
            infoHeader.shadowOffset = CGSizeMake(0.0,1.0);
            infoHeader.backgroundColor = [UIColor clearColor];
            [self addSubview:infoHeader];
        }
        else infoHeader.frame = CGRectMake(25+xOffset, 170, 750, 20);
    }
        
}


@end
