#include "StdAfx.h"

#include "Logs.h"
#include "Dialogs.h"
#include "Commands.h"
#include "Account.h"
#include "Resource.h"
#include "ProteinData.h"
#include "Separation.h"
#include "Account.h"
#include "Protpure.h"
#include "Commdlg.h"
#include "pp_help.h"
#include "htmlhelp.h"
#include "GelView.h"
#include "Shellapi.h"
//#pragma comment (lib, "htmlhelp.lib")


#include <string>

using namespace std;

extern ProteinData* proteinData;
extern Separation* separation;
extern Account* account;
extern int graphic_mode;
extern HINSTANCE hInst;
extern WCHAR *szHelpFilename;

extern BOOL showBlot;
extern BOOL twoDGel;
extern BOOL pooled;
extern BOOL hasFractions;
extern int noOfFractions;

extern BOOL IsAdmin;

#define G_SPLASH	1
#define G_RECORD	2
#define G_GEL		3
#define G_ELUTION	4

WCHAR szTutorialURL[300];

Commands::Commands(void)
{
}

Commands::Commands(HWND hWindow)
{
	hWnd = hWindow;
}


Commands::~Commands(void)
{
	if (proteinData != NULL) delete proteinData;
	if (separation != NULL) delete separation;
	if (account != NULL) delete account;
}

void Commands::dispatch(WORD menuId)
{

//	WCHAR HelpFilename[200];
//	WCHAR TopicName[250];

	switch (menuId)
	{
	case IDM_START:
		start_command();
		break;

	case IDM_ABANDON_SCHEME:
		abandon_scheme_command();
		break;

	case IDM_ABANDON_STEP:
		abandon_step_command();
		break;

	case IDM_START_FROM_STORED:
		start_stored();
		break;

	case IDM_STORE:
		store_command();
		break;

	case IDM_GO_HOME:
		go_home_command();
		break;

	case IDM_AMMONIUM_SULFATE:
		amm_sulf_command();
		break;

	case IDM_HEAT:
		heat_treatment_command();
		break;

	case IDM_GEL_FILTRATION:
		gel_filtration_command();
		break;

	case IDM_ION_EXCHANGE:
		ion_exchange_command();
		break;

	case IDM_HYDROPHOBIC:
		HIC_command();
		break;

	case IDM_AFFINITY:
		affinity_command();
		break;

	case IDM_1D_PAGE:
		oneD_PAGE_command();
		break;

	case IDM_2D_PAGE:
		twoD_PAGE_command();
		break;

	case IDM_COOMASSIE:
		coomassie_command();
		break;

	case IDM_IMMUNOBLOT:
		immunoblot_command();
		break;

	case IDM_HIDE_GEL:
		hide_command();
		break;

	case IDM_ASSAY:
		assay_command();
		break;

	case IDM_DILUTE:
		dilute_command();
		break;

	case IDM_POOL:
		pool_command();
		break;

	case IDM_ABOUT:
		HtmlHelp(NULL, szHelpFilename, HH_DISPLAY_TOPIC, (DWORD)L"About.html");
		break;

	case IDM_INDEX:
		HtmlHelp(NULL, szHelpFilename, HH_DISPLAY_TOPIC, (DWORD)L"Scenario.html");
		break;

	case IDM_TUTORIAL:
		LoadString(hInst, IDS_TUTORIAL_URL, szTutorialURL, 250);
		ShellExecute(NULL, L"open",szTutorialURL,NULL,NULL, SW_NORMAL);
		break;
	}

}

