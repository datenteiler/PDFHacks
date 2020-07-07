function New-PDFFile
{
   <#
      .Synopsis
      Write title and text to a PDF file
      .DESCRIPTION
      You can parse a single line of text, more lines of text or a whole text file to a PDF
      .EXAMPLE
      New-PDFFile -Name New.pdf -Title "My Title" -Text "This is my text"
      .EXAMPLE
      New-PDFFile -Name New.pdf -Title "My Lorem" -Text (Get-Content lorem.txt | Out-String)

      .UPDATE
      iText7 has a couple of dependencies. It depends on:

      Common.Logging version 3.4.1 
      https://www.nuget.org/packages/Common.Logging/3.4.1

      Which depends on Common.Logging.Core also version 3.4.1
      https://www.nuget.org/packages/Common.Logging.Core/3.4.1

      And iText.Kernel.dll also needs Portable.BouncyCastle in version 1.8.1.3 
      https://www.nuget.org/packages/Portable.BouncyCastle/1.8.1.3

      Download the Nuget package and rename .nupkg to .zip. Then you can extract 
      the .dll files from the .zip archive.
   #>
  param
  (
    [String]
    [Parameter(Mandatory)]
    $Name,

    [String]
    [Parameter(Mandatory)]
    $Title,

    [String[]]
    [Parameter(Mandatory)]
    $Text
  )

  begin
  {
    Add-Type -Path $(Join-Path $pwd "lib\Common.Logging.Core.dll")
    Add-Type -Path $(Join-Path $pwd "lib\Common.Logging.dll")
    Add-Type -Path $(Join-Path $pwd "lib\BouncyCastle.Crypto.dll")
    Add-Type -Path $(Join-Path $pwd "lib\itext.io.dll")
    Add-Type -Path $(Join-Path $pwd "lib\itext.kernel.dll")
    Add-Type -Path $(Join-Path $pwd "lib\itext.layout.dll")
    
    [string]$Filename = $(Join-Path $pwd $Name)
  }
  process
  {
    $pdfWriter = [iText.Kernel.Pdf.PdfWriter]::new($Filename)
    $pdf = [iText.Kernel.Pdf.PdfDocument]::new($pdfWriter)
    $doc = [iText.Layout.Document]::new($pdf, [iText.Kernel.Geom.PageSize]::A4)

    $doc.SetMargins(36,36,36,36)

    $heading1 = [iText.Kernel.Font.PdfFontFactory]::CreateFont([iText.IO.Font.FontConstants]::HELVETICA)
    $font = [iText.Kernel.Font.PdfFontFactory]::CreateFont([iText.IO.Font.FontConstants]::TIMES_ROMAN)

    $myTitle = [iText.Layout.Element.Text]::new($Title).SetFont($heading1).SetFontSize(16)
    $myText = [iText.Layout.Element.Text]::new($Text).SetFont($font).SetFontSize(11)

    $theTitle = [iText.Layout.Element.Paragraph]::new()
    $theTitle.Add($myTitle)
    $doc.Add($theTitle)
    
    for ($i = 0; $i -lt $Text.Length; $i++) 
    {
      New-Variable -Name "p$i" -Value ([iText.Layout.Element.Paragraph]::new())
      (Get-Variable -Name "p$i" -ValueOnly).Add($myText)
      $doc.Add((Get-Variable -Name "p$i" -ValueOnly))
    }
  }
  
  end 
  {
    $pdf.Close()
  }  
}
