function Join-PDFFiles
{
  <#
      .Synopsis
      Join PDF files to one PDF
      .DESCRIPTION
      Join PDF files to one PDF with iTextSharp
      .EXAMPLE
      Join-PDFFiles -Filenames $(gci *.pdf) -Output "JoinedPDFs.pdf"
  #>
  param
  (
    [string[]]
    [Parameter(Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
      Position=0)
    ]
    $Filenames,

    [String]
    [Parameter(Mandatory,
    Position=1)]
    $Output
  )

  begin
  {
    Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
    $doc  = New-Object iTextSharp.text.Document
    $fs = [System.IO.FileStream]::new($(Join-Path $pwd $Output), [System.IO.FileMode]::Create)
    $writer = New-Object iTextSharp.text.pdf.PdfCopy($doc, $fs)
    $doc.Open()
  }
  process
  {
    foreach ($filename in $filenames)
    {
      $reader = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $filename
      $reader.ConsolidateNamedDestinations()
  
      for ($i = 1; $i -le $reader.NumberOfPages; $i++) 
      {
        $page = $writer.GetImportedPage($reader, $i)
        $writer.AddPage($page)
      }
      $reader.Close()
  
    }
  }
  end
  {
    $writer.Close()
    $doc.Close()
  }
}