void Commands::start_command()
{
	// Get the id of the mixture file selected, or zero if Cancel was pressed.
	INT_PTR fileId = DialogBox(hInst, MAKEINTRESOURCE(IDD_GET_MIXTURE), hWnd, (DLGPROC)GetMixture);
	
	if (fileId==0) return;

	// Create the ProteinData object

	if (proteinData != NULL)
	{
		delete proteinData;
	}	
	proteinData = new ProteinData();

	switch (fileId)
	{
	case IDF_DEFAULT:
		proteinData->mixtureName = L"Default Mixture";
		break;
	case IDF_COMPLEX:
		proteinData->mixtureName = L"Complex Mixture";
		break;
	case IDF_EASY3:
		proteinData->mixtureName = L"Easy3 Mixture";
		break;
	case IDF_EXAMPLE:
		proteinData->mixtureName = L"Example Mixture";
		break;
	}

	// Get the contents into an ASCII string.
	HRSRC hRes = FindResource(hInst, MAKEINTRESOURCE(fileId), L"File");
	HGLOBAL hMem = LoadResource(hInst, hRes);
	DWORD size = SizeofResource(hInst, hRes);
	LPSTR resText = (LPSTR)LockResource(hMem);
	LPSTR text = (LPSTR)malloc(size + 1);
	memcpy(text, resText, size);
	text[size] = 0;
	FreeResource(hMem);

	proteinData->parseData(text);
	free(text);

	// ensure the menus are disabled.
	activateSeparationMenu(FALSE);
	activateElectroMenu(FALSE);
	activateFractionsMenu(FALSE);

	// Get the id of the protein selected, or zero if Cancel was pressed.
	INT_PTR enzymeId = DialogBox(hInst, MAKEINTRESOURCE(IDD_GET_ENZYME), hWnd, (DLGPROC)GetEnzyme);
	
	if (enzymeId==0) return;

	// Inform the ProteinData
	proteinData->enzyme = (int)enzymeId;

	// Show the stability data
	DialogBox(hInst, MAKEINTRESOURCE(IDD_STABILITY), hWnd, (DLGPROC)ShowStability);

	// Change the menu
	endSplash();

	// Set up the variables
	conditionStart(true);
	
	// Get rid of the splash screen and show the Progress report instead
	graphic_mode = G_RECORD;
	InvalidateRect( hWnd, NULL, TRUE);

}




