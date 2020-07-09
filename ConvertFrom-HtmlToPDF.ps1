function ConvertFrom-HtmlToPDF
{
  <#
      .Synopsis
      Convert your HTML page to PDF
      .DESCRIPTION
      Convert your HTML page to PDF with iTextSharp
      .EXAMPLE
      ConvertFrom-HtmlToPDF -HTML sample.html -Output sample.pdf
  #>
    Param
    (
        # Insert your HTML
        [Parameter(Mandatory,
                   ValueFromPipelineByPropertyName,
                   ValueFromPipeline,
                   Position=0)]
        $HTML,

        # PDF file out
        [String]
        [Parameter(Mandatory,
                   Position=1)]
        $Output
    )

    Begin
    {
      Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
      $doc  = New-Object iTextSharp.text.Document
      $memoryStream = New-Object System.IO.MemoryStream
      $null = [itextsharp.text.pdf.PdfWriter]::GetInstance($doc, $memoryStream)
      $example_html = $(Get-Content $(Join-Path $pwd $HTML) | Out-String)
      
    }
    Process
    {
      $doc.Open()

      # Use the built-in HTMLWorker to parse the HTML.
      # Only inline CSS is supported.
      $htmlWorker = New-Object iTextSharp.text.html.simpleparser.HTMLWorker($doc)

      # HTMLWorker doesn't read a string directly but instead needs a TextReader
      $sr = new-object System.IO.StringReader($example_html)
      $htmlWorker.Parse($sr)

      $doc.Close()

      $bytes = $memoryStream.ToArray()
      [System.IO.File]::WriteAllBytes($(Join-Path $pwd $Output), $bytes)
    }
    End {}
}
