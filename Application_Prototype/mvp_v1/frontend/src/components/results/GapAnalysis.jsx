import React from 'react';
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { AlertTriangle, AlertOctagon, TrendingDown, ArrowRight, Zap, Target } from 'lucide-react';
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";

export function GapAnalysis({ data }) {
    if (!data || !data.strategic_gaps) return null;

    const gaps = data.strategic_gaps;

    // Helper to determine gap visuals
    const getGapVisuals = (gap) => {
        const type = (gap.type || "").toLowerCase();

        if (type.includes('anomaly') || type.includes('structural')) {
            return {
                icon: AlertOctagon,
                colorClass: "text-amber-600",
                bgClass: "bg-amber-50 border-amber-200",
                gradient: "from-amber-500/10 to-transparent",
                label: "Structural Imbalance"
            };
        } else {
            return {
                icon: TrendingDown,
                colorClass: "text-red-600",
                bgClass: "bg-red-50 border-red-200",
                gradient: "from-red-500/10 to-transparent",
                label: "Critical Weakness"
            };
        }
    };

    return (
        <section className="space-y-8">
            <div className="flex flex-col md:flex-row md:items-end justify-between gap-4">
                <div className="space-y-2">
                    <h2 className="text-3xl font-bold tracking-tight text-primary">Strategic Gap Analysis</h2>
                    <p className="text-muted-foreground text-lg">Detailed breakdown of high-priority risks affecting your scalability.</p>
                </div>
            </div>

            <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                {gaps.map((gap, idx) => {
                    const visuals = getGapVisuals(gap);
                    const Icon = visuals.icon;

                    return (
                        <Card key={idx} className="relative overflow-hidden border-slate-200 shadow-sm hover:shadow-md transition-all duration-300 group">
                            {/* Decorative Background Gradient */}
                            <div className={cn("absolute top-0 right-0 w-64 h-64 bg-gradient-to-br blur-3xl opacity-50 rounded-full -mr-16 -mt-16 pointer-events-none", visuals.gradient)} />

                            <CardHeader className="pb-4 relative">
                                <div className="flex items-start justify-between gap-4">
                                    <div className="flex items-start gap-3">
                                        <div className={cn("p-2.5 rounded-xl border shrink-0 mt-1", visuals.bgClass)}>
                                            <Icon className={cn("w-6 h-6", visuals.colorClass)} />
                                        </div>
                                        <div>
                                            <Badge variant="outline" className={cn("mb-2 font-semibold tracking-wide border-0 px-0", visuals.colorClass)}>
                                                {visuals.label}
                                            </Badge>
                                            <CardTitle className="text-xl font-bold text-slate-900 leading-snug">
                                                {gap.title.replace(/^(Critical Gap|Structural Imbalance):\s*/i, '')}
                                            </CardTitle>
                                        </div>
                                    </div>

                                    {/* Score Indicator */}
                                    <div className="flex flex-col items-end shrink-0">
                                        <div className="text-2xl font-bold text-slate-700">
                                            {gap.score ? gap.score.toFixed(1) : "N/A"}
                                        </div>
                                        <span className="text-[10px] items-center text-muted-foreground uppercase tracking-wider font-semibold">
                                            Impact Score
                                        </span>
                                    </div>
                                </div>
                            </CardHeader>

                            <CardContent className="space-y-6 relative">
                                {/* Context / Finding */}
                                <div className="text-slate-600 leading-relaxed text-base">
                                    {gap.context}
                                </div>

                                {/* Strategic Risk Warning Box */}
                                {gap.strategic_risk && (
                                    <div className="bg-slate-50 rounded-lg p-4 border border-slate-100 relative group-hover:border-slate-200 transition-colors">
                                        <div className="flex items-center gap-2 mb-2 text-slate-800">
                                            <Zap className="w-4 h-4 text-amber-500 fill-amber-500" />
                                            <h4 className="text-sm font-bold uppercase tracking-wide">Strategic Implication</h4>
                                        </div>
                                        <p className="text-sm text-slate-600 leading-relaxed italic">
                                            "{gap.strategic_risk}"
                                        </p>
                                    </div>
                                )}

                                {/* Bottom Meta Data */}
                                <div className="flex items-center gap-2 pt-2 text-xs font-medium text-slate-400">
                                    <Target className="w-3.5 h-3.5" />
                                    <span>Affects: {gap.dimension_name || gap.source_dim || "General Capability"}</span>
                                </div>
                            </CardContent>
                        </Card>
                    );
                })}

                {gaps.length === 0 && (
                    <div className="col-span-full py-12 text-center border-2 border-dashed border-slate-100 rounded-xl bg-slate-50/50">
                        <div className="p-4 bg-white rounded-full w-fit mx-auto shadow-sm mb-4">
                            <AlertTriangle className="w-8 h-8 text-slate-300" />
                        </div>
                        <h3 className="text-lg font-semibold text-slate-600">No Critical Gaps Detected</h3>
                        <p className="text-slate-400 max-w-sm mx-auto mt-1">Your detailed analysis shows a balanced maturity profile with no immediate red flags.</p>
                    </div>
                )}
            </div>
        </section>
    );
}
