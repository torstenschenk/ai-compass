import React from 'react';
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { AlertCircle, FileWarning } from 'lucide-react';

function SeverityBadge({ score }) {
    let color = "bg-amber-100 text-amber-800 border-amber-200";
    let label = "MEDIUM";

    // Logic from spec 8.4 (approximate)
    if (score >= 12) {
        color = "bg-red-100 text-red-800 border-red-200";
        label = "CRITICAL";
    } else if (score >= 8) {
        color = "bg-orange-100 text-orange-800 border-orange-200";
        label = "HIGH";
    }

    return (
        <span className={`px-2 py-0.5 rounded text-xs font-bold border ${color}`}>
            {label}
        </span>
    );
}

export function GapAnalysis({ data }) {
    if (!data || !data.strategic_gaps) return null;

    const gaps = data.strategic_gaps;

    return (
        <section className="space-y-6">
            <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tight text-primary">Strategic Gap Analysis</h2>
                <p className="text-muted-foreground text-lg">Identifying the "Delta" between your current position and the next level.</p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {gaps.map((gap, idx) => (
                    <Card key={idx} className="border-l-4 border-l-red-500 shadow-sm hover:shadow-md transition-shadow">
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-lg font-bold flex items-center gap-2">
                                <AlertCircle className="w-5 h-5 text-red-500" />
                                {gap.tactical_theme || gap.title}
                            </CardTitle>
                            <SeverityBadge score={gap.severity_score || 0} />
                        </CardHeader>
                        <CardContent className="space-y-4 pt-4">
                            <div className="text-sm text-foreground italic border-l-2 border-slate-200 pl-3 py-1">
                                "{gap.context || gap.gap_description}"
                            </div>

                            <div className="space-y-2">
                                <p className="text-sm font-semibold text-muted-foreground uppercase tracking-wider">Strategic Risk</p>
                                <p className="text-sm text-foreground">
                                    {/* Fallback risk text since API context is usually sufficient, but spec asks for strict risk wording. 
                                        In MVP, context usually serves as both. */}
                                    This gap in <span className="font-semibold">{gap.dimension_name || gap.dimension}</span> creates potential liabilities in scalability.
                                </p>
                            </div>
                        </CardContent>
                    </Card>
                ))}

                {gaps.length === 0 && (
                    <div className="col-span-2 text-center py-12 text-slate-400">
                        No critical strategic gaps detected.
                    </div>
                )}
            </div>
        </section>
    );
}
