//
//  pp_GetProteinView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_GetProteinView.h"

@implementation pp_GetProteinView {
    
    UILabel* proteinHeader;
    UILabel *proteinMixture;
    UILabel *proteinLabel;
    CPPickerView* proteinPicker;
    
}

@synthesize proteinValue;
@synthesize mixtureName;
@synthesize noOfProteins;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        app.proteinData.enzyme = 1;
        
        proteinHeader = nil;
        proteinMixture = nil;
        proteinLabel = nil;
        proteinPicker = nil;
    }
    return self;
}

- (void) drawButton:(CGRect) rect
{
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextSetStrokeColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-20.0,rect.origin.y,1000.0,rect.size.height+2.0) cornerRadius:10.0];
    [path fill];
    CGContextRestoreGState(con);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    
    [self drawButton:CGRectMake(10, 36, 220, 208)];
    
    if (!proteinHeader)
    {
        proteinHeader = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 250, 21)];
        proteinHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        proteinHeader.text = NSLocalizedString(@"Choose a protein",@"").uppercaseString;
        proteinHeader.shadowOffset = CGSizeMake(0.0,0.5);
        proteinHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        proteinHeader.shadowColor = [UIColor whiteColor];
        proteinHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:proteinHeader];
    }
    else
        proteinHeader.frame = CGRectMake(12, 10, 250, 21);
    
    if (!proteinMixture)
    {
        proteinMixture = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 200, 50)];
        proteinMixture.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        proteinMixture.textColor = [UIColor blackColor];
        proteinMixture.backgroundColor = [UIColor clearColor];
        proteinMixture.text = self.mixtureName;
        proteinMixture.textAlignment = NSTextAlignmentCenter;
        proteinLabel.numberOfLines = 1;
        [self addSubview:proteinMixture];
    }
    else
        proteinMixture.frame = CGRectMake(20, 60, 200, 50);
    
    if (!proteinLabel)
    {
        proteinLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 200, 70)];
        proteinLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        proteinLabel.textColor = [UIColor blackColor];
        proteinLabel.backgroundColor = [UIColor clearColor];
        proteinLabel.text = [NSString stringWithFormat:NSLocalizedString(@"This mixture contains...",@""),self.noOfProteins];
        proteinLabel.numberOfLines = 3;
        proteinLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:proteinLabel];
    }
    else
        proteinLabel.frame = CGRectMake(20, 100, 200, 70);
    
    if (!proteinPicker)
    {
        proteinPicker = [[CPPickerView alloc] initWithFrame:CGRectMake(192, 8, 112, 30)];
        [self addSubview:proteinPicker];
        proteinPicker.delegate = self;
        proteinPicker.dataSource = self;
        proteinPicker.itemFont = [UIFont boldSystemFontOfSize:14];
        proteinPicker.itemColor = [UIColor blackColor];
        proteinPicker.showGlass = YES;
        proteinPicker.peekInset = UIEdgeInsetsMake(0, 35, 0, 35);
        [proteinPicker reloadData];
        [proteinPicker setSelectedItem:0];
    }
    proteinPicker.center = CGPointMake(120,200);
}


#pragma CPPickerView

- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return self.noOfProteins;
}

- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%d",item+1];
}

- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item
{
    app.proteinData.enzyme = item+1;
}
@end
