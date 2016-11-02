#include "stdafx.h"
#include "EZFont.h"
#include "Resource.h"
#include "Protpure.h"
#include "Logs.h"

extern HINSTANCE hInst;
extern int clientWidth;
extern int clientHeight;

int DrawText(HDC hdc, int x, int y, int id, int pointsize, COLORREF colour)
{
	HFONT hFont;
	LOGFONT lf;
	TEXTMETRIC tm;
	TCHAR text[500];

	hFont = EzCreateFont( hdc, TEXT("Arial"), pointsize * 10, 0, EZ_ATTR_BOLD, TRUE);
	GetObject(hFont, sizeof(LOGFONT), &lf);
	SelectObject (hdc, hFont);
	GetTextMetrics(hdc, &tm);
	LoadString(hInst, id, text, 4096);
	SetBkMode(hdc, TRANSPARENT);
	SetTextColor(hdc, colour);
	TextOut(hdc, x,y, text, lstrlen(text));
	DeleteObject(SelectObject( hdc, GetStockObject(SYSTEM_FONT)));

	return tm.tmHeight+tm.tmExternalLeading;
}

int DrawString(HDC hdc, int x, int y, WCHAR* text, int pointsize, COLORREF colour)
{
	HFONT hFont;
	LOGFONT lf;
	TEXTMETRIC tm;

	hFont = EzCreateFont( hdc, TEXT("Arial"), pointsize * 10, 0, EZ_ATTR_BOLD, TRUE);
	GetObject(hFont, sizeof(LOGFONT), &lf);
	SelectObject (hdc, hFont);
	GetTextMetrics(hdc, &tm);
	SetBkMode(hdc, TRANSPARENT);
	SetTextColor(hdc, colour);
	TextOut(hdc, x,y, text, lstrlen(text));
	DeleteObject(SelectObject( hdc, GetStockObject(SYSTEM_FONT)));

	return tm.tmHeight+tm.tmExternalLeading;
}

void PaintSplash(HWND hWnd)
{
	HDC hMemDC;
	RECT clientRect, windowRect;
	int pos = 20;
	PAINTSTRUCT ps;

    HDC hdc = BeginPaint(hWnd, &ps);
	if ((hMemDC = CreateCompatibleDC(hdc)) != NULL)
	{
		DrawText(hdc, 20,pos+2, IDS_APP_TITLE,30, RGB(213,213,213));
		pos += 3*DrawText(hdc, 20,pos, IDS_APP_TITLE,30, RGB(0,0,0))/2;
		DrawText(hdc, 20,pos+1, IDS_AUTHOR, 20,  RGB(213,213,213));		 
		pos += 3*DrawText(hdc, 20,pos, IDS_AUTHOR, 20,  RGB(0,0,0))/2;
		DrawText(hdc, 20,pos+1, IDS_ADDRESS1, 20, RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_ADDRESS1, 20, RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_ADDRESS2, 20, RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_ADDRESS2, 20, RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_ADDRESS3, 20, RGB(213,213,213));
		pos += 3*DrawText(hdc, 20,pos, IDS_ADDRESS3, 20, RGB(0,0,0))/2;
		DrawText(hdc, 20,pos+1, IDS_TRANSLATOR1,20,  RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_TRANSLATOR1,20,  RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_TRANSLATOR2,20, RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_TRANSLATOR2,20, RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_TRANSLATOR3,20, RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_TRANSLATOR3,20, RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_TRANSLATOR4,20, RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_TRANSLATOR4,20, RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_TRANSLATOR5,20,  RGB(213,213,213));
		pos += DrawText(hdc, 20,pos, IDS_TRANSLATOR5,20,  RGB(0,0,0));
		DrawText(hdc, 20,pos+1, IDS_TRANSLATOR6,20,  RGB(213,213,213));
		DrawText(hdc, 20,pos, IDS_TRANSLATOR6,20,  RGB(0,0,0));

		// If this is the first time that the window has appeared, remember its dimensions
		GetClientRect(hWnd, (LPRECT)&clientRect );
		if (clientWidth==0) clientWidth = clientRect.right;
		if (clientHeight==0) clientHeight = clientRect.bottom;
	}

	EndPaint(hWnd, &ps);
	DeleteDC(hMemDC);
}