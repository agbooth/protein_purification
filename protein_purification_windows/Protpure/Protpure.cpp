// Protpure.cpp : Defines the entry point for the application.
// Copyright A.G.Booth 2013

#include "stdafx.h"
#include "Dialogs.h"
#include "SplashView.h"
#include "RecordView.h"
#include "GelView.h"
#include "ElutionView.h"
#include "Commands.h"
#include "ProteinData.h"
#include "Account.h"
#include "Separation.h"
#include "Protpure.h"
#include "objbase.h"
#include "Logs.h"
#include <iostream>
#include <ctime>
#include "shlobj.h"

#define MAX_LOADSTRING 100
#define G_SPLASH	1
#define G_RECORD	2
#define G_GEL		3
#define G_ELUTION	4


// Global Variables:
BOOL IsAdmin;
HINSTANCE hInst;								// current instance
TCHAR szTitle[MAX_LOADSTRING];					// The title bar text
TCHAR szWindowClass[MAX_LOADSTRING];			// the main window class name

WCHAR *szHelpFilename;
int graphic_mode = G_SPLASH;

HBRUSH hDlgBkgBrush = CreateSolidBrush(RGB(213,213,213));  // Background for dialogs

Commands* commands = NULL;
ProteinData* proteinData = NULL;
Separation* separation = NULL;
Account* account = NULL;

BOOL showBlot = FALSE;
BOOL twoDGel = FALSE;

int clientWidth = 0;
int clientHeight = 0;

// Forward declarations of functions included in this code module:
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);

int APIENTRY _tWinMain(HINSTANCE hInstance,
                     HINSTANCE hPrevInstance,
                     LPTSTR    lpCmdLine,
                     int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

 	// TODO: Place code here.
	MSG msg;
	HACCEL hAccelTable;

	// Check if we are running as Administrator
	IsAdmin = IsUserAnAdmin();

	Log(L"Admin is %d\n",IsAdmin);

	// Copy the help file to the temporary directory

	WCHAR sourcePath[MAX_PATH];
	WCHAR destPath[MAX_PATH];
	WCHAR HelpFilename[200];

	// Get the directory in which the exe file exists
	HMODULE hModule = GetModuleHandleW(NULL);
	GetModuleFileName(hModule, sourcePath, MAX_PATH);
	WCHAR *nameStart = wcsrchr(sourcePath,'\\')+1;
	*nameStart = '\0';

	// Add on the name of the help file
	LoadString(hInst,IDS_HELPFILENAME,HelpFilename, 199);
	lstrcat(sourcePath,HelpFilename);

	// Find the system directory for temporary files 
	// Copy the help file across and record its location
	// Fallback to original location
	if (GetTempPath(MAX_PATH, destPath))
	{
		lstrcat(destPath, HelpFilename);
		if (CopyFile(sourcePath, destPath, FALSE))
			szHelpFilename = destPath;
		else
			szHelpFilename = sourcePath;
	}
	else
		szHelpFilename = sourcePath;

	// Initialize global strings
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_PROTPURE, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// Perform application initialization:
	if (!InitInstance (hInstance, nCmdShow))
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_PROTPURE));

	// Main message loop:
	while (GetMessage(&msg, NULL, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	return (int) msg.wParam;
}



//
//  FUNCTION: MyRegisterClass()
//
//  PURPOSE: Registers the window class.
//
//  COMMENTS:
//
//    This function and its usage are only necessary if you want this code
//    to be compatible with Win32 systems prior to the 'RegisterClassEx'
//    function that was added to Windows 95. It is important to call this function
//    so that the application will get 'well formed' small icons associated
//    with it.
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_PROTPURE));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	//wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.hbrBackground	= hDlgBkgBrush;
	wcex.lpszMenuName	= MAKEINTRESOURCE(IDC_PROTPURE);
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_PROTPURE));

	return RegisterClassEx(&wcex);
}

//
//   FUNCTION: InitInstance(HINSTANCE, int)
//
//   PURPOSE: Saves instance handle and creates main window
//
//   COMMENTS:
//
//        In this function, we save the instance handle in a global variable and
//        create and display the main program window.
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
  
//WCHAR locale[256];
//GetUserDefaultLocaleName(locale, 255);
//Log(L"Locale is %s\n",locale);
	
   HWND hWnd;

   hInst = hInstance; // Store instance handle in our global variable

   hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX,
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

   if (!hWnd)
   {
      return FALSE;
   }

   commands = new Commands(hWnd);

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}

//
//  FUNCTION: WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  PURPOSE:  Processes messages for the main window.
//
//  WM_COMMAND	- process the application menu
//  WM_PAINT	- Paint the main window
//  WM_DESTROY	- post a quit message and return
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;

	switch (message)
	{
	case WM_COMMAND:
		wmId    = LOWORD(wParam);
		wmEvent = HIWORD(wParam);
		// Parse the menu selections:
		switch (wmId)
		{
		case IDM_ABOUT:
	//		DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
	//		break;
	//	case IDM_EXIT:
			

	//		DestroyWindow(hWnd);
	//		break;
			
		case IDM_START:
		case IDM_ABANDON_SCHEME:
		case IDM_ABANDON_STEP:
		case IDM_START_FROM_STORED:
		case IDM_STORE:
		case IDM_GO_HOME:
		case IDM_AMMONIUM_SULFATE:
		case IDM_HEAT:                 
		case IDM_GEL_FILTRATION:            
		case IDM_ION_EXCHANGE:
		case IDM_HYDROPHOBIC:
		case IDM_AFFINITY:
		case IDM_1D_PAGE:
		case IDM_2D_PAGE:
		case IDM_COOMASSIE: 
		case IDM_IMMUNOBLOT:
		case IDM_HIDE_GEL:
		case IDM_ASSAY:
		case IDM_DILUTE:
		case IDM_POOL:
		case IDM_INDEX:
		case IDM_TUTORIAL:
			commands->dispatch(wmId);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
		break;
	case WM_PAINT:

		switch (graphic_mode)
		{
		case G_SPLASH:
			PaintSplash(hWnd);
			break;	

		case G_RECORD:
			PaintRecord(hWnd);
			break;

		case G_GEL:
			PaintGel(hWnd);
			break;

		case G_ELUTION:
			PaintElution(hWnd);
			break;
		}

		
		break;
	case WM_DESTROY:
		// Probably not needed, but just to be sure...
		// The destructor of commands should delete the objects that it has created,
		// including account and separation.
		if ( commands != NULL) delete commands; 

		DeleteObject(hDlgBkgBrush);
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}


