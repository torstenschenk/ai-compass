import os
from io import BytesIO
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.graphics.shapes import Drawing, Rect, String
from reportlab.graphics.charts.spider import SpiderChart
from reportlab.graphics.charts.legends import Legend
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, Frame, PageTemplate, NextPageTemplate
from reportlab.lib.units import inch, cm
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_RIGHT

class PDFService:
    def __init__(self):
        pass

    def _header_footer(self, canvas, doc):
        """
        Draws the header and footer on every page (except cover).
        """
        canvas.saveState()
        
        # Only draw header/footer if not page 1
        page_num = canvas.getPageNumber()
        if page_num > 1:
            # Header Line
            canvas.setStrokeColor(colors.HexColor('#e2e8f0'))
            canvas.setLineWidth(1)
            canvas.line(1.5*cm, A4[1] - 1.5*cm, A4[0] - 1.5*cm, A4[1] - 1.5*cm)
            
            # Header Text
            canvas.setFont('Helvetica-Bold', 8)
            canvas.setFillColor(colors.HexColor('#94a3b8'))
            canvas.drawString(1.5*cm, A4[1] - 1.2*cm, "AI EVOLUTION BLUEPRINT")
            
            canvas.setFont('Helvetica', 8)
            canvas.drawRightString(A4[0] - 1.5*cm, A4[1] - 1.2*cm, "CONFIDENTIAL")
            
            # Footer Line
            canvas.line(1.5*cm, 1.5*cm, A4[0] - 1.5*cm, 1.5*cm)
            
            # Footer Text
            canvas.setFont('Helvetica', 8)
            canvas.setFillColor(colors.HexColor('#94a3b8'))
            canvas.drawString(1.5*cm, 1.0*cm, "© 2024 AI-Compass Intelligence")
            
            canvas.drawRightString(A4[0] - 1.5*cm, 1.0*cm, f"Page {page_num}")
        
        canvas.restoreState()

    def generate_pdf(self, data):
        """
        Generates PDF bytes using ReportLab Platypus with Luxury Design.
        """
        import datetime
        
        buffer = BytesIO()
        doc = SimpleDocTemplate(
            buffer,
            pagesize=A4,
            rightMargin=1.5*cm, leftMargin=1.5*cm,
            topMargin=2.5*cm, bottomMargin=2.5*cm, # Increased margins for header/footer space
            title="AI-Compass Maturity Report"
        )
        
        story = []
        styles = getSampleStyleSheet()
        
        # --- Brand Colors ---
        col_primary = colors.HexColor('#4338ca')   # Indigo 700 (Darker/Richer)
        col_accent = colors.HexColor('#6366f1')    # Indigo 500
        col_text = colors.HexColor('#0f172a')      # Slate 900
        col_subtext = colors.HexColor('#64748b')   # Slate 500
        col_bg_light = colors.HexColor('#f8fafc')  # Slate 50
        col_light_border = colors.HexColor('#e2e8f0')
        
        # --- Custom Styles ---
        style_cover_title = ParagraphStyle(
            'CoverTitle', 
            parent=styles['Heading1'], 
            fontSize=32, 
            leading=40,
            textColor=col_primary, 
            alignment=TA_CENTER,
            spaceAfter=20
        )
        style_cover_sub = ParagraphStyle(
            'CoverSub', 
            parent=styles['Normal'], 
            fontSize=14, 
            textColor=col_subtext, 
            alignment=TA_CENTER
        )
        
        style_h1 = ParagraphStyle(
            'H1', 
            parent=styles['Heading2'], 
            fontSize=16, 
            leading=20,
            textColor=col_primary, 
            spaceBefore=24, 
            spaceAfter=12,
            fontName='Helvetica-Bold'
        )
        
        style_h2 = ParagraphStyle(
            'H2', 
            parent=styles['Heading3'], 
            fontSize=12, 
            textColor=col_text, 
            spaceBefore=12, 
            spaceAfter=6,
            fontName='Helvetica-Bold'
        )
        
        style_normal = ParagraphStyle(
            'Body', 
            parent=styles['Normal'], 
            fontSize=10, 
            leading=15, 
            textColor=col_text
        )
        
        style_score_label = ParagraphStyle('ScoreLabel', parent=styles['Normal'], fontSize=9, textColor=col_subtext, alignment=TA_CENTER, textTransform='uppercase', letterSpacing=1)
        style_score_val = ParagraphStyle('ScoreVal', parent=styles['Normal'], fontSize=48, textColor=col_primary, alignment=TA_CENTER, leading=50, fontName='Helvetica-Bold')
        style_score_sub = ParagraphStyle('ScoreSub', parent=styles['Normal'], fontSize=11, textColor=col_text, alignment=TA_CENTER)

        # --- Data Prep ---
        company = data.get("company", {})
        date_str = datetime.date.today().strftime("%B %d, %Y")
        overall_score = data.get("overall_score", 0.0)
        pct_data = data.get("percentile", {})
        percentile_rank = pct_data.get("percentage", "N/A") if isinstance(pct_data, dict) else "N/A"
        peer_group = pct_data.get("industry", "Global") if isinstance(pct_data, dict) else "Global"
        cluster = data.get("cluster", {})
        cluster_name = str(cluster.get("cluster_name") or "Unknown").replace(" - ", ": ")
        
        # ====================
        # PAGE 1: COVER PAGE
        # ====================
        # We want the cover page to be centered vertically, so we add spacers
        story.append(Spacer(1, 4*cm))
        
        story.append(Paragraph("AI EVOLUTION BLUEPRINT", style_cover_title))
        story.append(Paragraph("STRATEGIC MATURITY ASSESSMENT", style_cover_sub))
        
        story.append(Spacer(1, 4*cm))
        
        # Company Info Box
        cover_info = [
            [Paragraph(f"PREPARED FOR:", ParagraphStyle('C1', parent=style_score_label, alignment=TA_CENTER))],
            [Paragraph(f"<b>{company.get('name', 'Confidential Company')}</b>", ParagraphStyle('C2', parent=style_normal, fontSize=14, alignment=TA_CENTER))],
            [Spacer(1, 10)],
            [Paragraph(f"{date_str}", ParagraphStyle('C3', parent=style_normal, fontSize=11, textColor=col_subtext, alignment=TA_CENTER))]
        ]
        
        t_cover = Table(cover_info, colWidths=[10*cm])
        t_cover.setStyle(TableStyle([
            ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ]))
        story.append(t_cover)
        
        story.append(PageBreak())
        
        # ====================
        # PAGE 2: EXECUTIVE SUMMARY & SCORE
        # ====================
        
        # Score Board
        # Layout: Left side Score, Right side Cluster/Percentile
        left_score_block = [
            [Paragraph("OVERALL MATURITY", style_score_label)],
            [Paragraph(f"{overall_score}", style_score_val)],
            [Paragraph("/ 5.0", ParagraphStyle('tiny', parent=style_score_label, fontSize=10))],
        ]
        
        right_metrics_block = [
            [Paragraph("PEER BENCHMARK", style_score_label)],
            [Paragraph(f"Top <b>{percentile_rank}%</b>", style_score_sub)],
            [Paragraph(f"vs {peer_group} Peers", ParagraphStyle('tiny', parent=style_score_label, textTransform='none'))],
            [Spacer(1, 15)],
            [Paragraph("CLUSTER PROFILE", style_score_label)],
            [Paragraph(f"<b>{cluster_name}</b>", style_score_sub)],
        ]
        
        t_left = Table(left_score_block, colWidths=[6*cm])
        t_right = Table(right_metrics_block, colWidths=[6*cm])
        
        hero_table = Table([[t_left, t_right]], colWidths=[8*cm, 8*cm])
        hero_table.setStyle(TableStyle([
            ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
            ('ALIGN', (0,0), (0,0), 'CENTER'), # Left cell center
            ('ALIGN', (1,0), (1,0), 'CENTER'), # Right cell center
            ('LINEAFTER', (0,0), (0,0), 0.5, col_light_border), # Vertical divider
            ('BACKGROUND', (0,0), (-1,-1), col_bg_light),
            ('BOX', (0,0), (-1,-1), 0.5, col_light_border),
            # ('ROUNDEDCORNERS', [10,10,10,10]), # Not always supported, ignore errors
            ('TOPPADDING', (0,0), (-1,-1), 20),
            ('BOTTOMPADDING', (0,0), (-1,-1), 20),
        ]))
        story.append(hero_table)
        story.append(Spacer(1, 0.8*cm))

        # ====================
        # VALUE GROWTH CHART (New)
        # ====================
        story.append(Paragraph("Value Growth Profile", style_h2))
        
        # Cluster Definitions for Chart logic
        clusters_def = [
            {"id": 1, "name": "Traditionalist", "h": 0.2},
            {"id": 2, "name": "Explorer", "h": 0.4},
            {"id": 3, "name": "Builder", "h": 0.6},
            {"id": 4, "name": "Scaler", "h": 0.8},
            {"id": 5, "name": "Leader", "h": 1.0},
        ]
        
        # Determine active ID from cluster name
        # Determine active ID from cluster name
        active_id = 1
        c_name_raw = cluster.get("cluster_name")
        if c_name_raw:
             # Try to find leading digit
             import re
             m = re.match(r"(\d+)", str(c_name_raw))
             if m:
                 active_id = int(m.group(1))
        
        # Drawing
        chart_w = 16*cm
        chart_h = 4*cm
        bar_gap = 10
        # Convert cm to pts for Shapes
        total_w_pts = chart_w
        total_h_pts = chart_h
        
        # Calculate bar widths in PTS
        # 16cm is approx 453 pts
        avail_w = 453 - (bar_gap * 4)
        single_bar_w = avail_w / 5
        
        vg_drawing = Drawing(453, 130) # slight height adjustment
        
        x_cursor = 0
        for c_def in clusters_def:
            is_active = (c_def['id'] == active_id)
            
            # simple logic: max height 100 pts
            max_bar_h = 100
            b_height = c_def['h'] * max_bar_h 
            y_start = 20 # space for text below
            
            # Color
            if is_active:
                fill_c = colors.HexColor('#4f46e5') # Indigo
            else:
                fill_c = colors.HexColor('#f1f5f9') # Slate 100
                
            # Bar Rect
            bar = Rect(x_cursor, y_start, single_bar_w, b_height, fillColor=fill_c, strokeColor=None, rx=4, ry=4)
            vg_drawing.add(bar)
            
            # Label
            label_text = c_def['name']
            
            lbl_color = colors.HexColor('#4338ca') if is_active else colors.HexColor('#64748b')
            font_n = 'Helvetica-Bold' if is_active else 'Helvetica'
            
            # Text centered under bar
            s = String(x_cursor + single_bar_w/2, 5, label_text, textAnchor='middle', fontName=font_n, fontSize=8, fillColor=lbl_color)
            vg_drawing.add(s)
            
            x_cursor += single_bar_w + bar_gap
            
        story.append(vg_drawing)
        story.append(Spacer(1, 1*cm))

        # ====================
        # DIMENSION PROFILE SECTION (Moved Up)
        # ====================
        story.append(Paragraph("The Multi-Dimensional Maturity Profile", style_h2))
        story.append(Paragraph("Breakdown of performance across core capabilities.", ParagraphStyle('DimSub', parent=style_normal, fontSize=10, textColor=col_subtext)))
        story.append(Spacer(1, 10))
        
        dim_scores = data.get("dimension_scores", {})
        if dim_scores:
            dim_rows = []
            # Width for the bar chart part
            bar_width_pts = 200 
            
            for dim, score in dim_scores.items():
                # Create a simple bar chart drawing
                d = Drawing(bar_width_pts, 12)
                
                # Background track (light grey)
                d.add(Rect(0, 3, bar_width_pts, 6, fillColor=colors.HexColor('#f1f5f9'), strokeColor=None, rx=3, ry=3))
                
                # Value bar (colored)
                pct = max(0, min(1, score / 5.0))
                w = pct * bar_width_pts
                
                # Color logic: Low=Orange, Mid=Indigo, High=Dark Indigo
                c = colors.HexColor('#6366f1') # Default Indigo
                if score < 2.5: c = colors.HexColor('#fb923c') # Orange
                if score > 4.0: c = colors.HexColor('#4338ca') # Dark Indigo
                
                if w > 0:
                    d.add(Rect(0, 3, w, 6, fillColor=c, strokeColor=None, rx=3, ry=3))
                    
                row = [
                    Paragraph(dim, ParagraphStyle('DL', parent=style_normal, fontSize=9, textColor=col_text)),
                    d,
                    Paragraph(f"{score:.1f}/5.0", ParagraphStyle('DS', parent=style_normal, fontSize=9, textColor=col_subtext, alignment=TA_RIGHT))
                ]
                dim_rows.append(row)
            
            dim_table = Table(dim_rows, colWidths=[6*cm, 8*cm, 2*cm])
            dim_table.setStyle(TableStyle([
                ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
                ('TOPPADDING', (0,0), (-1,-1), 4),
                ('BOTTOMPADDING', (0,0), (-1,-1), 4),
            ]))
            story.append(dim_table)
        
        story.append(Spacer(1, 0.5*cm))
        
        # ====================
        # EXECUTIVE BRIEFING (Moved Down)
        # ====================
        story.append(Paragraph("Executive Summary", style_h1))
        briefing = data.get("executive_briefing", "No detailed briefing available.")
        
        # Wrapped in a nice "Quote" style box
        briefing_content = [[Paragraph(briefing, ParagraphStyle('BriefingText', parent=style_normal, fontSize=11, leading=16, textColor=colors.HexColor('#334155')))]]
        briefing_table = Table(briefing_content, colWidths=[16*cm])
        briefing_table.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#f8fafc')), # Light Slate
            ('LEFTPADDING', (0,0), (-1,-1), 15),
            ('RIGHTPADDING', (0,0), (-1,-1), 15),
            ('TOPPADDING', (0,0), (-1,-1), 15),
            ('BOTTOMPADDING', (0,0), (-1,-1), 15),
            ('LINEBEFORE', (0,0), (0,-1), 4, col_primary), # Thick left border accent
        ]))
        story.append(briefing_table)
        
        story.append(Spacer(1, 0.5*cm))
        
        # Cluster Description Detail
        story.append(Paragraph("Analysis", style_h2))
        cluster_desc = cluster.get('description', 'Your organization aligns with this pattern of AI adoption.')
        story.append(Paragraph(f"<b>{cluster_name}:</b> {cluster_desc}", style_normal))
        
        story.append(PageBreak())
        
        # ====================
        # PAGE 3: GAPS & ROADMAP
        # ====================
        
        # Strategic Gaps
        story.append(Paragraph("Strategic Gaps & Risks", style_h1))
        gaps = data.get("strategic_gaps", []) or []
        
        if gaps:
            # We use a clean list style instead of a heavy grid
            for gap in gaps:
                title = gap.get("title", "Gap")
                score = round(gap.get("score", 0), 1)
                context = gap.get("context", "")
                
                # Header Row
                gap_color = colors.HexColor('#ef4444') if score > 3 else colors.HexColor('#f97316')
                
                # Title
                story.append(Paragraph(f"<font color='{gap_color.hexval()}'>●</font> <b>{title}</b> <font size=8 color='#64748b'>(Impact Score: {score})</font>", style_normal))
                
                # Context
                story.append(Spacer(1, 2))
                story.append(Paragraph(context, ParagraphStyle('Indented', parent=style_normal, leftIndent=12, textColor=col_subtext)))
                story.append(Spacer(1, 10))
        else:
            story.append(Paragraph("No critical findings.", style_normal))
            
        story.append(Spacer(1, 1*cm))
        
        # Transformation Roadmap (Redesigned)
        story.append(Paragraph("Transformation Roadmap", style_h1))
        roadmap = data.get("roadmap", {}) or {}
        
        for i, (phase, items) in enumerate(roadmap.items()):
            # Phase "Card" Layout
            # Header
            story.append(Paragraph(phase.upper(), ParagraphStyle('PhaseHeader', parent=styles['Normal'], fontName='Helvetica-Bold', fontSize=10, textColor=col_primary, spaceAfter=8)))
            
            # Content Box
            if items:
                # Build list of items
                item_rows = []
                for item in items:
                    theme = item.get("theme", "Action")
                    explanation_raw = item.get("explanation", "")
                    
                    # --- PARSING LOGIC (Matching Roadmap.jsx) ---
                    # Format: "**Analysis**: Text... \n - **Action 1**: Text... \n - **Action 2**: Text..."
                    parts = [p.strip() for p in explanation_raw.split('\n') if p.strip()]
                    
                    analysis_text = ""
                    actions = []
                    
                    # logic to extract Analysis vs Actions
                    # 1. Find Analysis line
                    analysis_part = next((p for p in parts if 'analysis' in p.lower()), None)
                    if not analysis_part and parts: 
                         analysis_part = parts[0] # Fallback if no explicit label
                    
                    if analysis_part:
                        # Clean up "**Analysis**:" etc
                         clean_an = analysis_part.replace('**Analysis**', '').replace('Analysis:', '').replace('**', '').strip()
                         if clean_an.startswith(':'): clean_an = clean_an[1:].strip()
                         analysis_text = clean_an

                    # 2. Find Action lines
                    action_parts = [p for p in parts if 'action' in p.lower() and ('-' in p or '*' in p or '•' in p)]
                    for act in action_parts:
                        # Clean up "- **Action 1**: "
                        # Regex or simple replace
                        clean_act = act.replace('-', '').replace('*', '').replace('•', '').strip()
                        # Remove "Action N:" prefix if present
                        if ':' in clean_act and 'action' in clean_act.lower().split(':')[0]:
                            clean_act = clean_act.split(':', 1)[1].strip()
                        actions.append(clean_act)

                    # --- RENDER LOGIC ---
                    
                    # 1. Main Recommendation Title (Theme)
                    # Using a generic Bullet for the main item row
                    bullet_cell = Paragraph("•", ParagraphStyle('Bullet', parent=style_normal, textColor=col_accent, fontSize=14, alignment=TA_CENTER))
                    
                    # Content Cell stack
                    content_stack = []
                    content_stack.append(Paragraph(f"<b>{theme}</b>", style_normal))
                    content_stack.append(Spacer(1, 4))
                    
                    # Analysis Section
                    if analysis_text:
                        lbl = f"<font color='#1e293b'><b>Analysis:</b></font> <font color='#475569'>{analysis_text}</font>"
                        content_stack.append(Paragraph(lbl, ParagraphStyle('Analysis', parent=style_normal, fontSize=9, leading=12)))
                        content_stack.append(Spacer(1, 6))
                    
                    # Action List
                    if actions:
                        for idx, action_text in enumerate(actions):
                            # Action Box styling
                            # We create a mini-table for the Icon + Label + Text
                            # Label: "ACTION 1"
                            label_html = f"<font color='#0f172a' size=7><b>ACTION {idx+1}</b></font>"
                            
                            act_row = [
                                Paragraph("→", ParagraphStyle('Arrow', parent=style_normal, textColor=col_primary, fontSize=10, alignment=TA_CENTER)),
                                [
                                    Paragraph(label_html, ParagraphStyle('ActLbl', parent=style_normal, spaceAfter=2)),
                                    Paragraph(action_text, ParagraphStyle('ActTxt', parent=style_normal, fontSize=9, textColor=col_subtext))
                                ]
                            ]
                            
                            act_table = Table([act_row], colWidths=[0.6*cm, 12*cm])
                            act_table.setStyle(TableStyle([
                                ('VALIGN', (0,0), (-1,-1), 'TOP'),
                                ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#f8fafc')), # Slate 50
                                ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor('#e2e8f0')),
                                # ('ROUNDEDCORNERS', [4,4,4,4]), # Not std
                                ('TOPPADDING', (0,0), (-1,-1), 6),
                                ('BOTTOMPADDING', (0,0), (-1,-1), 6),
                                ('LEFTPADDING', (0,0), (0,0), 2), # Arrow col
                            ]))
                            content_stack.append(act_table)
                            content_stack.append(Spacer(1, 4))

                    item_rows.append([bullet_cell, content_stack])
                
                # Table for items
                items_table = Table(item_rows, colWidths=[0.8*cm, 14.2*cm])
                items_table.setStyle(TableStyle([
                    ('VALIGN', (0,0), (-1,-1), 'TOP'),
                    ('LEFTPADDING', (0,0), (-1,-1), 0),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 12),
                ]))
                
                # Wrapper Table for the whole Card
                card_table = Table([[items_table]], colWidths=[16*cm])
                card_table.setStyle(TableStyle([
                    ('BACKGROUND', (0,0), (-1,-1), colors.white),
                    ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor('#cbd5e1')), # Thin border
                    ('TOPPADDING', (0,0), (-1,-1), 10),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 10),
                    ('LEFTPADDING', (0,0), (-1,-1), 10),
                    ('RIGHTPADDING', (0,0), (-1,-1), 10),
                ]))
                card_table.hAlign = 'LEFT'
                story.append(card_table)
            
            story.append(Spacer(1, 0.5*cm))


        # --- Build PDF ---
        # Define Templates
        frame = Frame(
            doc.leftMargin, doc.bottomMargin, doc.width, doc.height,
            id='normal', showBoundary=0
        )
        
        # We attach the header/footer function to the 'StandardParams' template
        template = PageTemplate(id='StandardParams', frames=frame, onPage=self._header_footer)
        doc.addPageTemplates([template])
        
        doc.build(story)
        
        buffer.seek(0)
        return buffer.getvalue()
