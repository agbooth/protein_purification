#pragma once

#include "stdafx.h"
#include "Logs.h"
#include "Commctrl.h"
#include "Resource.h"
#include "ProteinData.h"
#include "Commands.h"
#include "Separation.h"
#include "Account.h"
#include "Dialogs.h"
#include "pp_help.h"
#include "htmlhelp.h"
#include <algorithm>
#pragma comment (lib, "htmlhelp.lib")

extern HBRUSH hDlgBkgBrush;
extern ProteinData* proteinData;
extern Account* account;
extern Commands* commands;
extern Separation* separation;
extern HINSTANCE hInst;
extern WCHAR* szHelpFilename;


// Message handler for generic box.
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam )
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Get Mixture box.
INT_PTR CALLBACK GetMixture(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hListBox = GetDlgItem(hDlg, IDC_LISTBOX);
	static int iIndex;
	static int selection[4] = {IDF_DEFAULT,IDF_EASY3,IDF_EXAMPLE,IDF_COMPLEX};

	switch (message)
	{
	case WM_INITDIALOG:		
		SendMessage( hListBox, LB_ADDSTRING,0, (LPARAM)L"Default Mixture");
		SendMessage( hListBox, LB_ADDSTRING,0, (LPARAM)L"Easy3 Mixture");
		SendMessage( hListBox, LB_ADDSTRING,0, (LPARAM)L"Example Mixture");
		SendMessage( hListBox, LB_ADDSTRING,0, (LPARAM)L"Complex Mixture");
		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE );
		SetFocus(hListBox);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)selection[iIndex]);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, FALSE);
			return ((INT_PTR)TRUE);

		case IDC_LISTBOX:
			if (HIWORD(wParam)==LBN_SELCHANGE)
			{
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
				iIndex = (int)SendMessage( hListBox, LB_GETCURSEL, 0, 0);
			}
			return ((INT_PTR)TRUE);
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Get Enzyme box.
INT_PTR CALLBACK GetEnzyme(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	char szWording[200];
	char szItems[20];
	HWND hListbox = GetDlgItem(hDlg, IDC_LISTBOX);
	static int iIndex;

	switch (message)
	{
	case WM_INITDIALOG:
		// Set the title
		SetWindowText(hDlg, (LPCWSTR)proteinData->mixtureName);
		// Insert the number of proteins in this mixture
		GetDlgItemText(hDlg, IDC_MESSAGE, (LPWSTR)szWording, 199);
		swprintf((LPWSTR)szWording,199,(LPWSTR)szWording,proteinData->noOfProteins);
		SetDlgItemText(hDlg, IDC_MESSAGE,(LPWSTR)szWording);

		// Populate the listbox
		for (int i=1; i<=proteinData->noOfProteins; i++)
		{
			swprintf((LPWSTR)szItems,10,(LPWSTR)L"%d ",i);
			SendMessage( hListbox, LB_ADDSTRING,0, (LPARAM)szItems);
		}

		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE );
		SetFocus(hListbox);

		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)iIndex+1);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, FALSE);
			return ((INT_PTR)TRUE);

		case IDC_LISTBOX:
			if (HIWORD(wParam)==LBN_SELCHANGE)
			{
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
				iIndex = (int)SendMessage( hListbox, LB_GETCURSEL, 0, 0);
			}
			return ((INT_PTR)TRUE);
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Stability box.
INT_PTR CALLBACK ShowStability(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	WCHAR szWording[1000];
	WCHAR szTitle[200];
	HWND hListbox = GetDlgItem(hDlg, IDC_LISTBOX);
	static int iIndex;
	int enzyme;
	Protein protein;

	switch (message)
	{
	case WM_INITDIALOG:
		// Set the title
		LoadString(hInst, IDS_PROTEIN_D, szTitle, 190);
		swprintf(szTitle,100,szTitle,proteinData->enzyme);
		SetWindowText(hDlg,szTitle);
		// Insert the data about the protein
		GetDlgItemText(hDlg, IDC_MESSAGE, szWording, 999);
		enzyme = proteinData->enzyme;
		protein = proteinData->Proteins.at(enzyme);
		swprintf(szWording,500,szWording,
									enzyme,
									protein.temp,
									protein.pH1,
									protein.pH2);

		SetDlgItemText(hDlg, IDC_MESSAGE,(LPWSTR)szWording);

		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Get Purification History box.
INT_PTR CALLBACK PurificationHistory(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		SetWindowText(hDlg, (LPCWSTR)proteinData->mixtureName);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;
		case IDCANCEL:
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Mixture Message boxes.
INT_PTR CALLBACK MixtureMessage(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		SetWindowText(hDlg, (LPCWSTR)proteinData->mixtureName);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the Ask Save box.
INT_PTR CALLBACK AskSave(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		SetWindowText(hDlg, (LPCWSTR)proteinData->mixtureName);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDYES:
			EndDialog(hDlg, (WORD)IDYES);
			return (INT_PTR)TRUE;

		case IDNO:
			EndDialog(hDlg, (WORD)IDNO);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)IDCANCEL);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

void redrawControlInDialog(HWND hCtrl, HWND hDlg)
{
	RECT rect;	
	GetClientRect(hCtrl, &rect);
	InvalidateRect(hCtrl, &rect, TRUE);
	MapWindowPoints(hCtrl, hDlg, (POINT *) &rect, 2);
	RedrawWindow(hDlg, &rect, NULL, RDW_ERASE | RDW_INVALIDATE);
}


// Message handler for the Ammonium sulfate fractionation box.
INT_PTR CALLBACK GetAmmSulf(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hSpinner = GetDlgItem(hDlg, IDC_SPIN1);
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value;
	WCHAR valueText[10];


	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner, UDM_SETBUDDY, (WPARAM) hValue, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETRANGE, (WPARAM)0, (LPARAM)100);
		SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)50);

		SetWindowText(hValue, L"50");
		value = 50;

	
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;

		if (nCode==UDN_DELTAPOS)
		{
			lpUD = (LPNMUPDOWN)lParam;
			value += lpUD->iDelta;
			if (value < 0) 
			{
				value=0;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)value);
			}
			if (value > 100) 
			{
				value = 100;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)value);
			}
			swprintf(valueText,4,L"%d",value);
			SetWindowText(hValue, valueText);
			redrawControlInDialog(hValue, hDlg); 
		}

		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)value);
			return (INT_PTR)TRUE;

		case IDINFO:
			HtmlHelp(GetParent(hDlg), szHelpFilename ,HH_HELP_CONTEXT,IDH_AMMONIUM);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)-1);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}