void Commands::start_stored()
{
	OPENFILENAMEW ofn;
	WCHAR szFileName[MAX_PATH] = L"";
	WCHAR fileName[MAX_PATH];
	ZeroMemory( &ofn, sizeof(ofn));

	ofn.lStructSize = sizeof(ofn); 
    ofn.hwndOwner = NULL;
    ofn.lpstrFilter = L"Mixture Files (*.ppmixture)\0*.ppmixture\0All Files (*.*)\0*.*\0";
    ofn.lpstrFile = szFileName;
    ofn.nMaxFile = MAX_PATH;
	ofn.lpstrFileTitle = fileName;
	ofn.nMaxFileTitle = MAX_PATH;
    ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
    ofn.lpstrDefExt = L".ppmixture";


    if (!GetOpenFileNameW(&ofn)) return;

	graphic_mode = G_SPLASH;
	InvalidateRect( hWnd, NULL, TRUE);

	HANDLE hFile;
	if ( (hFile = CreateFile(ofn.lpstrFile, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL)) != INVALID_HANDLE_VALUE)
	{
		// Get file size in bytes and allocate memory for read.
		// Add an extra two bytes for zero termination.
		
		int iFileLength = GetFileSize(hFile, NULL);
		
		char* pBuffer1 = (char*)malloc( iFileLength + 2);
		char* pBuffer2 = (char*)malloc( iFileLength + 2);
		// take a copy of the pointers because they will be changed by strtok()
		char* marker1 = pBuffer1;
		char* marker2 = pBuffer2;

		DWORD dwBytesRead;
		//Read file and put terminating zeroes at end.
		ReadFile( hFile, pBuffer1, iFileLength, &dwBytesRead, NULL );
		CloseHandle(hFile);
		pBuffer1[iFileLength] = '\0';
		pBuffer1[iFileLength+1] = '\0';

		// Take a copy
		strcpy(pBuffer2, pBuffer1);
	
		if (proteinData != NULL)
		{
			delete proteinData;
		}	
		proteinData = new ProteinData();

		proteinData->parseData(pBuffer1);  // N.B. pBuffer1 is altered by this
		
		// ensure the menus are disabled.
		activateSeparationMenu(FALSE);
		activateElectroMenu(FALSE);
		activateFractionsMenu(FALSE);

		wcscpy(proteinData->fileName,ofn.lpstrFile);
		
		WCHAR drive[_MAX_DRIVE];
		WCHAR dir[_MAX_DIR];
		WCHAR ext[_MAX_EXT];
		_wsplitpath(proteinData->fileName,drive, dir, proteinData->fileName, ext);


		proteinData->mixtureName = proteinData->fileName;
		if (proteinData->noOfProteins==0)
		{
			DialogBox(hInst, MAKEINTRESOURCE(IDD_NO_PROTEINS), hWnd, (DLGPROC)MixtureMessage);
			free(marker1);
			free(marker2);
			startSplash();
			return;
		}
		if (proteinData->noOfProteins==-1)
		{
			DialogBox(hInst, MAKEINTRESOURCE(IDD_MIXTURE_ERROR), hWnd, (DLGPROC)MixtureMessage);
			free(marker1);
			free(marker2);
			startSplash();
			return;
		}

		if (proteinData->hasScheme)
		{
			if ( DialogBox(hInst, MAKEINTRESOURCE(IDD_PURIFICATION_HISTORY), hWnd, (DLGPROC)PurificationHistory))
			{
				proteinData->parseScheme(pBuffer2);
				hasFractions = false;
    			pooled = true;
    			overDiluted = false;
    			assayed = false;
    			frax.clear();
			}
			else
			{
				// Get the id of the protein selected, or zero if Cancel was pressed.
				INT_PTR enzymeId = DialogBox(hInst, MAKEINTRESOURCE(IDD_GET_ENZYME), hWnd, (DLGPROC)GetEnzyme);
	
				if (enzymeId==0) return;

				// Inform the ProteinData
				proteinData->enzyme = (int)enzymeId;

				// Show the stability data
				DialogBox(hInst, MAKEINTRESOURCE(IDD_STABILITY), hWnd, (DLGPROC)ShowStability);

				// Set up the variables
				conditionStart(true);	
			}
		}
		else
		{
			// Get the id of the protein selected, or zero if Cancel was pressed.
			INT_PTR enzymeId = DialogBox(hInst, MAKEINTRESOURCE(IDD_GET_ENZYME), hWnd, (DLGPROC)GetEnzyme);
	
			if (enzymeId==0) return;

			// Inform the ProteinData
			proteinData->enzyme = (int)enzymeId;

			// Show the stability data
			DialogBox(hInst, MAKEINTRESOURCE(IDD_STABILITY), hWnd, (DLGPROC)ShowStability);

			// Set up the variables
			conditionStart(true);
		}
		free(marker1);
		free(marker2);
		// Get rid of the splash screen and show the Progress report instead
		// Change the menu
		endSplash();
		graphic_mode = G_RECORD;
		InvalidateRect( hWnd, NULL, TRUE);

		
	}
}

BOOL Commands::store_command()
{
	OPENFILENAME ofn;
	WCHAR szFileName[MAX_PATH] = L"";
	
	ZeroMemory( &ofn, sizeof(ofn));

	ofn.lStructSize = sizeof(ofn); 
    ofn.hwndOwner = NULL;
    ofn.lpstrFilter = (LPCWSTR)L"Mixture Files (*.ppmixture)\0*.ppmixture\0All Files (*.*)\0*.*\0";
    ofn.lpstrFile = szFileName;
    ofn.nMaxFile = MAX_PATH;
    ofn.Flags = OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;
    ofn.lpstrDefExt = (LPCWSTR)L".ppmixture";

    GetSaveFileName(&ofn);

	if (wcscmp(szFileName,L"") != 0)
	{
		proteinData->writeFile(szFileName);
		return TRUE;
	}
	else // indicate the user cancelled
		return FALSE;
}

void Commands::abandon_scheme_command()
{
	if (account != NULL)
	{
		INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_ASKABANDON), hWnd, (DLGPROC)AskSave);

		if (result==IDCANCEL) return;
		if (result==IDYES) 
			if (!store_command()) return;

	}

	startSplash();

	if (proteinData != NULL) delete proteinData;
	if (separation != NULL) delete separation;
	if (account != NULL) delete account;

	proteinData = NULL;
	separation = NULL;
	account = NULL;

	graphic_mode = G_SPLASH;
	InvalidateRect( hWnd, NULL, TRUE);
}

