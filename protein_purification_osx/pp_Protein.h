//
//  pp_Protein.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 20/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface pp_Protein : NSObject
{
	int no;
	NSMutableArray* charges;
	float isopoint;
	float MolWt;
	int NoOfSub1;
	int NoOfSub2;
	int NoOfSub3;
	float subunit1;
	float subunit2;
	float subunit3;
	float original_amount;
	float amount;
	float temp;
	float pH1;
	float pH2;
	float sulphate;
	int activity;
	int original_activity;
	float K1;
	float K2;
	float K3;
	BOOL hisTag;
}

@property (nonatomic)  int no;
@property (nonatomic, retain)  NSMutableArray* charges;
@property (nonatomic)  float isopoint;
@property (nonatomic)  float MolWt;
@property (nonatomic)  int NoOfSub1;
@property (nonatomic)  int NoOfSub2;
@property (nonatomic)  int NoOfSub3;
@property (nonatomic)  float subunit1;
@property (nonatomic)  float subunit2;
@property (nonatomic)  float subunit3;
@property (nonatomic)  float original_amount;
@property (nonatomic)  float amount;
@property (nonatomic)  float temp;
@property (nonatomic)  float pH1;
@property (nonatomic)  float pH2;
@property (nonatomic)  float sulphate;
@property (nonatomic)  int activity;
@property (nonatomic)  int original_activity;
@property (nonatomic)  float K1;
@property (nonatomic)  float K2;
@property (nonatomic)  float K3;
@property (nonatomic)  BOOL hisTag;

- (pp_Protein*) initWithData:(int) in_no
                     :(int[]) in_charges
                     :(float) in_isopoint
                     :(float) in_MolWt
                     :(int) in_NoOfSub1
                     :(int) in_NoOfSub2
                     :(int) in_NoOfSub3
                     :(float) in_subunit1
                     :(float) in_subunit2
                     :(float) in_subunit3
                     :(float) in_original_amount
                     :(float) in_amount
                     :(float) in_temp
                     :(float) in_pH1
                     :(float) in_pH2
                     :(float) in_sulphate
                     :(int)in_original_activity
                      :(int) in_activity;

@end
