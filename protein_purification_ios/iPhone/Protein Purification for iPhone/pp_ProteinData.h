//
//  pp_ProteinData.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 20/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import "pp_Protein.h"
#import "pp_Account.h"

@class pp_Account;

@interface pp_ProteinData : NSObject

@property (nonatomic, retain) NSMutableArray* Proteins;
@property (nonatomic, retain) NSMutableArray* Soluble;
@property (nonatomic, retain) NSMutableArray* Insoluble;

@property (nonatomic) bool hasScheme;

@property (nonatomic) int step;
@property (nonatomic) int enzyme;
@property (nonatomic) int noOfProteins;
@property (nonatomic, retain) NSString* mixtureName;


- (pp_ProteinData*) init;

- (void) setDefaultValues;

- (void) parseData: (NSString*) fileString;

- (void) parseScheme: (NSString*) fileString;

float negCharge(float pH, float pK);
float posCharge(float pH, float pK);

- (float) chargeAt:(float) pH protein:(int) protein_no;

- (float) IsoelectricPoint: (int) protein_no;

- (NSMutableArray*) GetChargesOfProtein: (int) proteinNo;

- (float) GetMolWtOfProtein: (int) proteinNo;

- (int) GetNoOfSub1OfProtein: (int) proteinNo;
- (int) GetNoOfSub2OfProtein: (int) proteinNo;
- (int) GetNoOfSub3OfProtein: (int) proteinNo;

- (float) GetSubunit1OfProtein: (int) proteinNo;
- (float) GetSubunit2OfProtein: (int) proteinNo;
- (float) GetSubunit3OfProtein: (int) proteinNo;

- (float) GetIsoPointOfProtein: (int) proteinNo;
- (float) GetTempOfProtein: (int) proteinNo;

- (float) GetK1OfProtein: (int) proteinNo;
- (float) GetK2OfProtein: (int) proteinNo;
- (float) GetK3OfProtein: (int) proteinNo;

- (void) SetK1OfProtein: (int) proteinNo value: (float) K1;
- (void) SetK2OfProtein: (int) proteinNo value: (float) K2;
- (void) SetK3OfProtein: (int) proteinNo value: (float) K3;

- (float) GetpH1OfProtein: (int) proteinNo;
- (float) GetpH2OfProtein: (int) proteinNo;

- (float) GetSulphateOfProtein: (int) proteinNo;

- (void) ResetSoluble;
- (void) AppendSoluble: (float) amount;
- (void) SetSolubleOfProtein: (int) proteinNo  value: (float) soluble;
- (float) GetSolubleOfProtein: (int) proteinNo;

- (void) ResetInsoluble;
- (void) AppendInsoluble: (float) amount;
- (void) SetInsolubleOfProtein: (int) proteinNo  value: (float) soluble;
- (float) GetInsolubleOfProtein: (int) proteinNo;

- (float) GetCurrentAmountOfProtein: (int) proteinNo;
- (void) SetCurrentAmountOfProtein: (int) proteinNo  value: (float) amount;

- (float) GetOriginalAmountOfProtein: (int) proteinNo;
- (void) SetOriginalAmountOfProtein: (int) proteinNo  value: (float) amount;

- (int) GetOriginalActivityOfProtein: (int) proteinNo;
- (void) SetOriginalActivityOfProtein: (int) proteinNo  value: (int) activity;

- (int) GetCurrentActivityOfProtein: (int) proteinNo;
- (void) SetCurrentActivityOfProtein: (int) proteinNo  value: (int) activity;

- (float) GetTotalAmount;

- (BOOL) GetHisTagOfProtein: (int) proteinNo;

- (void) IncrementStep;

- (NSString*) writeMixture: (pp_Account*) account;

@end
