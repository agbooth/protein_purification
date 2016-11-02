// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>

// C RunTime Header Files
#include <stdlib.h>
#include <malloc.h>
#include <memory.h>
#include <tchar.h>


// TODO: reference additional headers your program requires here
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
    Ultrogel_54,
    Ultrogel_44,
    Ultrogel_34,
    BioGel_P60,
    BioGel_P150,
    BioGel_P300,
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