void Commands::abandon_step_command()
{
	if (account != NULL)
	{
		INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_ASKABANDONSTEP), hWnd, (DLGPROC)AskSave);

		if (result==IDNO) return;
	}

	HMENU hQuit = GetSubMenu(GetMenu(hWnd),0);			// The Quit menu
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);	// The PAGE menu
	WCHAR HideGel[40];
	MENUITEMINFO menuItemInfo;

	hasFractions = FALSE;
	assayed = FALSE;
	pooled = TRUE;
	hasGradient = FALSE;

	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_ID | MIIM_STRING;

	LoadString(hInst, IDS_HIDEGEL,HideGel, 38);
	
	activateSeparationMenu(TRUE);
	activateFractionsMenu(FALSE);

	EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED);
	EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_DISABLED | MF_GRAYED);
	menuItemInfo.wID = IDM_HIDE_GEL;
	menuItemInfo.dwTypeData = HideGel;
	SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );
	EnableMenuItem( hElectroMenu, IDM_HIDE_GEL, MF_DISABLED | MF_GRAYED);

	EnableMenuItem( hQuit, IDM_ABANDON_STEP, MF_DISABLED | MF_GRAYED);
	graphic_mode = G_RECORD;
	InvalidateRect( hWnd, NULL, TRUE);
}

void Commands::go_home_command()
{
	if (account != NULL)
	{
		INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_ASKSAVE), hWnd, (DLGPROC)AskSave);

		if (result==IDCANCEL) return;
		if (result==IDYES) 
			if (!store_command()) return;
		
	}

	PostQuitMessage(0);
}

void Commands::amm_sulf_command()
{
	INT_PTR saturation = DialogBox(hInst, MAKEINTRESOURCE(IDD_AMMSULF), hWnd, (DLGPROC)GetAmmSulf);
	if (saturation==65535) return;  // doesn't work with -1

	doAmmoniumSulfate(saturation);

}

void Commands::heat_treatment_command()
{
	INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_HEAT), hWnd, (DLGPROC)GetHeat);
	if (result==65535) return;  // doesn't work with -1

	int temp = (int)LOBYTE(result);
	int time = (int)HIBYTE(result);

	doHeatTreatment((double)temp,(double)time);

}

void Commands::gel_filtration_command()
{
	INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_GELFILT), hWnd, (DLGPROC)GetGelFilt);
	if (result==FALSE) return;

	doGelFiltration();

}

void Commands::ion_exchange_command()
{
	INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_IONEXCHANGE), hWnd, (DLGPROC)GetIonExchange);
	if (result==FALSE) return;

	result = DialogBox(hInst, MAKEINTRESOURCE(IDD_GETPH), hWnd, (DLGPROC)GetpH);
	if (result==FALSE) return;

	if (gradientIsSalt)
		result = DialogBox(hInst, MAKEINTRESOURCE(IDD_POOL), hWnd, (DLGPROC)GetSaltGradient);
	else
		result = DialogBox(hInst, MAKEINTRESOURCE(IDD_POOL), hWnd, (DLGPROC)GetpHGradient);

	if (result==FALSE) return;

	doIonExchange();
	
}

void Commands::HIC_command()
{
	INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_HIC), hWnd, (DLGPROC)GetHIC);
	if (result==FALSE) return;

	result = DialogBox(hInst, MAKEINTRESOURCE(IDD_POOL), hWnd, (DLGPROC)GetHICGradient);
	if (result==FALSE) return;

	if (separation->checkPrecipitate(startGrad))
	{
		result = DialogBox(hInst, MAKEINTRESOURCE(IDD_PRECIPITATE), hWnd, (DLGPROC)YesNo);
		if (result==IDNO) return;
		separation->doPrecipitate();
	}

	doHIC();
}

void Commands::affinity_command()
{
	INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_AFFINITY), hWnd, (DLGPROC)GetAffinity);
	if (result==FALSE) return;

	if ((proteinData->enzyme % 3 > 0) && (sepMedia==Immobilized_inhibitor))
	{
		DialogBox(hInst, MAKEINTRESOURCE(IDD_SORRY), hWnd, (DLGPROC)About);
		return;
	}

	doAffinity();
}

