Multi-Dimensional Radar Chart
1. Content & Wording (Optimized Copy)
Main Header: "The Multi-Dimensional Maturity Profile"
Sub-headline: "A high-fidelity visualization comparing your organizational performance across 7 core dimensions against the industry average."
The 7 Dimensions: Strategy, People, Data, Use Cases, Processes, Compliance, Tech.
Legend: * Your Company: Represented by the Red Area/Line.
Peer Benchmark: Represented by the Blue Area/Line (Average of 500+ companies).

2. Design & UI Specifications (Nano Banana Style)
Chart Type: Radar (Spider) Chart.
Color Palette:
User Data: Soft Red stroke with a semi-transparent red fill (rgba(239, 68, 68, 0.2)).
Benchmark Data: Soft Blue stroke with a semi-transparent blue fill (rgba(59, 130, 246, 0.2)).
Grid Style: Circular or polygonal concentric rings (scales 1 to 5) in light gray.
Typography: Labels positioned outside the chart perimeter in a clean, professional Sans-Serif font (Charcoal/Slate).
Container: A clean white card with rounded corners (24px) and a very subtle shadow.

3. Technical Requirements (MVP Implementation)
Library Choice: Use Recharts (standard for React) or Chart.js via react-chartjs-2.
Data Structure: An array of objects where each object contains the dimension, userScore, and benchmarkScore.
Responsiveness: The chart must scale its radius based on the screen width to avoid label clipping on mobile.
Tooltips: On hover, show exact numerical values for both "Your Company" and "Peer Benchmark".
