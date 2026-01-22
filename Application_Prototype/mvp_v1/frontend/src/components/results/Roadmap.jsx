import React from 'react';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { ArrowRight, Star, TrendingUp, AlertCircle, CheckCircle2 } from 'lucide-react';
import { cn } from "@/lib/utils";
import { Badge } from "@/components/ui/badge";

// Phase Definitions from ML v5 Spec
const PHASES = [
    {
        key: "phase_1",
        step: "01",
        title: "Foundation",
        timeframe: "0-3 Months",
        color: "bg-blue-50/50 border-blue-100",
        headerColor: "text-blue-700 bg-blue-100/50",
        accent: "blue"
    },
    {
        key: "phase_2",
        step: "02",
        title: "Implementation",
        timeframe: "3-9 Months",
        color: "bg-indigo-50/50 border-indigo-100",
        headerColor: "text-indigo-700 bg-indigo-100/50",
        accent: "indigo"
    },
    {
        key: "phase_3",
        step: "03",
        title: "Scale & Governance",
        timeframe: "9+ Months",
        color: "bg-purple-50/50 border-purple-100",
        headerColor: "text-purple-700 bg-purple-100/50",
        accent: "purple"
    }
];

// Helper to determine badge type
const getRecommendationType = (rec) => {
    const source = (rec.source || "").toLowerCase();
    const impact = rec.impact_score || 0;

    if (source.includes("strategic gap") && impact > 10) {
        return { label: "Must-Win Battle", variant: "destructive", icon: AlertCircle };
    } else if (source.includes("growth") || source.includes("peer")) {
        return { label: "Peer Opportunity", variant: "secondary", icon: TrendingUp }; // Using secondary blue-ish style
    }
    return { label: "Tactical Step", variant: "outline", icon: Star };
};