void Commands::oneD_PAGE_command()
{
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);  // The PAGE menu
	WCHAR HideGel[40];
	WCHAR HideBlot[40];
	MENUITEMINFO menuItemInfo;

	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_ID | MIIM_STRING;
	
	LoadString(hInst, IDS_HIDEGEL,HideGel, 38);
	LoadString(hInst, IDS_HIDEBLOT,HideBlot, 38);
	
	activateSeparationMenu(FALSE);
	activateFractionsMenu(FALSE);

	int noOfFractions = 0;

	if (pooled)
		noOfFractions = 1;
	else
	{
		graphic_mode = G_ELUTION;
		InvalidateRect(hWnd, NULL, TRUE);
		noOfFractions = DialogBox(hInst, MAKEINTRESOURCE(IDD_SELECTFRACTIONS), hWnd, (DLGPROC)SelectFractions);
	}
	if (noOfFractions==0) 
	{
		activateSeparationMenu(pooled);
		activateFractionsMenu(!pooled);
		activateElectroMenu(TRUE);
		EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_ENABLED);
		EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_ENABLED);
		EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED);
		EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_DISABLED | MF_GRAYED);
		menuItemInfo.wID = IDM_HIDE_GEL;
		menuItemInfo.dwTypeData = HideGel;
		SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );
		EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_DISABLED | MF_GRAYED);
		return;
	}
	twoDGel = FALSE;
	showBlot = FALSE;

	account->addCost(3.0);

	EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_DISABLED | MF_GRAYED);
	EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED);
	EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_ENABLED);
	menuItemInfo.wID = IDM_HIDE_GEL;
	menuItemInfo.dwTypeData = HideGel;
	SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );
	EnableMenuItem( hElectroMenu, IDM_HIDE_GEL, MF_ENABLED);

	graphic_mode = G_GEL;
	InvalidateRect(hWnd,NULL, TRUE);

}


void Commands::twoD_PAGE_command()
{
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);  // The PAGE menu
	WCHAR HideGel[40];
	WCHAR HideBlot[40];
	MENUITEMINFO menuItemInfo;

	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_ID | MIIM_STRING;
	
	LoadString(hInst, IDS_HIDEGEL,HideGel, 38);
	LoadString(hInst, IDS_HIDEBLOT,HideBlot, 38);
	
	activateSeparationMenu(FALSE);
	activateFractionsMenu(FALSE);

	noOfFractions = 0;

	if (pooled)
		noOfFractions = 1;
	else
	{
		graphic_mode = G_ELUTION;
		InvalidateRect(hWnd, NULL, TRUE);
		noOfFractions = DialogBox(hInst, MAKEINTRESOURCE(IDD_SELECTFRACTION), hWnd, (DLGPROC)SelectFraction);
	}

	if (noOfFractions==0) 
	{
		activateSeparationMenu(pooled);
		activateFractionsMenu(!pooled);
		activateElectroMenu(TRUE);
		EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_ENABLED);
		EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_ENABLED);
		EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED);
		EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_DISABLED | MF_GRAYED);
		menuItemInfo.wID = IDM_HIDE_GEL;
		menuItemInfo.dwTypeData = HideGel;
		SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );
		EnableMenuItem( hElectroMenu, IDM_HIDE_GEL, MF_DISABLED | MF_GRAYED);
		return;
	}
	twoDGel = TRUE;
	showBlot = FALSE;

	account->addCost(5.0);

	EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_DISABLED | MF_GRAYED | MF_CHECKED);
	EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED | MF_CHECKED);
	EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_ENABLED);
	menuItemInfo.wID = IDM_HIDE_GEL;
	menuItemInfo.dwTypeData = HideGel;
	SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );
	EnableMenuItem( hElectroMenu, IDM_HIDE_GEL, MF_ENABLED);

	graphic_mode = G_GEL;
	InvalidateRect(hWnd,NULL, TRUE);

}

