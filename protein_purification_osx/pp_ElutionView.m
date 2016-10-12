//
//  pp_ElutionView.m
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 06/08/2012.
//
//

#import "pp_ElutionView.h"

//#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]
//#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

@implementation pp_ElutionView {

float xscale;
float yscale;
float xOffset;
float yOffset;
float labelXOffset;
    
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self)
    {
        xOffset = 60.0;
        yOffset = 40.0;
        labelXOffset = 0.0;
    }
    return self;
}

-(CGColorRef) CIColorToCGColor: (CIColor *) ciColor {
	CGColorSpaceRef colorSpace = [ciColor colorSpace];
	const CGFloat *components = [ciColor components];
	CGColorRef cgColor = CGColorCreate (colorSpace, components);
	CGColorSpaceRelease(colorSpace);
	return cgColor;
}

-(CGColorRef) NSColorToCGColor: (NSColor *) nsColor {
	CIColor *ciColor = [[CIColor alloc] initWithColor: nsColor];
	CGColorRef cgColor = [self CIColorToCGColor: ciColor];
	[ciColor release];
	return cgColor;
}

- (void) shadeSelection:(NSMutableArray*) coords no: (int) no
{
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextClipToRect(con, CGRectMake(xOffset*xscale,yOffset*yscale, 500.0*xscale, 320.0*yscale));
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(([[coords objectAtIndex:0] floatValue]+xOffset)*xscale,([[coords objectAtIndex:1] floatValue]+yOffset)*yscale)];
    for (int i=2; i<no; i+=2)
        [path lineToPoint:NSMakePoint(([[coords objectAtIndex:i] floatValue]+xOffset)*xscale,([[coords objectAtIndex:i+1] floatValue]+yOffset)*yscale)];
    [path closePath];
    [[NSColor colorWithCalibratedRed:0.266 green:0.266 blue:0.266 alpha:0.5] setFill];
    [path fill];
    [[NSColor blackColor] setStroke];
    [path stroke];
    CGContextRestoreGState(con);

    
}


- (void) create_line: (float) x1 y1:(float) y1 x2: (float) x2 y2: (float) y2 colour: (NSColor*) colour
{
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextMoveToPoint(con, (x1+xOffset)*xscale, (y1+yOffset)*yscale);
    CGContextAddLineToPoint(con, (x2+xOffset)*xscale, (y2+yOffset)*yscale);
    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:colour]);
    CGContextSetLineWidth(con, 1.0);
    CGContextStrokePath(con);
    CGContextRestoreGState(con);
    
}


- (void) create_polyline: (NSMutableArray*) coords colour: (NSColor*) colour no: (int) no
{
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    CGContextClipToRect(con, CGRectMake(xOffset*xscale,yOffset*yscale, 500.0*xscale, 320.0*yscale));
    CGContextMoveToPoint(con, ([[coords objectAtIndex:0] floatValue]+xOffset)*xscale, ([[coords objectAtIndex:1] floatValue]+yOffset)*yscale);
    for (int i=2; i<no; i+=2)
        CGContextAddLineToPoint(con, ([[coords objectAtIndex:i] floatValue]+xOffset)*xscale, ([[coords objectAtIndex:i+1] floatValue]+yOffset)*yscale);
    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:colour]);
    CGContextSetLineWidth(con, 1.0);
    CGContextStrokePath(con);
    CGContextRestoreGState(con);
    
}


