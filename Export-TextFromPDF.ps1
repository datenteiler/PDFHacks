function Export-TextFromPDF
{
  <#
      .Synopsis
      Export Text from a PDF file
      .DESCRIPTION
      Use the iTextSharp parser PdfTextExtractor to get only the text from a given PDF
      .EXAMPLE
      Export-TextFromPDF -File YourFile.pdf
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
    $Name
  )
   
  Begin
  {
    Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
    $reader  = New-Object iTextSharp.text.pdf.PdfReader -ArgumentList $(Join-Path $pwd $Name)

  }
  Process
  {
    for ($i = 1; $i -lt $reader.NumberOfPages; $i++) 
    {
      $text = $text + [iTextSharp.text.pdf.parser.PdfTextExtractor]::GetTextFromPage($reader, $i)
    }
  }
  End
  {
    $text
  }
   
}
