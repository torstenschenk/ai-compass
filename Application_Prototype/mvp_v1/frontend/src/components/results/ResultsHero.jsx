import React from 'react';
import { Card, CardContent } from "@/components/ui/card";
import { Medal, Users, TrendingUp } from 'lucide-react';

export function ResultsHero({ data }) {
    if (!data) return null;

    const { overall_score, cluster, company } = data;
    const clusterName = (cluster?.cluster_name || "Unknown").replace(/^\d+\s*-\s*/, '');
    // Placeholder for percentile logic if not in data
    const percentile = data.percentile || "N/A";
    const industry = company?.industry || "Industry";

    // Format score: 1 decimal place, but if integer (e.g. 5.0), show as 5
    const formattedScore = Number(overall_score) % 1 === 0 ? Number(overall_score).toFixed(0) : Number(overall_score).toFixed(1);

    return (
        <div className="section-container space-y-8">
            {/* Header Text */}
            <div className="text-center max-w-4xl mx-auto space-y-4">
                <h1 className="text-4xl md:text-5xl font-bold tracking-tight text-primary">
                    AI Compass: Executive Results Report
                </h1>
                <p className="text-xl text-muted-foreground leading-relaxed">
                    Welcome to your AI Evolution Blueprint—a data-driven synthesis of your organizational maturity, competitive standing, and the strategic path forward to scaling measurable AI value.
                </p>
            </div>

            {/* KPI Cards */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {/* Score Card */}
                <Card className="border-border shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6 flex items-start gap-4">
                        <div className="p-3 rounded-xl bg-blue-100 text-blue-600">
                            <Medal className="w-8 h-8" />
                        </div>
                        <div>
                            <p className="text-sm font-medium text-muted-foreground uppercase tracking-wider">Total Overall Score</p>
                            <h3 className="text-3xl font-bold mt-1 text-foreground">{formattedScore}<span className="text-lg text-muted-foreground font-normal">/5</span></h3>
                        </div>
                    </CardContent>
                </Card>

                {/* Cluster Card */}
                <Card className="border-border shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6 flex items-start gap-4">
                        <div className="p-3 rounded-xl bg-purple-100 text-purple-600">
                            <Users className="w-8 h-8" />
                        </div>
                        <div>
                            <p className="text-sm font-medium text-muted-foreground uppercase tracking-wider">Company Cluster</p>
                            <h3 className="text-2xl font-bold mt-1 text-foreground leading-tight">{clusterName}</h3>
                        </div>
                    </CardContent>
                </Card>

                {/* Benchmark Card */}
                <Card className="border-border shadow-sm hover:shadow-md transition-shadow">
                    <CardContent className="p-6 flex items-start gap-4">
                        <div className="p-3 rounded-xl bg-indigo-100 text-indigo-600">
                            <TrendingUp className="w-8 h-8" />
                        </div>
                        <div>
                            <p className="text-sm font-medium text-muted-foreground uppercase tracking-wider">Percentile</p>
                            <h3 className="text-2xl font-bold mt-1 text-foreground">
                                {percentile !== "N/A" ? `Top ${percentile.percentage}%` : "Not Available"}
                            </h3>
                            <p className="text-sm text-muted-foreground mt-1">in {industry}</p>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
}
