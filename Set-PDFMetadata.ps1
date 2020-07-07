function Set-PDFMetadata
{
  <#
      .Synopsis
      Set or change metadata in your PDF file
      .DESCRIPTION
      Set or change metadata in your PDF file with iTextSharp
      .EXAMPLE
      Set-PDFMetadata -File Input.pdf -Output Output_neu.pdf -Metadata @{"Author" = "Christian Imhorst"}
      .EXAMPLE
      Set-PDFMetadata -File Input.pdf -Output Output_neu.pdf -Metadata @{"Author" = "Christian Imhorst"; "Creator" = "PowerShell"; "Conference" = "PSConfEU2019"; "Hashtag" = "#PSConfEU2019"}
  #>
  Param
  (
    # Insert filename
    [String]
    [Parameter(
        Mandatory,
        ValueFromPipeline,
        ValueFromPipelineByPropertyName,
        Position=0)
    ]
    $File,
    # Name of the output file    
    [String]
    [Parameter(
        Mandatory,
        Position=1)
    ]
    $Output,
    
    # Hashtable with your metadata: @{"Author" = "Christian Imhorst"}
    [hashtable]
    [Parameter(
        Mandatory,
        Position=2)
    ]
    $Metadata
  )

  Begin
  {
    Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
    $reader  = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $(Join-Path $pwd $File)
    $fs = [System.IO.FileStream]::new($(Join-Path $pwd $Output), [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write, [System.IO.FileShare]::None)
    $stamper = New-Object iTextSharp.text.pdf.PdfStamper($reader, $fs)  
  }
  Process
  {
    $info = $reader.Info
    foreach ($key in $Metadata.Keys)
    {
      if ($info.ContainsKey($key))
      {
        $info.Remove($key)
      }
      $info.Add($key, $Metadata[$key])
    }
    
    $stamper.MoreInfo = $info
    $stamper.Dispose()
  }
  End
  {
    $fs.Dispose()
    $reader.Dispose()
  }
}