- (void) create_text_in_box:(NSString*) text rect: (CGRect) rect size:(float) size colour: (NSColor*) colour angle: (float) angle italic: (bool) italic alignment: (int) alignment
{
    
    float x,y;
    
    CGContextRef con = [[NSGraphicsContext currentContext] graphicsPort];

    CGContextSaveGState(con);
    
    // Flip the context vertically
    CGContextTranslateCTM(con, 0, self.frame.size.height);
    CGContextScaleCTM(con, 1.0, -1.0);
    
    // Set text rotation
    CGContextSetTextMatrix (con, CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.0, -1.0 ), angle));

    // CGContextShowTextAtPoint only works with C strings encoded with MacOSRoman, not UTF8 or UTF16
    // so the text has to be transcoded.
    NSData *strData = [text dataUsingEncoding:NSMacOSRomanStringEncoding allowLossyConversion:YES];
    char string[[strData length] + 1];
    memcpy(string, [strData bytes], [strData length] + 1);
    string[[strData length]] = '\0';
    
    // set the font
    NSFont* font;
    if (italic)
        font = [NSFont fontWithName:@"Helvetica-Oblique" size:size];
    else
        font = [NSFont fontWithName:@"Helvetica" size:size];
    
    const char* fontName = [font.fontName UTF8String];
    
    CGContextSelectFont( con, fontName, size, kCGEncodingMacRoman);
    
    CGContextSetStrokeColorWithColor(con, [self NSColorToCGColor:colour]);
    CGContextSetFillColorWithColor(con, [self NSColorToCGColor:colour]);
    
    // convert the sender rectangle to real coordinates
    CGRect ourRect = CGRectMake((rect.origin.x+xOffset)*xscale,(rect.origin.y+yOffset)*yscale, rect.size.width*xscale, rect.size.height*yscale );

    // work out the size of the rectangle bounding the text
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSFont fontWithName:@"Helvetica" size:size], NSFontAttributeName,
                                [NSParagraphStyle defaultParagraphStyle], NSParagraphStyleAttributeName,
                                nil];
    
    NSSize expectedSize = [text sizeWithAttributes:attributes];


    if (angle==0)
    {
        if (alignment==centre) // centered
        {
            x = ourRect.origin.x + ((ourRect.size.width-expectedSize.width)/2.0);
            y = ourRect.origin.y + expectedSize.height/yscale/2.5;
        }
        else if (alignment==right) // right-aligned
        {
            x = ourRect.origin.x + (ourRect.size.width-expectedSize.width);
            y = ourRect.origin.y + expectedSize.height/yscale/2.5;
        }
        else
        {
            x = ourRect.origin.x; // default is left-aligned
            y = ourRect.origin.y + expectedSize.height/yscale/2.5;
        }
    }
    else if (angle > 0.0) // assuming 90 degree rotation anticlockwise
    {
        y = ourRect.origin.y + ourRect.size.height - ((ourRect.size.height-expectedSize.width)/2.0);
        x = ourRect.origin.x + ourRect.size.width;
    }
    else // assuming 90 degree rotation clockwise
    {
        y = ourRect.origin.y + ((ourRect.size.height-expectedSize.width)/2.0);
        x = ourRect.origin.x;        
    }
    
    CGContextShowTextAtPoint(con, x, y, string, strlen(string));
    
    CGContextRestoreGState(con);
}