// Message handler for the Heat treatment box.
INT_PTR CALLBACK GetHeat(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue1 = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hValue2 = GetDlgItem(hDlg, IDC_VALUE2);
	HWND hSpinner1 = GetDlgItem(hDlg, IDC_SPIN1);
	HWND hSpinner2 = GetDlgItem(hDlg, IDC_SPIN2);
	HWND sender = NULL;
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value1;
	static int value2;
	WCHAR value1Text[10];
	WCHAR value2Text[10];

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue1, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
			SendMessage(hValue2, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner1, UDM_SETBUDDY, (WPARAM) hValue1, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETRANGE, (WPARAM)0, (LPARAM)100);
		SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)30);

		SendMessage(hSpinner2, UDM_SETBUDDY, (WPARAM) hValue2, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETRANGE, (WPARAM)0, (LPARAM)120);
		SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)10);

		SetWindowText(hValue1, L"30");
		value1 = 30;

		SetWindowText(hValue2, L"10");
		value2 = 10;

	
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;
		sender = ((LPNMHDR)lParam)->hwndFrom;

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner1))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value1 += lpUD->iDelta;
			if (value1 < 0)
			{
				value1 = 0;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			if (value1 > 100)
			{
				value1 = 100;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			swprintf(value1Text,4,L"%d",value1);
			SetWindowText(hValue1, value1Text);
			redrawControlInDialog(hValue1, hDlg); 
		}

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner2))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value2 += lpUD->iDelta;
			if (value2 < 0)
			{
				value2  =0;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			if (value2 > 120)
			{
				value2 = 120;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			swprintf(value2Text,4,L"%d",value2);
			SetWindowText(hValue2, value2Text);
			redrawControlInDialog(hValue2, hDlg); 
		}
		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, MAKEWORD(value1,value2));
			return (INT_PTR)TRUE;

		case IDINFO:
			HtmlHelp(GetParent(hDlg), szHelpFilename ,HH_HELP_CONTEXT,IDH_HEAT);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)-1);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}



// Message handler for AS choice box.
INT_PTR CALLBACK ASResult(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	WCHAR szWording[1000];
	double enz_prec = 0.0;
	double prot_prec = 0.0;

	switch (message)
	{
	case WM_INITDIALOG:

		// Insert the data about the protein
		GetDlgItemText(hDlg, IDC_ASMESSAGE, (LPWSTR)szWording, 999);
		enz_prec = proteinData->getInsoluble(proteinData->enzyme)/proteinData->getCurrentAmount(proteinData->enzyme)*100.0;
        prot_prec = proteinData->getInsoluble(0)/proteinData->getCurrentAmount(0)*100.0;
		swprintf(szWording,999,szWording,
									enz_prec,
									prot_prec);

		SetDlgItemText(hDlg, IDC_ASMESSAGE,(LPWSTR)szWording);

		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE );

		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDC_RADIO1:
		case IDC_RADIO2:
			if (HIWORD(wParam)==BN_CLICKED)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDOK:
			if (IsDlgButtonChecked(hDlg, IDC_RADIO1))
				EndDialog(hDlg, (WORD)1);
			else
				EndDialog(hDlg, (WORD) 2);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)0);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the Disaster box.
