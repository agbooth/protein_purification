#include "StdAfx.h"
#include "Logs.h"
#include <strsafe.h>
// ...
void Log( LPCTSTR sFormat, ... )
{
    va_list argptr;      
    va_start( argptr, sFormat ); 
    TCHAR buffer[ 4096 ];
    HRESULT hr = StringCbVPrintf( buffer, sizeof( buffer ), sFormat, argptr );
    if ( STRSAFE_E_INSUFFICIENT_BUFFER == hr || S_OK == hr )
        OutputDebugString( buffer );
    else
        OutputDebugString( _T("StringCbVPrintf error.") );
}

// The equivalent for ASCII
void LogA( LPSTR sFormat, ... )
{
    va_list argptr;      
    va_start( argptr, sFormat ); 
    char buffer[ 4096 ];
    HRESULT hr = StringCbVPrintfA( buffer, sizeof( buffer ), sFormat, argptr );
    if ( STRSAFE_E_INSUFFICIENT_BUFFER == hr || S_OK == hr )
        OutputDebugStringA( buffer );
    else
        OutputDebugStringA( "StringCbVPrintf error." );
}