export function Roadmap({ data }) {
    if (!data || (!data.roadmap && !data.phases)) return null;

    // Normalize data structure
    // Support both { roadmap: { phases: {...} } } and { roadmap: { phase_1: ... } }
    let phasesData = {};
    const sourceRoot = data.roadmap?.phases ? data.roadmap.phases : data.roadmap;

    if (sourceRoot) {
        // Handle case where keys might match loose strings
        phasesData = sourceRoot;
    }

    return (
        <section className="space-y-8">
            <div className="space-y-2">
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <div>
                        <h2 className="text-3xl font-bold tracking-tight text-primary">AI Compass: "Next Best Action" Roadmap</h2>
                        <p className="text-muted-foreground text-lg">Your personalized 3-phase transformation pathway.</p>
                    </div>
                </div>
            </div>

            {/* Vertical Timeline Layout */}
            <div className="relative pl-8 md:pl-12 space-y-12">
                {/* Continuous Vertical Line */}
                <div className="absolute left-[15px] md:left-[23px] top-4 bottom-4 w-0.5 bg-gradient-to-b from-blue-200 via-indigo-200 to-purple-200" />

                {PHASES.map((phaseDef, idx) => {
                    // Fuzzy match key
                    let phaseContent = phasesData[phaseDef.key];
                    if (!phaseContent) {
                        const matchingKey = Object.keys(phasesData).find(k => k.toLowerCase().includes(phaseDef.key.replace('_', ' ')));
                        if (matchingKey) phaseContent = phasesData[matchingKey];
                    }

                    const recommendations = phaseContent?.recommendations || (Array.isArray(phaseContent) ? phaseContent : []);

                    return (
                        <div key={phaseDef.key} className="relative">
                            {/* Step Indicator Dot on Line */}
                            <div className={cn(
                                "absolute -left-[32px] md:-left-[40px] top-0 w-8 h-8 rounded-full border-4 border-white shadow-sm flex items-center justify-center text-[10px] font-bold z-10",
                                phaseDef.headerColor.replace('text-', 'bg-').replace('bg-', 'text-').split(' ')[0], // Invert colors for the dot
                                `bg-${phaseDef.accent}-100 text-${phaseDef.accent}-700`
                            )}>
                                {phaseDef.step}
                            </div>

                            <div className="flex flex-col gap-6">
                                {/* Phase Header Card */}
                                <div className={cn("rounded-2xl border p-5 backdrop-blur-sm bg-white shadow-sm relative overflow-hidden", phaseDef.color)}>
                                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-2">
                                        <h3 className={cn("text-2xl font-bold capitalize", `text-${phaseDef.accent}-900`)}>
                                            {phaseDef.title}
                                        </h3>
                                        <span className="text-xs font-semibold text-slate-500 bg-white/60 px-3 py-1 rounded-full border border-slate-200/50 w-fit">
                                            {phaseDef.timeframe}
                                        </span>
                                    </div>
                                    <p className="text-sm text-slate-600 max-w-2xl">
                                        Focus on {phaseDef.title.toLowerCase()} activities to build momentum.
                                    </p>
                                </div>

                                {/* Recommendations List - Grid for cards within the phase */}
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    {recommendations.length > 0 ? (
                                        recommendations.map((rec, rIdx) => {
                                            const type = getRecommendationType(rec);
                                            const Icon = type.icon;

                                            return (
                                                <Card key={rIdx} className="border-slate-200 shadow-sm hover:shadow-md transition-all duration-200 group h-full">
                                                    <CardHeader className="pb-3 p-5">
                                                        <div className="flex justify-between items-start gap-2 mb-3">
                                                            <Badge variant={type.variant} className={cn("text-[10px] px-2 py-0.5 h-5",
                                                                type.label === 'Must-Win Battle' ? "bg-red-100 text-red-700 hover:bg-red-200 border-red-200" :
                                                                    type.label === 'Peer Opportunity' ? "bg-blue-100 text-blue-700 hover:bg-blue-200 border-blue-200" : ""
                                                            )}>
                                                                <div className="flex items-center gap-1.5">
                                                                    <Icon className="w-3 h-3" />
                                                                    {type.label}
                                                                </div>
                                                            </Badge>
                                                            {rec.impact_score && (
                                                                <span className="text-[10px] font-mono font-medium text-slate-400 bg-slate-50 px-1.5 py-0.5 rounded">
                                                                    Score: {rec.impact_score}
                                                                </span>
                                                            )}
                                                        </div>
                                                        <CardTitle className="text-base font-bold text-slate-800 leading-tight">
                                                            {rec.theme || "Action Item"}
                                                        </CardTitle>
                                                        {rec.dimension && (
                                                            <CardDescription className="text-xs text-slate-500 mt-1 line-clamp-1">
                                                                {rec.dimension}
                                                            </CardDescription>
                                                        )}
                                                    </CardHeader>
                                                    <CardContent className="p-5 pt-0">
                                                        <div className="text-sm text-slate-600 leading-relaxed text-pretty">
                                                            {/* Simple visual formatter for "Analysis: ... - Action:" structure if present */}
                                                            {rec.explanation.split('**').length > 1 ? (
                                                                <div dangerouslySetInnerHTML={{
                                                                    __html: rec.explanation
                                                                        .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
                                                                        .replace(/- \*\*Action/g, '<br/><strong>Action') // Remove dash before Action
                                                                        .replace(/\n/g, '<br/>')
                                                                }} />
                                                            ) : (
                                                                rec.explanation
                                                            )}
                                                        </div>
                                                    </CardContent>
                                                </Card>
                                            );
                                        })
                                    ) : (
                                        <div className="col-span-full">
                                            <div className="text-center p-6 border-2 border-dashed border-slate-200 rounded-xl bg-slate-50/50">
                                                <div className="text-slate-400 text-sm italic">
                                                    No critical actions for this phase.
                                                </div>
                                            </div>
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    );
                })}
            </div>

            <div className="mt-8 p-4 bg-slate-50 rounded-xl border border-slate-100 flex items-start gap-3">
                <div className="p-2 bg-white rounded-lg shadow-sm">
                    <CheckCircle2 className="w-5 h-5 text-emerald-500" />
                </div>
                <div>
                    <h4 className="text-sm font-semibold text-slate-800">Why this roadmap?</h4>
                    <p className="text-sm text-slate-600 mt-1">This plan is dynamically generated by comparing your profile against <strong>peer benchmarks</strong>. Phase 1 focuses on closing critical gaps that prevent scaling, while Phases 2 & 3 target differentiation and leadership.</p>
                </div>
            </div>
        </section>
    );
}