- (void) drawFrame:(bool) activity gradient: (bool) gradient
{
    
    // Add the title
    
    NSString* title = [NSString stringWithFormat:NSLocalizedString(@"%@ on %@",@""),app.separation.sepString,app.separation.mediumString];
    [self create_text_in_box:title
                        rect:CGRectMake(0.0, -30.0, 500.0, 0.0)
                        size:20.0
                      colour:[NSColor blackColor]
                       angle:0
                      italic:YES
                   alignment:centre];
  
    // Draw the frame
    [self create_line:0.0 y1:324.0 x2:499.0 y2:324.0 colour:[NSColor darkGrayColor]];
    [self create_line:499.0 y1:324.0 x2:499.0 y2:0.0 colour:[NSColor darkGrayColor]];
    [self create_line:499.0 y1:0.0 x2:0.0 y2:0.0 colour:[NSColor whiteColor]];
    [self create_line:0.0 y1:0.0 x2:0.0 y2:324.0 colour:[NSColor whiteColor]];
    
    // Add the fractions position marks
    for(int i=1; i<13; i++)
    {
     //   [self create_line: -4.0+i*40.0 y1:324.0 x2:-4.0+i*40.0 y2:319.0 colour:[NSColor whiteColor]];
        [self create_line: -3.0+i*40.0 y1:324.0 x2:-3.0+i*40.0 y2:319.0 colour:[NSColor darkGrayColor]];
     //   [self create_line: -24.0+i*40.0 y1:324.0 x2:-24.0+i*40.0 y2:322.0 colour:[NSColor whiteColor]];
        [self create_line: -23.0+i*40.0 y1:324.0 x2:-23.0+i*40.0 y2:322.0 colour:[NSColor darkGrayColor]];
    }
    
    // Draw the Absorbance axis tick marks
    
    [self create_line: 1.0 y1:316.0 x2:5.0 y2:316.0 colour:[NSColor darkGrayColor]];
    [self create_line: 1.0 y1:162.0 x2:5.0 y2:162.0 colour:[NSColor darkGrayColor]];
    [self create_line: 1.0 y1:8.0 x2:5.0 y2:8.0 colour:[NSColor darkGrayColor]];
    
    // Draw the Absorbance title
    
    [self create_text_in_box:NSLocalizedString(@"Absorbance at 280 nm",@"")
                        rect:CGRectMake(-48.0,0.0,8.0,325.0)
                        size:15.0
                      colour:[NSColor blueColor]
                       angle:M_PI/2.0
                      italic:NO
                   alignment:centre];
    
    // Add the Absorbance labels
    
    [self create_text_in_box:[NSString stringWithFormat:@"%.1f",app.commands.scale*4.0]
                      //  rect:CGRectMake(-15.0,24.0+labelYOffset,8.0,0.0)
                        rect:CGRectMake(-15.0,8.0,8.0,0.0)
                        size:15.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    [self create_text_in_box:[NSString stringWithFormat:@"%.1f",app.commands.scale*2.0]
                    //    rect:CGRectMake(-15.0,178.0+labelYOffset,8.0,0.0)
                        rect:CGRectMake(-15.0,162.0,8.0,0.0)
                        size:15.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    [self create_text_in_box:[NSString stringWithFormat:@"%d",0]
                   //     rect:CGRectMake(-15.0,332.0+labelYOffset,8.0,0.0)
                        rect:CGRectMake(-15.0,316.0,8.0,0.0)
                        size:15.0
                      colour:[NSColor blackColor]
                       angle:0.0
                      italic:NO
                   alignment:right];
    
    // Add the fraction numbers
    for(int i=1; i<13; i++)
    {
        float xpos = labelXOffset+i*40.0;
        [self create_text_in_box:[NSString stringWithFormat:@"%d",i*10]
                            rect:CGRectMake(xpos,330.0,40.0,0.0)
                            size:12.0
                          colour:[NSColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:centre];
    }
    
    // Add the fraction label
    [self create_text_in_box:NSLocalizedString(@"Fraction number",@"")
                        rect:CGRectMake(0.0, 343.0, 500.0, 0.0)
                        size:15.0
                      colour:[NSColor blackColor]
                       angle:0
                      italic:NO
                   alignment:centre];
    
    if (activity)
    {
        // Add the Enzyme title
        [self create_text_in_box:NSLocalizedString(@"Enzyme activity (Units/fraction)",@"")
                            rect:CGRectMake(530.0,0.0,8.0,325.0)
                            size:15.0
                          colour:[NSColor redColor]
                           angle:-M_PI/2.0
                          italic:NO
                       alignment:centre];
        
        // Add the Enzyme labels
        [self create_text_in_box:[NSString stringWithFormat:@"%d",0]
                            rect:CGRectMake(508.0,316.0,8.0,0.0)
                            size:15.0
                          colour:[NSColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:left];
        [self create_text_in_box:[NSString stringWithFormat:@"%d",(int)round([app.proteinData GetCurrentActivityOfProtein:app.proteinData.enzyme]*800.0*app.commands.scale/3.0)]
                            rect:CGRectMake(508.0,8.0,8.0,0.0)
                            size:15.0
                          colour:[NSColor blackColor]
                           angle:0.0
                          italic:NO
                       alignment:left];
    }
     
    if (gradient)
    {
        
        if (app.commands.startGrad > app.commands.endGrad)
        {
            [self create_line:124.0 y1:8.0 x2:499.0 y2:316.0 colour:[NSColor magentaColor]];
            [self create_line:0.0 y1:8.0 x2:124.0 y2:8.0 colour:[NSColor magentaColor]];
        }
        else
        {
            [self create_line:124.0 y1:316.0 x2:499.0 y2:8.0 colour:[NSColor magentaColor]];
            [self create_line:0.0 y1:316.0 x2:124.0 y2:316.0 colour:[NSColor magentaColor]];
        }
        
        if (activity==NO)
        {
            
            NSString* startString;
            NSString* endString;
            
            if (app.commands.startGrad < 0.05) startString=@"0";
            else startString = [NSString stringWithFormat:@"%.1f",app.commands.startGrad];
            
            if (app.commands.endGrad < 0.05) endString=@"0";
            else endString = [NSString stringWithFormat:@"%.1f",app.commands.endGrad];
            
            if (app.commands.gradientIsSalt)
            {
                
                // Add the gradient title
                [self create_text_in_box:NSLocalizedString(@"Salt concentration (molar)",@"")
                                    rect:CGRectMake(530.0,0.0,8.0,325.0)
                                    size:15.0
                                  colour:[NSColor magentaColor]
                                   angle:-M_PI/2.0
                                  italic:NO
                               alignment:centre];
                if (app.commands.endGrad > app.commands.startGrad)
                {
                    // Add the gradient labels
                    [self create_text_in_box:startString
                                        rect:CGRectMake(508.0,316.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    [self create_text_in_box:endString
                                        rect:CGRectMake(508.0,8.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                }
                else
                {
                    [self create_text_in_box:endString
                                        rect:CGRectMake(508.0,316.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    
                    [self create_text_in_box:startString
                                        rect:CGRectMake(508.0,8.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                }
            }
            else
            {
                
                // Add the gradient title
                [self create_text_in_box:NSLocalizedString(@"pH",@"")
                                    rect:CGRectMake(530.0,160.0,10.0,8.0)
                                    size:15.0
                                  colour:[NSColor magentaColor]
                                   angle:0
                                  italic:NO
                               alignment:left];
                if (app.commands.endGrad > app.commands.startGrad)
                {
                    // Add the gradient labels
                    [self create_text_in_box:startString
                                        rect:CGRectMake(508.0,316.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    [self create_text_in_box:endString
                                        rect:CGRectMake(508.0,8.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                }
                else
                {
                    [self create_text_in_box:endString
                                        rect:CGRectMake(508.0,316.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                    [self create_text_in_box:startString
                                        rect:CGRectMake(508.0,8.0,8.0,0.0)
                                        size:15.0
                                      colour:[NSColor blackColor]
                                       angle:0.0
                                      italic:NO
                                   alignment:left];
                }
            }
            
        }
    }
    
    if (app.commands.sepType == Affinity)  // Footer for Affinity chromatography
    {
        NSString* footer = [NSString stringWithFormat:NSLocalizedString(@"(Elution buffer emerges at fraction 40)",@""),app.separation.sepString,app.separation.mediumString];
        [self create_text_in_box:footer
                            rect:CGRectMake(0.0, 365.0, 500.0, 0.0)
                            size:12.0
                          colour:[NSColor blackColor]
                           angle:0
                          italic:NO
                       alignment:centre];
    }
}

- (void) drawElution:(bool) activity gradient: (bool) gradient pooled: (bool) pool
{
    
    [self drawFrame: activity gradient: gradient];
    
    NSMutableArray* blue_coords= [[NSMutableArray alloc]init];
    
    float x = 1.0;
    float y = 316.0 - [app.separation GetPlotElement:1 protein:0]/app.commands.scale;
    
    [blue_coords addObject:[NSNumber numberWithFloat:x]];
    [blue_coords addObject:[NSNumber numberWithFloat:y]];
    
    int pos = 2;
    for (int i=2; i< 251; i++)
    {
        x = 2.0*((float)i - 1.0);
        y = 316.0 - [app.separation GetPlotElement:i protein:0]/app.commands.scale;

        [blue_coords addObject:[NSNumber numberWithFloat:x]];
        [blue_coords addObject:[NSNumber numberWithFloat:y]];
        pos+=2;
    }
    [self create_polyline:blue_coords colour: [NSColor blueColor] no: pos-1];
    
 
    if (activity)
    {
        
        NSMutableArray* red_coords= [[NSMutableArray alloc]init];
        
        x = 1.0;
        
        float origin = 315.0;
        
        y = origin;
        
        pos = 0;

        for (int i=1; i<251; i++)
        {
            
            float oldx = x;
            float oldy = y;
            
            x = 2.0*((float)i - 1.0);
            y = (316.0 - [app.separation GetPlotElement:i protein:app.proteinData.enzyme]*4.0*(float)[app.proteinData GetCurrentActivityOfProtein:app.proteinData.enzyme]/app.commands.scale);
            
            if ((oldy==origin) && (y < origin))
            {
                
                [red_coords addObject:[NSNumber numberWithFloat:oldx]];
                [red_coords addObject:[NSNumber numberWithFloat:oldy]];
                pos+=2;
            }
            if ((y < origin) || (oldy < origin))
            {
                
                [red_coords addObject:[NSNumber numberWithFloat:x]];
                [red_coords addObject:[NSNumber numberWithFloat:y]];
                pos+=2;
            }
            
        }
        
        if (pos > 0 )
        {
            [self create_polyline:red_coords colour:[NSColor redColor] no:pos-1];
        }
    }

    if (pool) {
        
        NSMutableArray* black_coords = [[NSMutableArray alloc]init];
        
        int start_pool = 2 * app.commands.startOfPool - 1;
        int end_pool = 2 * app.commands.endOfPool;
        
        float origin = 316.0;
        
        x = 2.0*((float)start_pool - 1.0);
        y = origin;
        
        pos = 0;
        
        [black_coords addObject:[NSNumber numberWithFloat:x]];
        [black_coords addObject:[NSNumber numberWithFloat:y]];
        pos+=2;
        
        for (int i=start_pool; i<= end_pool; i++)
        {
            x = 2.0*((float)i - 1.0);
            y = (316.0 - [app.separation GetPlotElement:i protein:0]/app.commands.scale);
            
            [black_coords addObject:[NSNumber numberWithFloat:x]];
            [black_coords addObject:[NSNumber numberWithFloat:y]];
            pos+=2;
        }
        [black_coords addObject:[NSNumber numberWithFloat:x]];
        [black_coords addObject:[NSNumber numberWithFloat:origin]];
        pos+=2;
        
        x = 2.0*((float)start_pool - 1.0);
        y = origin;
        
        [black_coords addObject:[NSNumber numberWithFloat:x]];
        [black_coords addObject:[NSNumber numberWithFloat:y]];
        pos++;
        
        [self shadeSelection:black_coords no:pos];
    }

}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(NSRect)rect
{
    NSBezierPath* path = [NSBezierPath bezierPathWithRect:self.bounds];
    [app.bgColor setFill];
    [path fill];
    
    float xsize = self.frame.size.width;
    float ysize = self.frame.size.height;
    
    xscale = xsize/640.0;
    yscale = ysize/480.0;
    xOffset = 70.0;
    yOffset = 70.0;
    labelXOffset = -23.0;
    
   // NSLog(@"Assayed is %d, Gradient is %d, Pooled is %d",app.commands.assayed,app.commands.hasGradient,app.commands.pooled);
    
    [self drawElution:app.commands.assayed gradient:app.commands.hasGradient  pooled:app.commands.pooled];
}


@end
