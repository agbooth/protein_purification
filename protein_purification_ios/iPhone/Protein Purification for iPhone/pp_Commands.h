//
//  pp_Commands.h
//  Protein Purification for iPad
//
//  Created by Andrew Booth on 22/07/2012.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "pp_AppDelegate.h"
#import "pp_ElutionViewController.h"
#import "pp_RunningMenuViewController.h"
#import "pp_RecordViewController.h"
#import "pp_HelpViewController.h"

enum
{
    None,
    Ammonium_sulfate,
    Heat_treatment,
    Gel_filtration,
    Ion_exchange,
    Hydrophobic_interaction,
    Affinity,
    Sephadex_G50,
    Sephadex_G100,
    Sephacryl_S200,
    BioGel_P60,
    BioGel_P150,
    BioGel_P300,
    Ultrogel_54,
    Ultrogel_44,
    Ultrogel_34,
    DEAE_cellulose,
    CM_cellulose,
    Q_Sepharose,
    S_Sepharose,
    Phenyl_Sepharose,
    Octyl_Sepharose,
    AntibodyA,
    AntibodyB,
    AntibodyC,
    Polyclonal,
    Immobilized_inhibitor,
    NiNTAagarose,
    Tris,
    Acid,
    Inhibitor,
    Imidazole
};


@interface pp_Commands : NSObject <UIAlertViewDelegate>


@property (nonatomic) int sepType;
@property (nonatomic) int sepMedia;
@property (nonatomic) bool  pooled;
@property (nonatomic) bool  assayed;
@property (nonatomic) bool  hasFractions;
@property (nonatomic) bool  hasGradient;
@property (nonatomic) float elutionpH;
@property (nonatomic) bool  gradientIsSalt;
@property (nonatomic) float startGrad;
@property (nonatomic) float endGrad;
@property (nonatomic) bool  overDiluted;
@property (nonatomic) float scale;
@property (nonatomic) int affinityElution;
@property (nonatomic) int startOfPool;
@property (nonatomic) int endOfPool;
@property (nonatomic) bool comingFromHelp;
@property (nonatomic) bool oneDshowing;
@property (nonatomic) bool twoDshowing;
@property (nonatomic, retain) NSMutableArray* frax;

- (pp_Commands*) init;
- (void) incrementLaunchCount;
- (NSInteger) getLaunchCount;
- (void) enableUpgrade;
- (void) loadMixtureData: (NSString*) sender;
- (void) loadStoredMixtureData: (NSString*) sender;
- (void) conditionStart;
- (void) showProgress;
- (void) showMasterView;
- (void) hideMasterView;
- (void) resetRunningMenu;
- (void) setToRunningMenu;
- (void) doEnzymeAssay;
- (void) doDiluteFractions;
- (void) doPoolFractions;
- (void) showHelpPage: (NSString*) helpFile;
- (void) drawElution;
- (void) doHeatTreatment:(float)temperature time:(float) time;
- (void) doAmmoniumSulfate: (float) percent;
- (NSString*) checkASPrecipitate;
- (void) finishAmmoniumSulfate: (int) choice;
- (void) doGelFiltration;
- (void) doIonExchange;
- (void) doHydrophobicInteraction;
- (void) doAffinityElution;
@end
