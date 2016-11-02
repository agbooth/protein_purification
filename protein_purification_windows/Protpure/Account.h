#pragma once
#include "StepRecord.h"
#include <vector>
class Account
{
public:
	Account(void);
	~Account(void);
	void addCost(double);
	double getCost(void);
	void Account::setCost(double);
	void appendRecord(StepRecord);
	void addStepRecord(void);
	StepRecord getStepRecord(int);

private:
	StepRecord *record;
	std::vector<StepRecord> account;
	double costing;
	int enzyme;
	double enz;
};

