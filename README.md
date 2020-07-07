# PDF Hacks with PowerShell and iText

iText is for creating, consuming and manipulating PDF files and iTextSharp is the .NET library for iText 5.
These PowerShell scripts need iTextSharp to run. So first things first: Get iTextSharp e.g. from Nuget:
https://www.nuget.org/packages/iTextSharp/

Rename file from .nupkg to .zip, unpack the itextsharp.dll and copy it to the path of the script.

The script in iText7 shows how it works to create a PDF file with PowerShell and the new iText 7, because iText 5 or iTextSharp is EOL, and has been replaced. Only security fixes will be added. It is highly recommended to use iText 7 for new projects, and to consider moving existing projects from iTextSharp to iText 7.