void Commands::coomassie_command()
{
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);  // The PAGE menu
	WCHAR HideGel[40];
	MENUITEMINFO menuItemInfo;

	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_ID | MIIM_STRING;

	LoadString(hInst, IDS_HIDEGEL,HideGel, 38);

	showBlot =  FALSE;

	EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED);
	EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_ENABLED);
	menuItemInfo.wID = IDM_HIDE_GEL;
	menuItemInfo.dwTypeData = HideGel;
	SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );

	InvalidateRect(hWnd,NULL, TRUE);

}

void Commands::immunoblot_command()
{
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);  // The PAGE menu
	WCHAR HideBlot[40];
	MENUITEMINFO menuItemInfo;

	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_ID | MIIM_STRING;

	LoadString(hInst, IDS_HIDEBLOT,HideBlot, 38);

	showBlot =  TRUE;

	EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_DISABLED | MF_GRAYED);
	menuItemInfo.wID = IDM_HIDE_GEL;
	menuItemInfo.dwTypeData = HideBlot;
	SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );

	InvalidateRect(hWnd,NULL, TRUE);

}

void Commands::hide_command()
{
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);  // The PAGE menu
	WCHAR HideGel[40];
	WCHAR HideBlot[40];
	MENUITEMINFO menuItemInfo;

	menuItemInfo.cbSize = sizeof(MENUITEMINFO);
	menuItemInfo.fMask = MIIM_ID | MIIM_STRING;

	LoadString(hInst, IDS_HIDEGEL,HideGel, 38);
	LoadString(hInst, IDS_HIDEBLOT,HideBlot, 38);
	
	activateSeparationMenu(pooled);
	activateFractionsMenu(!pooled);
	activateElectroMenu(TRUE);
	
	EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_COOMASSIE, MF_DISABLED | MF_GRAYED);
	EnableMenuItem( hElectroMenu, IDM_IMMUNOBLOT, MF_DISABLED | MF_GRAYED);
	menuItemInfo.wID = IDM_HIDE_GEL;
	menuItemInfo.dwTypeData = HideGel;
	SetMenuItemInfo( hElectroMenu, IDM_HIDE_GEL, FALSE, &menuItemInfo );
	EnableMenuItem( hElectroMenu, IDM_HIDE_GEL, MF_DISABLED | MF_GRAYED);

	if (hasFractions) 
		graphic_mode = G_ELUTION;
	else
		graphic_mode = G_RECORD;
	InvalidateRect(hWnd,NULL, TRUE);

}

void Commands::assay_command()
{
	HMENU hFractionsMenu = GetSubMenu(GetMenu(hWnd),3);  // The Fractions menu
	EnableMenuItem( hFractionsMenu, IDM_ASSAY, MF_DISABLED | MF_GRAYED);
	assayed = TRUE;
	account->addCost(2.0);
	InvalidateRect(hWnd,NULL, TRUE);
}

void Commands::dilute_command()
{
	scale *= 2.0;
	if (scale==16.0)
	{
		HMENU hFractionsMenu = GetSubMenu(GetMenu(hWnd),3);  // The Fractions menu
		EnableMenuItem( hFractionsMenu, IDM_DILUTE, MF_DISABLED | MF_GRAYED);
	}
	account->addCost(1.0);
	InvalidateRect(hWnd,NULL, TRUE);
}

void Commands::pool_command()
{
	INT_PTR result = DialogBox(hInst, MAKEINTRESOURCE(IDD_POOL), hWnd, (DLGPROC)GetPool);
	if (result==FALSE) return;

	doPoolFractions();
}


void Commands::activateSeparationMenu(BOOL active)
{
	HMENU hMenu = GetSubMenu(GetMenu(hWnd),1);

	for (int i=0; i<6; i++)
	{
		if (active)
			EnableMenuItem( hMenu, i, MF_ENABLED | MF_BYPOSITION);
		else
			EnableMenuItem( hMenu, i, MF_DISABLED | MF_GRAYED | MF_BYPOSITION);
	}
}

void Commands::activateElectroMenu(BOOL active)
{
	HMENU hMenu = GetSubMenu(GetMenu(hWnd),2);

	for (int i=0; i<7; i++) // separators are included
	{
		if (active)
			EnableMenuItem( hMenu, i, MF_ENABLED | MF_BYPOSITION);
		else
			EnableMenuItem( hMenu, i, MF_DISABLED | MF_GRAYED | MF_BYPOSITION);
	}
}

