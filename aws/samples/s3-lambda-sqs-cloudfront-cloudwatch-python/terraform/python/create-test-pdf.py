# create test pdf file with number inside it
# then upload to s3 bucket
# pip install reportlab
from reportlab.pdfgen import canvas

def create_pdf(file_path, text):
    c = canvas.Canvas(file_path)
    c.drawString(100, 750, text)
    c.save()

## create local "temp" folder
for i in range(70001, 72890):
    create_pdf(f"test{i}.pdf", f"Hello! test pdf file {i} This is file number {i}")
