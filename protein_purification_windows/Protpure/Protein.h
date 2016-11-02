#pragma once

class Protein
{
public:
	Protein(void);
	Protein(int in_no,
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
            int in_activity);

	~Protein(void);
	BOOL getHisTag();

	int no;
	int charges[7];
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
};