INT_PTR CALLBACK Oops(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);

	// has there been a disaster?
    int enzyme = proteinData->enzyme;
    int step = proteinData->step;
	double enz = proteinData->getCurrentAmount(enzyme)*proteinData->getCurrentActivity(enzyme)*100.0;
    double cost = account->getCost()*100.0/enz;
	WCHAR szTitle[200];

	switch (message)
	{
	case WM_INITDIALOG:
		if (enz<0.01)
			LoadString(hInst, IDS_LOST_ENZYME, szTitle, 50);
		else if (step==11)
			LoadString(hInst, IDS_NOT_FINISHED, szTitle, 50);
		else if (cost > 1000.0)
			LoadString(hInst, IDS_TOO_COSTLY, szTitle, 50);

		SetWindowText(hDlg, szTitle);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDYES:
			EndDialog(hDlg, (WORD)IDYES);
			return (INT_PTR)TRUE;

		case IDNO:
			EndDialog(hDlg, (WORD)IDNO);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Step Record box.
INT_PTR CALLBACK StepRecordBox(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam )
{
	UNREFERENCED_PARAMETER(lParam);
	WCHAR szTitle[200];
	WCHAR szValues[200];

	StepRecord record;

	HWND hText = GetDlgItem(hDlg, IDC_STEPRECORD);

	switch (message)
	{
	case WM_INITDIALOG:
		LoadString(hInst, IDS_STEPRECORDTITLE, szTitle, 50);
		swprintf(szTitle,50,szTitle, proteinData->step);
		SetWindowText(hDlg, szTitle);

		record = account->getStepRecord(proteinData->step);
		LoadString(hInst, IDS_STEPRECORD, szValues, 150);
		swprintf(szValues,150,szValues,record.getProteinAmount(),
									   record.getEnzymeUnits(),
									   record.getEnrichment(),
									   record.getEnzymeYield(),
									   record.getCosting());
		
		SetWindowText(hText, szValues);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Gel Filtration choice box.
INT_PTR CALLBACK GetGelFilt(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);

	switch (message)
	{
	case WM_INITDIALOG:
		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE ); 
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		
		switch (LOWORD(wParam))
		{
		case IDC_G50:
			CheckRadioButton(hDlg, IDC_G50, IDC_P300, IDC_G50);
			commands->sepMedia = Sephadex_G50;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 1500;
			commands->excluded = 30000;
			LoadString(hInst, IDS_SEPHADEX_G_50, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_G100:
			commands->sepMedia = Sephadex_G100;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 4000;
			commands->excluded = 150000;
			LoadString(hInst, IDS_SEPHADEX_G_100, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_S200:
			commands->sepMedia = Sephacryl_S200;
			commands->sepType = Gel_filtration;
			commands->hires = TRUE;
			commands->included = 5500;
			commands->excluded = 220000;
			LoadString(hInst, IDS_SEPHACRYL_S_200_HR, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_ACA54:
			commands->sepMedia = Ultrogel_54;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 6000;
			commands->excluded = 70000;
			LoadString(hInst, IDS_ULTROGEL_ACA_54, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_ACA44:
			commands->sepMedia = Ultrogel_44;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 12000;
			commands->excluded = 130000;
			LoadString(hInst, IDS_ULTROGEL_ACA_44, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_ACA34:
			commands->sepMedia = Ultrogel_34;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 20000;
			commands->excluded = 400000;
			LoadString(hInst, IDS_ULTROGEL_ACA_34, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_P60:
			commands->sepMedia = BioGel_P60;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 3000;
			commands->excluded = 60000;
			LoadString(hInst, IDS_BIO_GEL_P_60, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_P150:
			commands->sepMedia = BioGel_P150;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 15000;
			commands->excluded = 150000;
			LoadString(hInst, IDS_BIO_GEL_P_150, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_P300:
			commands->sepMedia = BioGel_P300;
			commands->sepType = Gel_filtration;
			commands->hires = FALSE;
			commands->included = 60000;
			commands->excluded = 400000;
			LoadString(hInst, IDS_BIO_GEL_P_300, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDINFO:
			HtmlHelp(GetParent(hDlg), szHelpFilename ,HH_HELP_CONTEXT,IDH_GELFILT);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the Pool fractions box.
INT_PTR CALLBACK GetPool(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue1 = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hValue2 = GetDlgItem(hDlg, IDC_VALUE2);
	HWND hSpinner1 = GetDlgItem(hDlg, IDC_SPIN1);
	HWND hSpinner2 = GetDlgItem(hDlg, IDC_SPIN2);
	HWND sender = NULL;
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value1;
	static int value2;
	WCHAR value1Text[10];
	WCHAR value2Text[10];
	WCHAR HelpFilename[200];

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue1, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
			SendMessage(hValue2, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner1, UDM_SETBUDDY, (WPARAM) hValue1, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETRANGE, (WPARAM)1, (LPARAM)125);
		SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)1);

		SendMessage(hSpinner2, UDM_SETBUDDY, (WPARAM) hValue2, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETRANGE, (WPARAM)1, (LPARAM)125);
		SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)125);

		SetWindowText(hValue1, L"1");
		value1 = 1;

		SetWindowText(hValue2, L"125");
		value2 = 125;

		commands->startOfPool = 1;
		commands->endOfPool = 125;
		commands->pooled = TRUE;
		InvalidateRect(GetParent(hDlg), NULL, TRUE);

	
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;
		sender = ((LPNMHDR)lParam)->hwndFrom;

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner1))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value1 += lpUD->iDelta;
			if (value1 < 1)
			{
				value1 = 1;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			if (value1 > 125)
			{
				value1 = 125;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			swprintf(value1Text,4,L"%d",value1);
			SetWindowText(hValue1, value1Text);
			redrawControlInDialog(hValue1, hDlg);
			commands->startOfPool = value1;

			if (value2 < value1)
			{
				value2 = value1;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
				swprintf(value2Text,4,L"%d",value2);
				SetWindowText(hValue2, value2Text);
				redrawControlInDialog(hValue2, hDlg);
				commands->endOfPool = value2;
			}

			InvalidateRect(GetParent(hDlg), NULL, TRUE);
		}

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner2))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value2 += lpUD->iDelta;
			if (value2 < 1)
			{
				value2 = 1;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			if (value2 > 125)
			{
				value2 = 125;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			swprintf(value2Text,4,L"%d",value2);
			SetWindowText(hValue2, value2Text);
			redrawControlInDialog(hValue2, hDlg);
			commands->endOfPool = value2;

			if (value1 > value2)
			{
				value1 = value2;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
				swprintf(value1Text,4,L"%d",value1);
				SetWindowText(hValue1, value1Text);
				redrawControlInDialog(hValue1, hDlg);
				commands->startOfPool = value1;
			}

			InvalidateRect(GetParent(hDlg), NULL, TRUE);
		}
		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			commands->pooled = FALSE;
			commands->startOfPool = 1;
			commands->endOfPool = 125;
			InvalidateRect(GetParent(hDlg), NULL, TRUE);
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the single selection box.
INT_PTR CALLBACK SelectFraction(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hSpinner = GetDlgItem(hDlg, IDC_SPIN1);
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value;
	WCHAR valueText[10];

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner, UDM_SETBUDDY, (WPARAM) hValue, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETRANGE, (WPARAM)1, (LPARAM)125);
		SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)60);

		SetWindowText(hValue, L"60");
		value = 60;

		commands->pooled = TRUE;
		commands->startOfPool = 60;
		commands->endOfPool = 60;

		InvalidateRect(GetParent(hDlg), NULL, TRUE);
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;

		if (nCode==UDN_DELTAPOS)
		{
			lpUD = (LPNMUPDOWN)lParam;
			value += lpUD->iDelta;
			if (value < 1) 
			{
				value=1;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)value);
			}
			if (value > 125) 
			{
				value = 125;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)value);
			}
			swprintf(valueText,4,L"%d",value);
			SetWindowText(hValue, valueText);
			redrawControlInDialog(hValue, hDlg); 
			commands->startOfPool = value;
			commands->endOfPool = value;

			InvalidateRect(GetParent(hDlg), NULL, TRUE);
		}

		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			commands->pooled = FALSE;
			commands->frax.clear();
			commands->frax.push_back(value);
			EndDialog(hDlg, (WORD)1);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			commands->pooled = FALSE;
			InvalidateRect(GetParent(hDlg), NULL, TRUE);
			EndDialog(hDlg, (WORD)0);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}
// Message handler for the multiple selection box.
INT_PTR CALLBACK SelectFractions(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hSpinner = GetDlgItem(hDlg, IDC_SPIN1);
	HWND hPrompt = GetDlgItem(hDlg, IDC_TEXT);
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value;
	static int noSelected;
	WCHAR valueText[10];
	WCHAR buffer[200];

	switch (message)
	{
	case WM_INITDIALOG:

		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE );
		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner, UDM_SETBUDDY, (WPARAM) hValue, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETRANGE, (WPARAM)1, (LPARAM)125);
		SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)60);

		SetWindowText(hValue, L"60");
		value = 60;

		SetWindowText(hPrompt, L"");

		commands->pooled = TRUE;
		commands->startOfPool = 60;
		commands->endOfPool = 60;
		commands->frax.clear();

		InvalidateRect(GetParent(hDlg), NULL, TRUE);
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;

		if (nCode==UDN_DELTAPOS)
		{
			lpUD = (LPNMUPDOWN)lParam;
			value += lpUD->iDelta;
			if (value < 1)
			{
				value=1;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)value);
			}
			if (value > 125)
			{
				value = 125;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)0, (LPARAM)value);
			}
			swprintf(valueText,4,L"%d",value);
			SetWindowText(hValue, valueText);
			redrawControlInDialog(hValue, hDlg); 
			commands->startOfPool = value;
			commands->endOfPool = value;

			if ((std::find(commands->frax.begin(), commands->frax.end(), value) != commands->frax.end()) ||
				(commands->frax.size()==15))
				EnableWindow( GetDlgItem( hDlg, IDADD ), FALSE );
			else
				EnableWindow( GetDlgItem( hDlg, IDADD ), TRUE );

			InvalidateRect(GetParent(hDlg), NULL, TRUE);
		}

		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			commands->pooled = FALSE;
			std::sort(commands->frax.begin(), commands->frax.end());

			EndDialog(hDlg, (WORD)commands->frax.size());
			return (INT_PTR)TRUE;

		case IDADD:
			commands->frax.push_back(value);
			if (commands->frax.size()==1)
			{
				LoadString(hInst, IDS_ADDED_ONE_FRACTION, buffer, 190);
			}
			else
			{
				LoadString(hInst, IDS_ADDED_FRACTIONS, buffer, 190);
				swprintf(buffer, 190, buffer, commands->frax.size());
			}
			SetWindowText(hPrompt, buffer);
			redrawControlInDialog(hPrompt, hDlg); 
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			EnableWindow( GetDlgItem( hDlg, IDADD ), FALSE );

			break;

		case IDCANCEL:
			commands->pooled = FALSE;
			InvalidateRect(GetParent(hDlg), NULL, TRUE);
			EndDialog(hDlg, (WORD)0);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Ion exchange choice box.
