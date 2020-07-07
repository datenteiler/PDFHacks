function Set-WatermarkToPDF
{
  <#
      .Synopsis
      Set a watermark to a PDF
      .DESCRIPTION
      You can set a given watermark from an image file to a PDF.
      Output is a new PDF with a watermark.
      .EXAMPLE
      Set-WatermarkToPDF -Name My.pdf -Output My_Copy.pdf -Watermark watermark.png -SetAbsolutePositionXY 0,600 # 100,300

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
    $Name,
        
    [String]
    [Parameter(
        Mandatory,
      Position=1)
    ]
    $Output,
        
    # File with the watermark
    [String]
    [Parameter(
        Mandatory,
      Position=2)
    ]
    $Watermark,
    
    # Set absolut position of the watermark
    [int[]]
    [Parameter(
        Mandatory,
        Position = 3)
    ]
    $SetAbsolutePositionXY
  )

  Begin
  {
    Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
    $reader  = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $(Join-Path $pwd $Name)
    $memoryStream = New-Object System.IO.MemoryStream
    $pdfStamper = New-Object iTextSharp.text.pdf.PdfStamper($reader, $memoryStream)

    $img = [iTextSharp.text.Image]::GetInstance($Watermark)
    $img.SetAbsolutePosition($SetAbsolutePositionXY[0], $SetAbsolutePositionXY[1])
    [iTextSharp.text.pdf.PdfContentByte]$myWaterMark
  }
  Process
  {    
    $pageIndex = $reader.NumberOfPages
    
    for ($i = 1; $i -le $pageIndex; $i++) {
      $myWaterMark = $pdfStamper.GetOverContent($i)
      $myWaterMark.AddImage($img)
    }
    
    $pdfStamper.FormFlattening = $true
    $pdfStamper.Dispose()

    $bytes = $memoryStream.ToArray()
    $memoryStream.Dispose()
    $reader.Dispose()
    [System.IO.File]::WriteAllBytes($Output, $bytes)
    }
  End {}
}