void Commands::activateFractionsMenu(BOOL active)
{
	HMENU hMenu = GetSubMenu(GetMenu(hWnd),3);

	for (int i=0; i<3; i++)
	{
		if (active)
			EnableMenuItem( hMenu, i, MF_ENABLED | MF_BYPOSITION);
		else
			EnableMenuItem( hMenu, i, MF_DISABLED | MF_GRAYED | MF_BYPOSITION);
	}
}

void Commands::endSplash()
{
	HMENU hMenu = GetMenu(hWnd);
	HMENU hNewMenu = LoadMenu(hInst, MAKEINTRESOURCE(IDC_RUNNING));
	SetMenu(hWnd, hNewMenu);
	DestroyMenu(hMenu);
}

void Commands::startSplash()
{
	HMENU hMenu = GetMenu(hWnd);
	HMENU hNewMenu = LoadMenu(hInst, MAKEINTRESOURCE(IDC_PROTPURE));
	SetMenu(hWnd, hNewMenu);
	DestroyMenu(hMenu);
}

void Commands::conditionStart(BOOL refill)
{
	if (separation != NULL) delete separation;
	separation = new Separation();

	if (account != NULL) delete account;
	account = new Account();

	sepType = None;
	pooled = TRUE;
    assayed = FALSE;
    hasFractions = FALSE;
    hasGradient = FALSE;
    gradientIsSalt = TRUE;
    overDiluted = FALSE;
    elutionpH = -1.0;
    startGrad = -1.0;
    endGrad = -1.0;

	proteinData->step = 0;

	if (refill)
	{
		//Make sure all proteins are present in full amount
		//as some may have been lost if we are using a stored mixture.

		for (int i=0; i<=proteinData->noOfProteins; i++)
			proteinData->setCurrentAmount(i, proteinData->getOriginalAmount(i));
	}

	frax.clear();
}

BOOL Commands::showProgress()
{
	// has there been a disaster?
    int enzyme = proteinData->enzyme;
    int step = proteinData->step;

    double enz = proteinData->getCurrentAmount(enzyme)*proteinData->getCurrentActivity(enzyme)*100.0;
        
    double cost = account->getCost()*100.0/enz;
        
    if ((enz < 0.01) || (step==11) || (cost > 1000.0))  // Oops
	{
		INT_PTR choice = DialogBox(hInst, MAKEINTRESOURCE(IDD_OOPS), hWnd, (DLGPROC)Oops);
		if (account!=NULL)
		{
			delete account;
			account = NULL;
			graphic_mode = G_SPLASH;
		}
		if (choice==IDNO) go_home_command();
		else abandon_scheme_command();
		
		return FALSE;
	}

	return TRUE;  // All's well...
}

void Commands::doPoolFractions()
{
	separation->PoolFractions( startOfPool, endOfPool );
	account->addStepRecord();
	if (showProgress())
	{
		DialogBox(hInst, MAKEINTRESOURCE(IDD_STEPRECORD), hWnd, (DLGPROC)StepRecordBox);
		graphic_mode = G_RECORD;
		InvalidateRect(hWnd, NULL, TRUE);

		hasFractions = FALSE;
		pooled = TRUE;
		overDiluted = FALSE;
		assayed = FALSE;
		scale = 0.5;
		frax.clear();
		activateFractionsMenu(FALSE);
		activateSeparationMenu(TRUE);
		HMENU hQuit = GetSubMenu(GetMenu(hWnd),0);
		EnableMenuItem( hQuit, IDM_ABANDON_STEP, MF_DISABLED | MF_GRAYED);
	}
}

