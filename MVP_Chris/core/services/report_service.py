from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch
from io import BytesIO
from core.api.schemas import ResponseRead
import re

def generate_pdf_report(data: ResponseRead) -> BytesIO:
    buffer = BytesIO()
    doc = SimpleDocTemplate(buffer, pagesize=A4)
    styles = getSampleStyleSheet()
    
    # Custom Styles
    title_style = styles["Title"]
    heading_style = styles["Heading2"]
    normal_style = styles["Normal"]
    
    story = []
    
    # --- Cover Page ---
    story.append(Paragraph("AI Compass Assessment Report", title_style))
    story.append(Spacer(1, 0.5 * inch))
    
    story.append(Paragraph(f"Company: {data.company_name}", heading_style))
    story.append(Paragraph(f"Date: {data.completed_at or 'N/A'}", normal_style))
    story.append(Spacer(1, 0.5 * inch))
    
    # Overall Score
    story.append(Paragraph(f"Overall AI Maturity Score: {data.overall_score:.1f} / 100", styles["Heading1"]))
    story.append(Spacer(1, 0.2 * inch))
    
    if data.cluster:
        story.append(Paragraph(f"Cluster Profile: {data.cluster.name}", heading_style))
        story.append(Paragraph(data.cluster.description, normal_style))
    
    story.append(PageBreak())
    
    # --- Dimension Breakdown ---
    story.append(Paragraph("Dimension Breakdown", heading_style))
    story.append(Spacer(1, 0.2 * inch))
    
    # Table Data
    table_data = [["Dimension", "Score (1-5)", "Status"]]
    for dim in data.dimension_scores:
        status = "Low"
        if dim.score > 3.5: status = "High"
        elif dim.score > 2.0: status = "Medium"
        
        table_data.append([dim.dimension_name, f"{dim.score:.1f} / 5.0", status])
        
    t = Table(table_data, colWidths=[3.5*inch, 1.5*inch, 1.5*inch])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.blue),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 12),
        ('BACKGROUND', (0, 1), (-1, -1), colors.beige),
        ('GRID', (0, 0), (-1, -1), 1, colors.black),
    ]))
    story.append(t)
    story.append(PageBreak())
    
    # --- Roadmap ---
    story.append(Paragraph("Strategic Roadmap", title_style))
    story.append(Spacer(1, 0.2 * inch))
    
    if data.roadmap:
        phases = ["Phase 1: Foundation", "Phase 2: Implementation", "Phase 3: Scale & Governance"]
        for phase in phases:
            if phase in data.roadmap:
                items = data.roadmap[phase]
                if items:
                    story.append(Paragraph(phase, heading_style))
                    for item in items:
                        # Theme
                        p_theme = Paragraph(f"<b>{item.theme}</b> ({item.source})", styles["Heading3"])
                        story.append(p_theme)
                        # Explanation (handle basic markdown)
                        clean_expl = re.sub(r'\*\*(.*?)\*\*', r'<b>\1</b>', item.explanation)
                        # Split lines to avoid huge paragraphs
                        for line in clean_expl.split('\n'):
                            if line.strip():
                                story.append(Paragraph(line, normal_style))
                        story.append(Spacer(1, 0.1 * inch))
                    story.append(Spacer(1, 0.2 * inch))
    else:
        story.append(Paragraph("No roadmap generated.", normal_style))

    doc.build(story)
    buffer.seek(0)
    return buffer
