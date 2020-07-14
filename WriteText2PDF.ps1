Add-Type -Path $(Join-Path $pwd "itextsharp.dll")
$doc  = New-Object iTextSharp.text.Document
$stream = [IO.File]::OpenWrite($(Join-Path $pwd "TextPDF.pdf"))
$writer = [itextsharp.text.pdf.PdfWriter]::GetInstance($doc, $stream)
[void]$doc.AddTitle("The Title")
[void]$doc.AddSubject("A Text")
[void]$doc.AddAuthor("Christian Imhorst")
$doc.Open()
# Set fonts
$title = [iTextSharp.text.FontFactory]::GetFont("HELVETICA_BOLD", 28, [iTextSharp.text.BaseColor]::DARK_GRAY)
$heading = [iTextSharp.text.FontFactory]::GetFont("HELVETICA_BOLD", 18, [iTextSharp.text.BaseColor]::BLACK)
$standard = [iTextSharp.text.FontFactory]::GetFont("HELVETICA", 12, [iTextSharp.text.BaseColor]::BLACK)
$p = New-Object iTextSharp.text.Paragraph
[void]$p.Add([iTextSharp.text.Paragraph]::new("The Title", $title))
# Chunk is the smallest part of text that can be added to a document 
[void]$p.Add([iTextSharp.text.Chunk]::NEWLINE)
[void]$p.Add([iTextSharp.text.Paragraph]::new("This is a heading", $heading))
[void]$p.Add([iTextSharp.text.Chunk]::NEWLINE)
[void]$p.Add([iTextSharp.text.Paragraph]::new("Hello World!

Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor 
invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et 
accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata 
sanctus est Lorem ipsum dolor sit amet.")) 
[void]$doc.Add($p)
$doc.Dispose()
$stream.Close()
