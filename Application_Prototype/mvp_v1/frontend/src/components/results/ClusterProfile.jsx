import React from 'react';
import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";

// Static definitions from spec 8.2
const CLUSTER_DEFINITIONS = [
    {
        id: 1,
        name: "The Traditionalist",
        height: "20%",
        description: "AI is not yet a topic of discussion. Operations are predominantly manual, data is siloed or analog, and there is often significant cultural skepticism."
    },
    {
        id: 2,
        name: "The Experimental Explorer",
        height: "40%",
        description: "The organization has started \"playing\" with AI through isolated tools like ChatGPT. There is curiosity but no formal strategy or oversight."
    },
    {
        id: 3,
        name: "The Structured Builder",
        height: "60%",
        description: "A solid technical and strategic foundation is being laid. High-level roadmaps and cloud infrastructure are in place, but scaling remains difficult."
    },
    {
        id: 4,
        name: "The Operational Scaler",
        height: "80%",
        description: "AI is delivering measurable ROI. Leadership is aligned, and the organization is moving multiple use cases into production."
    },
    {
        id: 5,
        name: "The AI-Driven Leader",
        height: "100%",
        description: "AI is a core strategic pillar. The workforce is highly literate, data flows are automated, and the company sets industry standards."
    }
];

export function ClusterProfile({ data }) {
    if (!data || !data.cluster) return null;

    const activeClusterId = data.cluster.cluster_id || 0;
    const activeClusterName = (data.cluster.cluster_name || "Unknown").replace(/^\d+\s*-\s*/, '');

    return (
        <section className="space-y-8">
            <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tight text-primary">Your Cluster Profile: {activeClusterName}</h2>
                <p className="text-muted-foreground text-lg">A high-level synthesis of the company's current state.</p>
            </div>

            <Card className="border-none shadow-none bg-transparent">
                <CardContent className="p-0 space-y-8">
                    {/* Bar Chart Visualization */}
                    <div className="relative h-[300px] w-full flex items-end justify-between gap-2 md:gap-4 px-4 pb-8 border-b border-border">
                        {/* Y-Axis Label */}
                        <div className="absolute left-0 top-0 bottom-8 -translate-x-full pr-4 flex items-center justify-center">
                            <span className="text-xs font-semibold text-muted-foreground -rotate-90 whitespace-nowrap">Value Growth ↑</span>
                        </div>

                        {CLUSTER_DEFINITIONS.map((cluster) => {
                            const isActive = cluster.id === activeClusterId;
                            return (
                                <div key={cluster.id} className="flex-1 flex flex-col items-center justify-end h-full gap-2 group">
                                    <div
                                        className={cn(
                                            "w-full rounded-t-lg transition-all duration-500 ease-out",
                                            isActive
                                                ? "bg-gradient-to-t from-blue-600 to-purple-600 shadow-lg shadow-blue-500/20"
                                                : "bg-slate-200 group-hover:bg-slate-300"
                                        )}
                                        style={{ height: cluster.height }}
                                    />
                                    <span className={cn(
                                        "text-xs md:text-sm font-medium text-center transition-colors",
                                        isActive ? "text-primary font-bold" : "text-muted-foreground"
                                    )}>
                                        {cluster.name}
                                    </span>
                                </div>
                            );
                        })}

                        {/* X-Axis Label */}
                        <div className="absolute bottom-0 left-0 right-0 pt-2 flex items-center justify-center">
                            <span className="text-xs font-semibold text-muted-foreground whitespace-nowrap">AI Maturity →</span>
                        </div>
                    </div>

                    {/* Description Cards */}
                    <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-5 gap-4">
                        {CLUSTER_DEFINITIONS.map((cluster) => {
                            const isActive = cluster.id === activeClusterId;
                            return (
                                <div
                                    key={cluster.id}
                                    className={cn(
                                        "p-4 rounded-xl border transition-all duration-300",
                                        isActive
                                            ? "border-blue-500 bg-blue-50 ring-1 ring-blue-500 shadow-md transform scale-105"
                                            : "border-border bg-card hover:border-slate-300"
                                    )}
                                >
                                    <h4 className={cn(
                                        "font-semibold mb-2 text-sm",
                                        isActive ? "text-blue-700" : "text-foreground"
                                    )}>
                                        {cluster.name}
                                    </h4>
                                    <p className="text-xs text-muted-foreground leading-relaxed">
                                        {cluster.description}
                                    </p>
                                </div>
                            );
                        })}
                    </div>
                </CardContent>
            </Card>
        </section>
    );
}
