//
//  pp_GetProteinView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 30/07/2012.
//
//

#import "pp_GetPoolView.h"

@implementation pp_GetPoolView

UILabel* poolHeader;
UIPickerView* poolPicker;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        poolHeader = nil;
        poolPicker = nil;
    }
    return self;
}

- (void) create_centred_text_in_box: (NSString*) text rect: (CGRect) rect size:(float) size colour:(UIColor*) colour angle: (float) angle
{
    
    float x,y;
    
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    // Set text rotation
    CGContextSetTextMatrix (con, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f ), angle));
    
    
    // CGContextShowTextAtPoint only works with C strings encoded with MacOSRoman, not UTF8 or UTF16
    // so the text has to be transcoded.
    NSData *strData = [text dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:YES];
    char string[[strData length] + 1];
    memcpy(string, [strData bytes], [strData length] + 1);
    string[[strData length]] = '\0';
    
    // set the font
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:size];
    
    const char* fontName = [font.fontName UTF8String];
    
    CGContextSelectFont( con, fontName, size, kCGEncodingMacRoman);
    CGContextSetStrokeColorWithColor(con, colour.CGColor);
    CGContextSetFillColorWithColor(con, colour.CGColor);
    
    // work out the size of the bounding rectangle
    CGSize expectedSize = [text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:size] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    
    if (angle==0)
    {
        x = rect.origin.x + ((rect.size.width-expectedSize.width)/2.0);
        y = rect.origin.y - ((rect.size.height-expectedSize.height)/2.0);
    }
    else if (angle > 0.0)
    {
        y = rect.origin.y + rect.size.height - ((rect.size.height-expectedSize.width)/2.0);
        x = rect.origin.x + rect.size.width;
    }
    else
    {
        y = rect.origin.y + ((rect.size.height-expectedSize.width)/2.0);
        x = rect.origin.x;        
    }
    
    CGContextShowTextAtPoint(con, x, y, string, strlen(string));
    
    CGContextRestoreGState(con);
}

- (void) drawRoundRect
{
    CGContextRef con = UIGraphicsGetCurrentContext();
    CGContextSaveGState(con);
    CGContextSetStrokeColorWithColor(con, [UIColor grayColor].CGColor);
    CGContextSetFillColorWithColor(con, [UIColor whiteColor].CGColor);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 36, 220, 210) cornerRadius:10.0];
    [path fill];
    path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, 36, 220, 208) cornerRadius:10.0];
    [path fill];
    [path stroke];
    CGContextRestoreGState(con);
    
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
    
        
    if (!poolHeader)
    {
        poolHeader = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 21)];
        poolHeader.font = [UIFont fontWithName:@"Helvetica" size:13.0];
        poolHeader.text = NSLocalizedString(@"Pool fractions",@"").uppercaseString;
        poolHeader.shadowOffset = CGSizeMake(0.0,0.5);
        poolHeader.textColor = [UIColor colorWithRed:76.0/256.0 green:86.0/256.0 blue:108.0/256.0 alpha:1.0];
        poolHeader.shadowColor = [UIColor whiteColor];
        poolHeader.backgroundColor = [UIColor clearColor];
        [self addSubview:poolHeader];
    }
    else
        poolHeader.frame = CGRectMake(20, 10, 250, 21);
    
 
    if (!poolPicker)
    {
        poolPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 50, 135, 162)];
        poolPicker.dataSource = self;
        poolPicker.delegate = self;
        poolPicker.showsSelectionIndicator = YES;
        [self addSubview:poolPicker];
    }
    poolPicker.center = CGPointMake(120, 140);
    
    [self create_centred_text_in_box: NSLocalizedString(@"First fraction",@"")
                                rect:CGRectMake(30,50,8,180)
                                size:17
                              colour:[UIColor blackColor]
                               angle: M_PI/2.0];
    
    [self create_centred_text_in_box:NSLocalizedString(@"Last fraction",@"")
                                rect:CGRectMake(200,50,8,180)
                                size:17
                              colour:[UIColor blackColor]
                               angle:-M_PI/2.0];
      
    [poolPicker selectRow:app.commands.startOfPool-1 inComponent:0 animated:YES];
    [poolPicker selectRow:app.commands.endOfPool-1 inComponent:1 animated:YES];
}


#pragma mark - Picker View

/* Defines the total number of Components (like groups in a UITableView) in a UIPickerView */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
 {
     return 2;
 }

/* What to do when a row from a UIPickerView is selected. This will trigger each time the UIPickerViewis scrolled, so only lightweight stuff. */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
 {
     int value0 = [pickerView selectedRowInComponent:0];
     int value1 = [pickerView selectedRowInComponent:1];

     switch (component)
     {
                 
         case 0:    //first fraction
             if (value1 < value0)
                 [pickerView selectRow:value0 inComponent:1 animated:YES];
             break;
             
         case 1:    //last fraction
             if (value0 > value1)
                 [pickerView selectRow:value1 inComponent:0 animated:YES];
             break;
     }
     
     app.commands.startOfPool = [pickerView selectedRowInComponent:0]+1;
     app.commands.endOfPool = [pickerView selectedRowInComponent:1]+1;
     [((pp_ElutionViewController*)app.splitViewController.delegate).view setNeedsDisplay];
 }
 
 
 - (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
 {
     return 125;
 }
 
 
 // Using a label rather than a string - it looks nicer.
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
 {
     view = nil;
 
     UILabel *label = [[UILabel alloc] init];
     label.textColor = [UIColor blackColor];
     label.backgroundColor = [UIColor clearColor];
     label.text = [NSString stringWithFormat:@"%d",row+1];
     [label sizeToFit];
     return label;
 }
@end
