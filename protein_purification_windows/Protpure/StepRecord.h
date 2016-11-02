#pragma once

struct step_record
{
	int stepType;
	double proteinAmount;
	double enzymeUnits;
	double enzymeYield;
	double enrichment;
	double costing;
};

class StepRecord
{
public:
	StepRecord(void);
	~StepRecord(void);
	void setStepType(int);
	int getStepType();
	void setProteinAmount(double);
	double getProteinAmount();
	void setEnzymeUnits(double);
	double getEnzymeUnits();
	void setEnzymeYield(double);
	double getEnzymeYield();
	void setEnrichment(double);
	double getEnrichment();
	void setCosting(double);
	double getCosting();
	void incrementCosting(double);
    
private:
	struct step_record record;
};

