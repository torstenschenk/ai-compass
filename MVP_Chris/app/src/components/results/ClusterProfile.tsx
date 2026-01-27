import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';

interface ClusterProfileProps {
    currentClusterId: number;
    description: string; // Kept for interface compatibility but descriptions are now internal
}

const CLUSTERS = [
    {
        id: 1,
        name: "The Traditionalist",
        height: "20%",
        desc: "AI is not yet a topic of discussion. Operations are predominantly manual, data is siloed or analog, and there is often significant cultural skepticism."
    },
    {
        id: 2,
        name: "The Curious Experimenter",
        height: "40%",
        desc: "The organization has started \"playing\" with AI through isolated tools like ChatGPT. There is curiosity but no formal strategy or oversight."
    },
    {
        id: 3,
        name: "The Structured Builder",
        height: "60%",
        desc: "A solid technical and strategic foundation is being laid. High-level roadmaps and cloud infrastructure are in place, but scaling remains difficult."
    },
    {
        id: 4,
        name: "The Value Scaler",
        height: "80%",
        desc: "AI is delivering measurable ROI. Leadership is aligned, and the organization is moving multiple use cases into production."
    },
    {
        id: 5,
        name: "The AI-Enabled Leader",
        height: "100%",
        desc: "AI is a core strategic pillar. The workforce is highly literate, data flows are automated, and the company sets industry standards."
    },
];

export function ClusterProfile({ currentClusterId }: ClusterProfileProps) {
    return (
        <Card className="shadow-lg border-0 overflow-hidden">
            <CardHeader className="bg-slate-50 border-b border-slate-100">
                <CardTitle className="flex items-center gap-2 text-xl text-slate-800">
                    <span className="text-2xl">🧩</span> Cluster Profile Analysis
                </CardTitle>
            </CardHeader>
            <CardContent className="p-8">
                {/* Main Graph Container */}
                <div className="relative pl-24 pb-12 w-full">



                    {/* Bars Container */}
                    <div className="flex items-end gap-2 md:gap-6 h-80 w-full border-l border-b border-slate-300 relative">
                        {/* Y-Axis Label - Centered relative to Chart Height, moved further left */}
                        <div className="absolute -left-24 top-1/2 transform -translate-y-1/2 -rotate-90 origin-center whitespace-nowrap text-sm font-bold text-slate-500 tracking-wider flex items-center gap-2">
                            Value Growth <span>→</span>
                        </div>

                        {/* Grid lines (optional visual aid) */}
                        <div className="absolute inset-0 z-0 flex flex-col justify-between pointer-events-none opacity-20">
                            <div className="border-t border-slate-400 w-full h-full"></div>
                            <div className="border-t border-slate-400 w-full h-1/4"></div>
                            <div className="border-t border-slate-400 w-full h-1/4"></div>
                            <div className="border-t border-slate-400 w-full h-1/4"></div>
                        </div>

                        {CLUSTERS.map((cluster) => {
                            const isActive = cluster.id === currentClusterId;
                            return (
                                <div key={cluster.id} className="flex-1 flex flex-col items-center justify-end h-full z-10 relative group">
                                    {/* Tooltip-ish popover logic could go here, but text is below */}

                                    {/* The Bar */}
                                    <div
                                        style={{ height: cluster.height }}
                                        className={`w-full max-w-[180px] rounded-t-xl transition-all duration-700 ease-out shadow-sm
                                            ${isActive
                                                ? 'bg-gradient-to-t from-blue-600 to-purple-600 shadow-blue-200'
                                                : 'bg-slate-200 hover:bg-slate-300'
                                            }`}
                                    ></div>
                                </div>
                            );
                        })}
                    </div>

                    {/* X-Axis Title */}
                    <div className="w-full text-center py-2">
                        <span className="text-sm font-bold text-slate-500 tracking-wider">
                            AI Maturity →
                        </span>
                    </div>

                    {/* Descriptions Container */}
                    <div className="flex gap-2 md:gap-6 w-full items-start">
                        {CLUSTERS.map((cluster) => {
                            const isActive = cluster.id === currentClusterId;
                            return (
                                <div key={cluster.id} className="flex-1 text-center flex flex-col items-center justify-start">
                                    {/* X-axis Label (Name) */}
                                    <div className={`text-xs font-bold uppercase tracking-wider mb-1 min-h-[3rem] flex items-end justify-center ${isActive ? 'text-blue-700' : 'text-slate-500'}`}>
                                        {cluster.name}
                                    </div>

                                    {/* Description Text */}
                                    <div className={`text-[10px] md:text-xs leading-relaxed text-balance p-2 rounded-lg 
                                        ${isActive ? 'bg-blue-50 text-slate-800 border border-blue-100 font-medium' : 'text-slate-400'}`}>
                                        {cluster.desc}
                                    </div>
                                </div>
                            );
                        })}
                    </div>

                    {/* X-Axis Title */}


                </div>
            </CardContent>
        </Card>
    );
}