INT_PTR CALLBACK GetIonExchange(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	static BOOL mediumSelected;
	static BOOL elutionSelected;

	switch (message)
	{
	case WM_INITDIALOG:  

		mediumSelected = FALSE;
		elutionSelected = FALSE;
		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE );

		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		
		switch (LOWORD(wParam))
		{
		case IDC_DEAE:
			CheckRadioButton(hDlg, IDC_DEAE, IDC_SS, IDC_DEAE);
			commands->sepMedia = DEAE_cellulose;
			commands->sepType = Ion_exchange;
			commands->titratable = TRUE;
			LoadString(hInst, IDS_DEAE_CELLULOSE, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_CMC:
			commands->sepMedia = CM_cellulose;
			commands->sepType = Ion_exchange;
			commands->titratable = TRUE;
			LoadString(hInst, IDS_CM_CELLULOSE, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_QS:
			commands->sepMedia = Q_Sepharose;
			commands->sepType = Ion_exchange;
			commands->titratable = FALSE;
			LoadString(hInst, IDS_Q_SEPHAROSE, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_SS:
			commands->sepMedia = S_Sepharose;
			commands->sepType = Ion_exchange;
			commands->titratable = TRUE;
			LoadString(hInst, IDS_S_SEPHAROSE, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_SALT:
			CheckRadioButton(hDlg, IDC_SALT, IDC_PH, IDC_SALT);
			commands->gradientIsSalt = TRUE;
			elutionSelected = TRUE;
			if (mediumSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_PH:
			commands->gradientIsSalt = FALSE;
			elutionSelected = TRUE;
			if (mediumSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDINFO:
			HtmlHelp(GetParent(hDlg), szHelpFilename ,HH_HELP_CONTEXT, IDH_IONEX);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the equliliration box.
INT_PTR CALLBACK GetpH(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hSpinner = GetDlgItem(hDlg, IDC_SPIN1);
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value;
	WCHAR valueText[10];

	int increment;

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner, UDM_SETBUDDY, (WPARAM) hValue, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner, UDM_SETRANGE, (WPARAM)20, (LPARAM)110);
		SendMessage(hSpinner, UDM_SETPOS, (WPARAM)20, (LPARAM)70);

		swprintf(valueText,8,L"%.1f",7.0);
		SetWindowText(hValue, valueText);
		value = 70;

	
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;

		if (nCode==UDN_DELTAPOS)
		{
			lpUD = (LPNMUPDOWN)lParam;
			value += lpUD->iDelta;
			if (value < 20) 
			{
				value=20;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)20, (LPARAM)value);
			}
			if (value > 110)
			{
				value = 110;
				SendMessage(hSpinner, UDM_SETPOS, (WPARAM)20, (LPARAM)value);
			}
			SendMessage(hSpinner, UDM_SETPOS, (WPARAM)20, (LPARAM)value);
			swprintf(valueText,9,L"%.1f",(double)value/10.0);
			SetWindowText(hValue, valueText);
			redrawControlInDialog(hValue, hDlg); 
		}

		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			commands->pH = (double)value/10.0;
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the Salt gradient box.
INT_PTR CALLBACK GetSaltGradient(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue1 = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hValue2 = GetDlgItem(hDlg, IDC_VALUE2);
	HWND hSpinner1 = GetDlgItem(hDlg, IDC_SPIN1);
	HWND hSpinner2 = GetDlgItem(hDlg, IDC_SPIN2);
	HWND sender = NULL;
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value1;
	static int value2;
	WCHAR value1Text[10];
	WCHAR value2Text[10];
	WCHAR buffer[200];

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue1, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
			SendMessage(hValue2, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner1, UDM_SETBUDDY, (WPARAM) hValue1, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETRANGE, (WPARAM)0, (LPARAM)30);
		SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)0);

		SendMessage(hSpinner2, UDM_SETBUDDY, (WPARAM) hValue2, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETRANGE, (WPARAM)0, (LPARAM)30);
		SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)5);

		swprintf(value1Text, 8, L"%.1f", 0.0);
		SetWindowText(hValue1, value1Text);
		value1 = 0;

		swprintf(value2Text, 8, L"%.1f", 0.5);
		SetWindowText(hValue2, value2Text);
		value2 = 5;

		commands->startGrad = 0.0;
		commands->endGrad = 0.5;
		
		LoadString(hInst, IDS_SALT_GRADIENT_TITLE, buffer, 150);
		SetWindowText(hDlg, buffer);

		LoadString(hInst, IDS_START_OF_GRADIENT, buffer, 150);
		SetWindowText(GetDlgItem(hDlg, IDC_START), buffer);

		LoadString(hInst, IDS_END_OF_GRADIENT, buffer, 150);
		SetWindowText(GetDlgItem(hDlg, IDC_END), buffer);
	
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;
		sender = ((LPNMHDR)lParam)->hwndFrom;

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner1))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value1 += lpUD->iDelta;
			if (value1 < 0)
			{
				value1 = 0;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			if (value1 > 30)
			{
				value1 = 30;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			swprintf(value1Text,4,L"%.1f",(double)value1/10.0);
			SetWindowText(hValue1, value1Text);
			redrawControlInDialog(hValue1, hDlg);
			commands->startGrad = (double)value1/10.0;
/*
			if (value2 < value1)
			{
				value2 = value1;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
				swprintf(value2Text,4,L"%.1f",(double)value2/10.0);
				SetWindowText(hValue2, value2Text);
				redrawControlInDialog(hValue2, hDlg);
				commands->endGrad = (double)value2/10.0;
			}
*/
		}

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner2))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value2 += lpUD->iDelta;
			if (value2 < 0)
			{
				value2 = 0;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			if (value2 > 30)
			{
				value2 = 30;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			swprintf(value2Text,4,L"%.1f",(double)value2/10.0);
			SetWindowText(hValue2, value2Text);
			redrawControlInDialog(hValue2, hDlg);
			commands->endGrad = (double)value2/10.0;
/*
			if (value1 > value2)
			{
				value1 = value2;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
				swprintf(value1Text,4,L"%.1f",(double)value1/10.0);
				SetWindowText(hValue1, value1Text);
				redrawControlInDialog(hValue1, hDlg);
				commands->startGrad = (double)value1/10.0;
			}
*/		}
		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			commands->startGrad = (double)value1/10.0;
			commands->endGrad = (double)value2/10.0;
			InvalidateRect(GetParent(hDlg), NULL, TRUE);
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the pH gradient box.
INT_PTR CALLBACK GetpHGradient(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue1 = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hValue2 = GetDlgItem(hDlg, IDC_VALUE2);
	HWND hSpinner1 = GetDlgItem(hDlg, IDC_SPIN1);
	HWND hSpinner2 = GetDlgItem(hDlg, IDC_SPIN2);
	HWND sender = NULL;
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value1;
	static int value2;
	WCHAR value1Text[10];
	WCHAR value2Text[10];
	WCHAR buffer[200];

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue1, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
			SendMessage(hValue2, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner1, UDM_SETBUDDY, (WPARAM) hValue1, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETRANGE, (WPARAM)20, (LPARAM)110);
		SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)70);

		SendMessage(hSpinner2, UDM_SETBUDDY, (WPARAM) hValue2, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETRANGE, (WPARAM)20, (LPARAM)110);
		SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)70);

		swprintf(value1Text, 8, L"%.1f",7.0);
		SetWindowText(hValue1, value1Text);
		value1 = 70;

		SetWindowText(hValue2, value1Text);
		value2 = 70;

		commands->startGrad = 7.0;
		commands->endGrad = 7.0;
		
		LoadString(hInst, IDS_PH_GRADIENT_TITLE, buffer, 150);
		SetWindowText(hDlg, buffer);

		LoadString(hInst, IDS_START_OF_GRADIENT, buffer, 150);
		SetWindowText(GetDlgItem(hDlg, IDC_START), buffer);

		LoadString(hInst, IDS_END_OF_GRADIENT, buffer, 150);
		SetWindowText(GetDlgItem(hDlg, IDC_END), buffer);

		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;
		sender = ((LPNMHDR)lParam)->hwndFrom;

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner1))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value1 += lpUD->iDelta;
			if (value1 < 20)
			{
				value1 = 20;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)20, (LPARAM)value1);
			}
			if (value1 > 110)
			{
				value1 = 110;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)20, (LPARAM)value1);
			}
			swprintf(value1Text,4,L"%.1f",(double)value1/10.0);
			SetWindowText(hValue1, value1Text);
			redrawControlInDialog(hValue1, hDlg);
			commands->startGrad = (double)value1/10.0;
		}

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner2))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value2 += lpUD->iDelta;
			if (value2 < 20)
			{
				value2 = 20;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)20, (LPARAM)value2);
			}
			if (value2 > 110)
			{
				value2 = 110;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)20, (LPARAM)value2);
			}
			swprintf(value2Text,4,L"%.1f",(double)value2/10.0);
			SetWindowText(hValue2, value2Text);
			redrawControlInDialog(hValue2, hDlg);
			commands->endGrad = (double)value2/10.0;
		}
		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			commands->startGrad = (double)value1/10.0;
			commands->endGrad = (double)value2/10.0;
			InvalidateRect(GetParent(hDlg), NULL, TRUE);
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for HIC choice box.
INT_PTR CALLBACK GetHIC(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);

	switch (message)
	{
	case WM_INITDIALOG:
		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE ); 
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		
		switch (LOWORD(wParam))
		{
		case IDC_PHENYL:
			CheckRadioButton(hDlg, IDC_PHENYL, IDC_OCTYL, IDC_PHENYL);
			commands->sepMedia = Phenyl_Sepharose;
			commands->sepType = Hydrophobic_interaction;
			commands->gradientIsSalt = TRUE;
			LoadString(hInst, IDS_PHENYL_SEPHAROSE, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		case IDC_OCTYL:
			commands->sepMedia = Octyl_Sepharose;
			commands->sepType = Hydrophobic_interaction;
			commands->gradientIsSalt = TRUE;
			LoadString(hInst, IDS_OCTYL_SEPHAROSE, separation->mediumString, 250);
			EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		

		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDINFO:
			HtmlHelp(GetParent(hDlg), szHelpFilename ,HH_HELP_CONTEXT,IDH_HIC);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the HIC Salt gradient box.
INT_PTR CALLBACK GetHICGradient(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	HWND hValue1 = GetDlgItem(hDlg, IDC_VALUE1);
	HWND hValue2 = GetDlgItem(hDlg, IDC_VALUE2);
	HWND hSpinner1 = GetDlgItem(hDlg, IDC_SPIN1);
	HWND hSpinner2 = GetDlgItem(hDlg, IDC_SPIN2);
	HWND sender = NULL;
	LOGFONT lf;
	HFONT hFont;
	LPNMUPDOWN lpUD;
	int nCode;
	static int value1;
	static int value2;
	WCHAR value1Text[10];
	WCHAR value2Text[10];
	WCHAR buffer[200];

	switch (message)
	{
	case WM_INITDIALOG:

		// Set the font for the Value box
		ZeroMemory(&lf, sizeof(LOGFONT));
		lf.lfHeight = 40;
		lf.lfWeight = FW_MEDIUM;
		_tcscpy(lf.lfFaceName, _T("Arial"));

		hFont = CreateFontIndirect(&lf);
		if ((HFONT)0 != hFont)
		{
			SendMessage(hValue1, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
			SendMessage(hValue2, WM_SETFONT, (WORD)hFont, (LPARAM)TRUE);
		}

		SendMessage(hSpinner1, UDM_SETBUDDY, (WPARAM) hValue1, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner1, UDM_SETRANGE, (WPARAM)0, (LPARAM)60);
		SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)20);

		SendMessage(hSpinner2, UDM_SETBUDDY, (WPARAM) hValue2, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETBASE, (WPARAM)10, (LPARAM)0);
		SendMessage(hSpinner2, UDM_SETRANGE, (WPARAM)0, (LPARAM)60);
		SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)0);

		swprintf(value1Text, 8, L"%.1f",2.0);
		SetWindowText(hValue1,value1Text);
		value1 = 20;

		swprintf(value2Text, 8, L"%.1f",0.0);
		SetWindowText(hValue2, value2Text);
		value2 = 0;

		commands->startGrad = 2.0;
		commands->endGrad = 0.0;
		
		LoadString(hInst, IDS_SALT_GRADIENT_TITLE, buffer, 150);
		SetWindowText(hDlg, buffer);

		LoadString(hInst, IDS_START_OF_GRADIENT, buffer, 150);
		SetWindowText(GetDlgItem(hDlg, IDC_START), buffer);

		LoadString(hInst, IDS_END_OF_GRADIENT, buffer, 150);
		SetWindowText(GetDlgItem(hDlg, IDC_END), buffer);
	
		return (INT_PTR)TRUE;

	case WM_NOTIFY:
		nCode = ((LPNMHDR)lParam)->code;
		sender = ((LPNMHDR)lParam)->hwndFrom;

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner1))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value1 += lpUD->iDelta;
			if (value1 < 0)
			{
				value1 = 0;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			if (value1 > 60)
			{
				value1 = 60;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
			}
			swprintf(value1Text,4,L"%.1f",(double)value1/10.0);
			SetWindowText(hValue1, value1Text);
			redrawControlInDialog(hValue1, hDlg);
			commands->startGrad = (double)value1/10.0;
/*
			if (value2 < value1)
			{
				value2 = value1;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
				swprintf(value2Text,4,L"%.1f",(double)value2/10.0);
				SetWindowText(hValue2, value2Text);
				redrawControlInDialog(hValue2, hDlg);
				commands->endGrad = (double)value2/10.0;
			}
*/
		}

		if ((nCode==UDN_DELTAPOS) && (sender==hSpinner2))
		{
			lpUD = (LPNMUPDOWN)lParam;
			value2 += lpUD->iDelta;
			if (value2 < 0)
			{
				value2 = 0;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			if (value2 > 60)
			{
				value2 = 60;
				SendMessage(hSpinner2, UDM_SETPOS, (WPARAM)0, (LPARAM)value2);
			}
			swprintf(value2Text,4,L"%.1f",(double)value2/10.0);
			SetWindowText(hValue2, value2Text);
			redrawControlInDialog(hValue2, hDlg);
			commands->endGrad = (double)value2/10.0;
/*
			if (value1 > value2)
			{
				value1 = value2;
				SendMessage(hSpinner1, UDM_SETPOS, (WPARAM)0, (LPARAM)value1);
				swprintf(value1Text,4,L"%.1f",(double)value1/10.0);
				SetWindowText(hValue1, value1Text);
				redrawControlInDialog(hValue1, hDlg);
				commands->startGrad = (double)value1/10.0;
			}
*/		}
		return (INT_PTR) TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			commands->startGrad = (double)value1/10.0;
			commands->endGrad = (double)value2/10.0;
			InvalidateRect(GetParent(hDlg), NULL, TRUE);
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for the HIC Precipitate box.
INT_PTR CALLBACK YesNo(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);

	switch (message)
	{
	case WM_INITDIALOG:

		SetWindowText(GetDlgItem( hDlg, IDC_MESSAGE ), separation->messageString);
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:
		switch (LOWORD(wParam))
		{
		case IDYES:
			EndDialog(hDlg, (WORD)IDYES);
			return (INT_PTR)TRUE;

		case IDNO:
			EndDialog(hDlg, (WORD)IDNO);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}

// Message handler for Affinity chromatography choice box.
INT_PTR CALLBACK GetAffinity(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	static BOOL mediumSelected;
	static BOOL elutionSelected;

	WCHAR buffer[200];

	switch (message)
	{
	case WM_INITDIALOG:  

		

		LoadString(hInst, IDS_IMMOBILIZED_A, buffer, 199);
		swprintf(buffer, 199, buffer, proteinData->enzyme);
		SetWindowText(GetDlgItem(hDlg, IDC_MONOCLONAL1), buffer);

		LoadString(hInst, IDS_IMMOBILIZED_B, buffer, 199);
		swprintf(buffer, 199, buffer, proteinData->enzyme);
		SetWindowText(GetDlgItem(hDlg, IDC_MONOCLONAL2), buffer);

		LoadString(hInst, IDS_IMMOBILIZED_C, buffer, 199);
		swprintf(buffer, 199, buffer, proteinData->enzyme);
		SetWindowText(GetDlgItem(hDlg, IDC_MONOCLONAL3), buffer);

		EnableWindow( GetDlgItem( hDlg, IDOK ), FALSE );

		mediumSelected = FALSE;
		elutionSelected = FALSE;
		return (INT_PTR)TRUE;

	case WM_CTLCOLORSTATIC:
		SetBkMode((HDC)wParam, TRANSPARENT);
		return (long) GetStockObject(NULL_BRUSH);

	case WM_CTLCOLORDLG:
		return (long)hDlgBkgBrush;

	case WM_COMMAND:

		switch (LOWORD(wParam))
		{
		case IDC_MONOCLONAL1:
			CheckRadioButton(hDlg, IDC_MONOCLONAL1, IDC_NICKEL, IDC_MONOCLONAL1);
			commands->sepMedia = AntibodyA;
			commands->sepType = Affinity;
			LoadString(hInst, IDS_IMMOBILIZED_A, separation->mediumString, 250);
			swprintf(separation->mediumString, 250, separation->mediumString, proteinData->enzyme);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_MONOCLONAL2:
			commands->sepMedia = AntibodyB;
			commands->sepType = Affinity;
			LoadString(hInst, IDS_IMMOBILIZED_B, separation->mediumString, 250);
			swprintf(separation->mediumString, 250, separation->mediumString, proteinData->enzyme);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_MONOCLONAL3:
			commands->sepMedia = AntibodyC;
			commands->sepType = Affinity;
			LoadString(hInst, IDS_IMMOBILIZED_C, separation->mediumString, 250);
			swprintf(separation->mediumString, 250, separation->mediumString, proteinData->enzyme);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_POLYCLONAL:
			commands->sepMedia = Polyclonal;
			commands->sepType = Affinity;
			LoadString(hInst, IDS_POLYCLONAL, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_IMM_INHIBITOR:
			commands->sepMedia = Immobilized_inhibitor;
			commands->sepType = Affinity;
			LoadString(hInst, IDS_IMMOBILIZED_INHIBITOR, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;


		case IDC_NICKEL:
			commands->sepMedia = NiNTAagarose;
			commands->sepType = Affinity;
			LoadString(hInst, IDS_NICKEL, separation->mediumString, 250);
			mediumSelected = TRUE;
			if (elutionSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_TRIS:
			CheckRadioButton(hDlg, IDC_TRIS, IDC_IMIDAZOLE, IDC_TRIS);
			commands->affinityElution = Tris;
			elutionSelected = TRUE;
			if (mediumSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_GLYCINE:
			commands->affinityElution = Acid;
			elutionSelected = TRUE;
			if (mediumSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_INHIBITOR:
			commands->affinityElution = Inhibitor;
			elutionSelected = TRUE;
			if (mediumSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;

		case IDC_IMIDAZOLE:
			commands->affinityElution = Imidazole;
			elutionSelected = TRUE;
			if (mediumSelected)
				EnableWindow( GetDlgItem( hDlg, IDOK ), TRUE );
			return (INT_PTR)TRUE;
		
		case IDOK:
			EndDialog(hDlg, (WORD)TRUE);
			return (INT_PTR)TRUE;

		case IDINFO:
			HtmlHelp(GetParent(hDlg), szHelpFilename ,HH_HELP_CONTEXT, IDH_AFFINITY);
			return (INT_PTR)TRUE;

		case IDCANCEL:
			EndDialog(hDlg, (WORD)FALSE);
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}
