//
//  pp_RecordView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 25/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_RecordView.h"

@implementation pp_RecordView

NSButton* mixtureButton;
NSTextField* pureTitleP;
NSTextField* methodHeader;
NSTextField* proteinHeader;
NSTextField* enzymeHeader;
NSTextField* yieldHeader;
NSTextField* enrichHeader;
NSTextField* costHeader;
NSButton* reportButton;
NSTextField* infoHeader;

NSTextField* data[11][6];

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

- (void)drawRect:(NSRect)dirtyRect
{
    float ratio = self.bounds.size.width/1110.0;
    

    
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:self.bounds];
    [app.bgColor setFill];
    [path fill];
    
    path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(50.0*ratio,self.bounds.size.height-(54.0*ratio),self.bounds.size.width-(100.0*ratio),40*ratio) xRadius:20.0*ratio yRadius:20.0*ratio];
    [[NSColor whiteColor] setFill];
    [[NSColor blackColor] setStroke];
    [path fill];
    [path stroke];
  
    pureTitleP = [[NSTextField alloc] initWithFrame:NSMakeRect(0, self.bounds.size.height - (50.0*ratio), self.bounds.size.width, 30*ratio)];
    [pureTitleP setEditable:NO];
    [pureTitleP setBordered:NO];
    pureTitleP.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Purification of protein %d from %@",@""),app.proteinData.enzyme, app.proteinData.mixtureName];
    pureTitleP.alignment = NSCenterTextAlignment;
    pureTitleP.textColor = [NSColor blackColor];
    [pureTitleP setDrawsBackground:NO];
    pureTitleP.font = [NSFont fontWithName:@"Helvetica-Bold" size:20.0*ratio];
    [self addSubview:pureTitleP];
    
    
    
    methodHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(60*ratio, self.bounds.size.height - (100.0*ratio)-1, 150*ratio, 20*ratio)];
    [methodHeader setEditable:NO];
    [methodHeader setBordered:NO];
    methodHeader.stringValue = NSLocalizedString(@"Method", @"");
    methodHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    methodHeader.textColor = [NSColor whiteColor];
    [methodHeader setDrawsBackground:NO];
    [self addSubview:methodHeader];
    
    methodHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(60*ratio, self.bounds.size.height - (100.0*ratio), 150*ratio, 20*ratio)];
    [methodHeader setEditable:NO];
    [methodHeader setBordered:NO];
    methodHeader.stringValue = NSLocalizedString(@"Method", @"");
    methodHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    methodHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
    [methodHeader setDrawsBackground:NO];
    [self addSubview:methodHeader];
    
    
    proteinHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(350*ratio, self.bounds.size.height - (100.0*ratio)-1, 110*ratio, 20*ratio)];
    [proteinHeader setEditable:NO];
    [proteinHeader setBordered:NO];
    proteinHeader.stringValue = NSLocalizedString(@"Protein (mg)", @"");
    proteinHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    proteinHeader.textColor = [NSColor whiteColor];
    [proteinHeader setDrawsBackground:NO];
    [self addSubview:proteinHeader];
    
    proteinHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(350*ratio, self.bounds.size.height - (100.0*ratio), 110*ratio, 20*ratio)];
    [proteinHeader setEditable:NO];
    [proteinHeader setBordered:NO];
    proteinHeader.stringValue = NSLocalizedString(@"Protein (mg)", @"");
    proteinHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    proteinHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
    [proteinHeader setDrawsBackground:NO];
    [self addSubview:proteinHeader];
    
    enzymeHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(500*ratio, self.bounds.size.height - (100.0*ratio)-1, 150*ratio, 20*ratio)];
    [enzymeHeader setEditable:NO];
    [enzymeHeader setBordered:NO];
    enzymeHeader.stringValue = NSLocalizedString(@"Enzyme (Units)", @"");
    enzymeHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    enzymeHeader.textColor = [NSColor whiteColor];
    [enzymeHeader setDrawsBackground:NO];
    [self addSubview:enzymeHeader];
    
    enzymeHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(500*ratio, self.bounds.size.height - (100.0*ratio), 150*ratio, 20*ratio)];
    [enzymeHeader setEditable:NO];
    [enzymeHeader setBordered:NO];
    enzymeHeader.stringValue = NSLocalizedString(@"Enzyme (Units)", @"");
    enzymeHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    enzymeHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
    [enzymeHeader setDrawsBackground:NO];
    [self addSubview:enzymeHeader];
    
    yieldHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(680*ratio, self.bounds.size.height - (100.0*ratio)-1, 100*ratio, 20*ratio)];
    [yieldHeader setEditable:NO];
    [yieldHeader setBordered:NO];
    yieldHeader.stringValue = NSLocalizedString(@"Yield (%)", @"");
    yieldHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    yieldHeader.textColor = [NSColor whiteColor];
    [yieldHeader setDrawsBackground:NO];
    [self addSubview:yieldHeader];
    
    yieldHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(680*ratio, self.bounds.size.height - (100.0*ratio),100*ratio, 20.0*ratio)];
    [yieldHeader setEditable:NO];
    [yieldHeader setBordered:NO];
    yieldHeader.stringValue = NSLocalizedString(@"Yield (%)", @"");
    yieldHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    yieldHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
    [yieldHeader setDrawsBackground:NO];
    [self addSubview:yieldHeader];
    
    enrichHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(800*ratio, self.bounds.size.height - (100.0*ratio)-1, 100*ratio, 20*ratio)];
    [enrichHeader setEditable:NO];
    [enrichHeader setBordered:NO];
    enrichHeader.stringValue = NSLocalizedString(@"Enrichment", @"");
    enrichHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    enrichHeader.textColor = [NSColor whiteColor];
    [enrichHeader setDrawsBackground:NO];
    [self addSubview:enrichHeader];
    
    enrichHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(800*ratio, self.bounds.size.height - (100*ratio), 100*ratio, 20*ratio)];
    [enrichHeader setEditable:NO];
    [enrichHeader setBordered:NO];
    enrichHeader.stringValue = NSLocalizedString(@"Enrichment", @"");
    enrichHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    enrichHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
    [enrichHeader setDrawsBackground:NO];
    [self addSubview:enrichHeader];
    
    costHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(980*ratio, self.bounds.size.height - (100.0*ratio)-1, 100*ratio, 20*ratio)];
    [costHeader setEditable:NO];
    [costHeader setBordered:NO];
    costHeader.stringValue = NSLocalizedString(@"Cost", @"");
    costHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    costHeader.textColor = [NSColor whiteColor];
    [costHeader setDrawsBackground:NO];
    [self addSubview:costHeader];
    
    costHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(980*ratio, self.bounds.size.height - (100.0*ratio), 100*ratio, 20*ratio)];
    [costHeader setEditable:NO];
    [costHeader setBordered:NO];
    costHeader.stringValue = NSLocalizedString(@"Cost", @"");
    costHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
    costHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
    [costHeader setDrawsBackground:NO];
    [self addSubview:costHeader];
    
    int step = app.proteinData.step;

    
    path = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(50.0*ratio,self.bounds.size.height-((150.0+30*step)*ratio),self.bounds.size.width-(100.0*ratio),(40+(30*step))*ratio) xRadius:20.0*ratio yRadius:20.0*ratio];
    [[NSColor whiteColor] setFill];
    [[NSColor blackColor] setStroke];
    [path fill];
    [path stroke];
 
  
    
    for (int i=0; i<=step; i++)
    {
        pp_StepRecord* record = [app.account getStepRecord:i];
        NSString* method = [self getMethodString:[record getStepType]];
        
//pp_StepRecord* record = [app.account getStepRecord:0];  // debug
//NSString* method = [self getMethodString:i];

        data[i][0] = [[NSTextField alloc] initWithFrame:NSMakeRect(70*ratio, self.bounds.size.height - (150+(30*i))*ratio, 640*ratio, 30*ratio)];
        [data[i][0] setEditable:NO];
        [data[i][0] setBordered:NO];
        data[i][0].stringValue = method;
        data[i][0].textColor = [NSColor blackColor];
        [data[i][0]setDrawsBackground:NO];
        data[i][0].font = [NSFont fontWithName:@"Helvetica-Bold" size:14.0*ratio];
        [self addSubview:data[i][0]];
        
        data[i][1] = [[NSTextField alloc] initWithFrame:NSMakeRect(350*ratio, self.bounds.size.height - (150+(30*i))*ratio, 100*ratio, 30*ratio)];
        [data[i][1] setEditable:NO];
        [data[i][1] setBordered:NO];
        data[i][1].stringValue = [NSString stringWithFormat:@"%.1f", [record getProteinAmount]];
        if ([record getProteinAmount]==0.0) data[i][1].stringValue = @"0";
        data[i][1].font = [NSFont fontWithName:@"Helvetica-Bold" size:14.0*ratio];
        data[i][1].alignment = NSCenterTextAlignment;
        data[i][1].textColor = [NSColor blackColor];
        [data[i][1] setDrawsBackground:NO];
        [self addSubview:data[i][1]];
        
        data[i][2] = [[NSTextField alloc] initWithFrame:NSMakeRect(490*ratio, self.bounds.size.height - (150+(30*i))*ratio, 130*ratio, 30*ratio)];
        [data[i][2] setEditable:NO];
        [data[i][2] setBordered:NO];
        data[i][2].stringValue = [NSString stringWithFormat:@"%.1f", [record getEnzymeUnits]];
        if ([record getEnzymeUnits]==0.0) data[i][2].stringValue = @"0";
        data[i][2].font = [NSFont fontWithName:@"Helvetica-Bold" size:14.0*ratio];
        data[i][2].alignment = NSCenterTextAlignment;
        data[i][2].textColor = [NSColor blackColor];
        [data[i][2] setDrawsBackground:NO];
        [self addSubview:data[i][2]];
        
        data[i][3] = [[NSTextField alloc] initWithFrame:NSMakeRect(673*ratio, self.bounds.size.height - (150+(30*i))*ratio, 80*ratio, 30*ratio)];
        [data[i][3] setEditable:NO];
        [data[i][3] setBordered:NO];
        data[i][3].stringValue = [NSString stringWithFormat:@"%.1f", [record getEnzymeYield]];
        if ([record getEnzymeYield]==0.0) data[i][3].stringValue = @"0";
        if ([record getEnzymeYield]==100.0) data[i][3].stringValue = @"100";
        data[0][3].stringValue = @"100";
        data[i][3].font = [NSFont fontWithName:@"Helvetica-Bold" size:14.0*ratio];
        data[i][3].alignment = NSCenterTextAlignment;
        data[i][3].textColor = [NSColor blackColor];
        [data[i][3] setDrawsBackground:NO];
        [self addSubview:data[i][3]];
        
        data[i][4] = [[NSTextField alloc] initWithFrame:NSMakeRect(790*ratio, self.bounds.size.height - (150+(30*i))*ratio, 100*ratio, 30*ratio)];
        [data[i][4] setEditable:NO];
        [data[i][4] setBordered:NO];
        data[i][4].stringValue = [NSString stringWithFormat:@"%.1f", [record getEnrichment]];
        if ([record getEnrichment]==0.0) data[i][4].stringValue = @"!";
        data[i][4].font = [NSFont fontWithName:@"Helvetica-Bold" size:14.0*ratio];
        data[i][4].alignment = NSCenterTextAlignment;
        data[i][4].textColor = [NSColor blackColor];
        [data[i][4] setDrawsBackground:NO];
        [self addSubview:data[i][4]];
        
        data[i][5] = [[NSTextField alloc] initWithFrame:NSMakeRect(950*ratio, self.bounds.size.height - (150+(30*i))*ratio, 100*ratio, 30*ratio)];
        [data[i][5] setEditable:NO];
        [data[i][5] setBordered:NO];
        data[i][5].stringValue = [NSString stringWithFormat:@"%.3f", [record getCosting]];
        if ([record getCosting]==0.0) data[i][5].stringValue = @"0";
        data[i][5].font = [NSFont fontWithName:@"Helvetica-Bold" size:14.0*ratio];
        data[i][5].alignment = NSCenterTextAlignment;
        data[i][5].textColor = [NSColor blackColor];
        [data[i][5] setDrawsBackground:NO];
        [self addSubview:data[i][5]];
        
        
    }
    if (step == 0)
    {
        infoHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(60*ratio, self.bounds.size.height - (200*ratio)-1, 750*ratio, 30*ratio)];
        [infoHeader setEditable:NO];
        [infoHeader setBordered:NO];
        infoHeader.stringValue = NSLocalizedString(@"Records of subsequent purification steps will be added here.", @"");
        infoHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
        infoHeader.textColor = [NSColor whiteColor];
        [infoHeader setDrawsBackground:NO];
        [self addSubview:infoHeader];
        
        infoHeader = [[NSTextField alloc] initWithFrame:NSMakeRect(60*ratio, self.bounds.size.height - (200*ratio), 750*ratio, 30*ratio)];
        [infoHeader setEditable:NO];
        [infoHeader setBordered:NO];                                                           
        infoHeader.stringValue = NSLocalizedString(@"Records of subsequent purification steps will be added here.", @"");
        infoHeader.font = [NSFont fontWithName:@"Helvetica-Bold" size:15.0*ratio];
        infoHeader.textColor = [NSColor colorWithCalibratedRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        [infoHeader setDrawsBackground:NO];
        [self addSubview:infoHeader];
    }
    
}


@end
