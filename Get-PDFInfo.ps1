function Get-PDFInfo
{
  <#
      .Synopsis
      Get Infos from a PDF file
      .DESCRIPTION
      Use iTextSharp PDFReader class to get infos from a given PDF
      .EXAMPLE
      Get-PDFInfo -File YourFile.pdf
  #>
  [CmdletBinding()]
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
         
    [switch]$Javascript
  )
 
  Begin
  {
    Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
    $reader  = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $(Join-Path $pwd $Name)
  }
  Process
  {
    # Output of PDFReader Info is a hashtable:
    $info = $reader.Info
     
    # Change DateTime to human-readable format and add both to the hashtable again
    $ModDate = (Select-String -InputObject $info.ModDate -Pattern "\d{14}").Matches.Value
    $CreationDate = (Select-String -InputObject $info.CreationDate -Pattern "\d{14}").Matches.Value
    $info.ModDate = [datetime]::ParseExact($ModDate,"yyyyMMddHHmmss", $null)
    $info.CreationDate = [datetime]::ParseExact($CreationDate,"yyyyMMddHHmmss",$null)
     
    # Add more keys to the hashtable:
    $info += @{NumberOfPages = $reader.NumberOfPages}
    $info += @{FileLength = $reader.FileLength}
    $info += @{PdfVersion = $reader.PdfVersion}
    $info += @{IsEncrypted = $reader.IsEncrypted()}
     
    $info += @{PageSize = $reader.GetPageSize(1)}
    
    # Maybe the PDF contains JavaScript?
    if ($Javascript)
    {
      $info += @{JavaScript = $reader.JavaScript}
    }    
  }
  End
  {
    $info.GetEnumerator() | Sort-Object -Property name
  }
}