void Commands::doAmmoniumSulfate(int saturation)
{
	separation->AS((double)saturation);

	INT_PTR choice = DialogBox(hInst, MAKEINTRESOURCE(IDD_ASRESULT), hWnd, (DLGPROC)ASResult);

	if (choice==0) return;

	if (choice==1)
		for (int i=0; i<=proteinData->noOfProteins;i++)
			proteinData->setCurrentAmount(i, proteinData->getInsoluble(i));

	if (choice==2)
		for (int i=0; i<=proteinData->noOfProteins;i++)
			proteinData->setCurrentAmount(i, proteinData->getSoluble(i));

	sepType = Ammonium_sulfate;
    account->addCost(2.0);
    proteinData->incrementStep();
    account->addStepRecord();
        
    if (showProgress())
	{
		DialogBox(hInst, MAKEINTRESOURCE(IDD_STEPRECORD), hWnd, (DLGPROC)StepRecordBox);
		graphic_mode = G_RECORD;
		InvalidateRect(hWnd, NULL, TRUE);
	}

}

void Commands::doHeatTreatment(double temperature, double time)
{
	separation->HeatTreatment( temperature, time );

	sepType = Heat_treatment;
    account->addCost(1.0);
    proteinData->incrementStep();
    account->addStepRecord();
        
    if (showProgress())
	{
		DialogBox(hInst, MAKEINTRESOURCE(IDD_STEPRECORD), hWnd, (DLGPROC)StepRecordBox);
		graphic_mode = G_RECORD;
		InvalidateRect(hWnd, NULL, TRUE);
	}

}

void Commands::doGelFiltration()
{
	LoadString(hInst, IDS_GEL_FILTRATION, separation->sepString, 250);

	separation->GelFiltrationElution(excluded, included, hires);
	separation->SetPlotArray();

	hasGradient = FALSE;
	account->addCost(5.0);

	setToRunning();
}

void Commands::doIonExchange()
{
	LoadString( hInst, IDS_ION_EXCHANGE_CHROMATOGRAPHY, separation->sepString, 250);

	switch (sepMedia)
	{
	case DEAE_cellulose:
		if (gradientIsSalt) separation->DEAE_salt_elution(startGrad, endGrad, pH, TRUE);
		else separation->DEAE_pH_elution(startGrad, endGrad, pH, TRUE);
		break;

	case CM_cellulose:
		if (gradientIsSalt) separation->CM_salt_elution(startGrad, endGrad, pH, TRUE);
		else separation->CM_pH_elution(startGrad, endGrad, pH, TRUE);
		break;

	case Q_Sepharose:
		if (gradientIsSalt) separation->DEAE_salt_elution(startGrad, endGrad, pH, FALSE);
		else separation->DEAE_pH_elution(startGrad, endGrad, pH, FALSE);
		break;

	case S_Sepharose:
		if (gradientIsSalt) separation->CM_salt_elution(startGrad, endGrad, pH, FALSE);
		else separation->CM_pH_elution(startGrad, endGrad, pH, FALSE);
		break;
	}

	separation->SetPlotArray();

	hasGradient = TRUE;
	account->addCost(5.0);

	setToRunning();
}

void Commands::doHIC()
{
	LoadString( hInst, IDS_HYDROPHOBIC_INTERACTION_CHROMATOGRAPHY, separation->sepString, 250);

	separation->HIC_elution(startGrad, endGrad, sepMedia, startGrad);
	separation->SetPlotArray();

	hasGradient = TRUE;
	account->addCost(5.0);

	setToRunning();
}

void Commands::doAffinity()
{
	LoadString( hInst, IDS_AFFINITY_CHROMATOGRAPHY, separation->sepString, 250);
	separation->Affinity_elution(sepMedia, affinityElution);
	separation->SetPlotArray();

	hasGradient = FALSE;
	account->addCost(25.0);

	setToRunning();
	
}

void Commands::setToRunning()
{
	scale = 0.5;
	assayed = FALSE;
	pooled = FALSE;
	hasFractions = TRUE;
	
	activateSeparationMenu(FALSE);
	activateFractionsMenu(TRUE);

	HMENU hQuitMenu =  GetSubMenu(GetMenu(hWnd),0);  // The Quit menu
	HMENU hElectroMenu = GetSubMenu(GetMenu(hWnd),2);  // The PAGE menu

	EnableMenuItem( hQuitMenu, IDM_ABANDON_STEP, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_1D_PAGE, MF_ENABLED);
	EnableMenuItem( hElectroMenu, IDM_2D_PAGE, MF_ENABLED);

	graphic_mode = G_ELUTION;
	InvalidateRect(hWnd,NULL, TRUE);
}