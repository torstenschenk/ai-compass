import { CheckCircle2, Circle, ArrowRight } from 'lucide-react';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';

interface RoadmapItem {
    theme: string;
    source: string;
    impact: number;
    dimension: string;
    explanation: string;
}

interface RoadmapViewProps {
    roadmap: Record<string, RoadmapItem[]>;
}

export function RoadmapView({ roadmap }: RoadmapViewProps) {
    if (!roadmap) return null;

    // Convert Record to ordered list based on keys (Foundation->Implementation->Scale)
    // We assume backend returns keys containing "Phase 1", "Phase 2", "Phase 3"
    const phases = Object.keys(roadmap).sort();

    return (
        <div className="space-y-6">
            <h2 className="text-2xl font-bold text-slate-900 flex items-center gap-2">
                <span className="text-3xl">🗺️</span> Strategic AI Roadmap
            </h2>

            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                {phases.map((phaseKey, index) => {
                    const items = roadmap[phaseKey];
                    const isPhase1 = phaseKey.includes("Phase 1");
                    const isPhase2 = phaseKey.includes("Phase 2");
                    const isPhase3 = phaseKey.includes("Phase 3");

                    let colorClass = "bg-blue-600";
                    let lightColorClass = "bg-blue-50 text-blue-700 border-blue-200";
                    if (isPhase2) { colorClass = "bg-purple-600"; lightColorClass = "bg-purple-50 text-purple-700 border-purple-200"; }
                    if (isPhase3) { colorClass = "bg-indigo-600"; lightColorClass = "bg-indigo-50 text-indigo-700 border-indigo-200"; }

                    return (
                        <Card key={phaseKey} className="border-0 shadow-md flex flex-col h-full ring-1 ring-slate-100">
                            <div className={`${colorClass} h-2 w-full`}></div>
                            <CardHeader className="pb-2">
                                <Badge variant="outline" className={`w-fit mb-2 ${lightColorClass} border-0`}>
                                    {isPhase1 ? "Months 1-3" : isPhase2 ? "Months 4-9" : "Months 10+"}
                                </Badge>
                                <CardTitle className="text-lg text-slate-900">
                                    {phaseKey.split(":")[1] || phaseKey}
                                </CardTitle>
                            </CardHeader>
                            <CardContent className="flex-1 space-y-6 pt-4">
                                {items.map((item, idx) => (
                                    <div key={idx} className="relative pl-4 border-l-2 border-slate-100">
                                        <div className={`absolute -left-[5px] top-1 w-2.5 h-2.5 rounded-full ${colorClass}`}></div>
                                        <h4 className="font-bold text-slate-800 text-sm mb-1">{item.theme}</h4>
                                        <div className="text-xs text-slate-500 font-medium uppercase tracking-wider mb-2">{item.source}</div>

                                        {/* Parse explanation bullets */}
                                        <div className="text-xs text-slate-600 space-y-1">
                                            {item.explanation.split('\n').filter(line => line.trim().startsWith('-')).map((line, i) => (
                                                <div key={i} className="flex items-start gap-1">
                                                    <span className="mt-1 block min-w-[4px] min-h-[4px] rounded-full bg-slate-400"></span>
                                                    <span>{line.replace(/^-\s*\**Action \d\**:\s*/, '')}</span>
                                                </div>
                                            ))}
                                        </div>
                                    </div>
                                ))}
                                {items.length === 0 && (
                                    <div className="text-sm text-slate-400 italic">No items for this phase.</div>
                                )}
                            </CardContent>
                        </Card>
                    );
                })}
            </div>
        </div>
    );
}
