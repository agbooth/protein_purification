#include "StdAfx.h"
#include "Protein.h"


Protein::Protein(void)
{
}

Protein::Protein(int in_no,
            int in_charges[7],
            float in_isopoint,
            float in_MolWt,
            int in_NoOfSub1,
            int in_NoOfSub2,
            int in_NoOfSub3,
            float in_subunit1,
            float in_subunit2,
            float in_subunit3,
            float in_original_amount,
            float in_amount,
            float in_temp,
            float in_pH1,
            float in_pH2,
            float in_sulphate,
            int in_original_activity,
            int in_activity)
{
		no = in_no;

		for (int i=0; i<7; i++)
			charges[i] = in_charges[i];

		if (in_charges[2] < -5) 
		{
				hisTag = TRUE;
				in_charges[2] = -in_charges[2];
		}
		else hisTag = FALSE;

		isopoint = in_isopoint;
		MolWt = in_MolWt;
		NoOfSub1 = in_NoOfSub1;
		NoOfSub2 = in_NoOfSub2;
		NoOfSub3 = in_NoOfSub3;
		subunit1 = in_subunit1;
		subunit2 = in_subunit2;
		subunit3 = in_subunit3;
		original_amount = in_original_amount;
		amount = in_amount;
		temp = in_temp;
		pH1 = in_pH1;
		pH2 = in_pH2;
		sulphate = in_sulphate;
		activity = in_activity;
		original_activity = in_original_activity;
		K1 = 0.0;
		K2 = 0.0;
		K3 = 0.0;

}

Protein::~Protein(void)
{
}

BOOL Protein::getHisTag()
{
	return hisTag;
}
