#pragma once

#include "resource.h"
#include <vector>

class Commands
{
public:
	Commands(void);
	Commands(HWND);
	~Commands(void);
	void dispatch(WORD menuId);
	void conditionStart(BOOL refill);

	int sepType;
    int sepMedia;
    BOOL  pooled;
    BOOL  assayed;
    BOOL  hasFractions;
    BOOL  hasGradient;
    double elutionpH;
	BOOL titratable;
    BOOL  gradientIsSalt;
	double pH;
    double startGrad;
    double endGrad;
    BOOL  overDiluted;
    double scale;
    int  affinityElution;
    int  startOfPool;
    int  endOfPool;
	int noOfFractions;
	std::vector<int> frax;
	double excluded;
	double included;
	BOOL hires;

private:
	void start_command();
	void abandon_scheme_command();
	void abandon_step_command();
	void start_stored();
	BOOL store_command();
	void go_home_command();
	void amm_sulf_command();
	void heat_treatment_command();
	void gel_filtration_command();
	void ion_exchange_command();
	void HIC_command();
	void oneD_PAGE_command();
	void twoD_PAGE_command();
	void coomassie_command();
	void immunoblot_command();
	void hide_command();
	void assay_command();
	void dilute_command();
	void pool_command();
	void affinity_command();

	void setToRunning();

	void activateSeparationMenu(BOOL active);
	void activateElectroMenu(BOOL active);
	void activateFractionsMenu(BOOL active);
	void endSplash();
	void startSplash();

	BOOL showProgress();
	void stepReport();

	void doAmmoniumSulfate(int);
	void doHeatTreatment(double, double);
	void doGelFiltration();
	void doIonExchange();
	void doHIC();
	void doAffinity();

	void doPoolFractions();
 
	HWND hWnd;	
	
};



