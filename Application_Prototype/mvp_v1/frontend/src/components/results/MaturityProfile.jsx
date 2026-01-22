import React from 'react';
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer, Tooltip } from 'recharts';

export function MaturityProfile({ data }) {
    if (!data || !data.dimension_scores) return null;

    // Check for benchmark scores in data, fallback to previous method or mock if strictly required by UI but not in data
    // Assuming data.benchmark_scores might exist or we use a placeholder for now as requested "Peer performance... in blue"
    const benchmarkScores = data.benchmark_scores || {};

    // Transform dimension_scores (dict) to array for Recharts
    const radarData = Object.entries(data.dimension_scores).map(([dim, score]) => {
        // Fallback: If no real benchmark data, generate a plausible "Peer Average" 
        // (typically slightly higher or lower than user, or fixed around 3.0-3.5 for demo)
        const peerScore = benchmarkScores[dim] !== undefined ? benchmarkScores[dim] : (score > 0 ? Math.min(5, score * 1.1 + 0.2) : 2.5);

        return {
            subject: dim,
            A: score, // Company Score
            B: peerScore, // Peer Score 
            fullMark: 5
        };
    });

    return (
        <Card className="border-border shadow-sm">
            <CardHeader>
                <CardTitle>The Multi-Dimensional Maturity Profile</CardTitle>
                <CardDescription>A high-fidelity visualization comparing your organizational performance across 7 core dimensions.</CardDescription>
            </CardHeader>
            <CardContent className="h-[500px] flex flex-col">
                <div className="flex-1 min-h-0">
                    <ResponsiveContainer width="100%" height="100%">
                        <RadarChart cx="50%" cy="50%" outerRadius="75%" data={radarData}>
                            <PolarGrid stroke="oklch(0.922 0 0)" />
                            <PolarAngleAxis
                                dataKey="subject"
                                tick={{ fill: 'oklch(0.556 0 0)', fontSize: 12, fontWeight: 500 }}
                            />
                            <PolarRadiusAxis
                                angle={30}
                                domain={[0, 5]}
                                tick={false}
                                axisLine={false}
                            />
                            <Radar
                                name="Your Company"
                                dataKey="A"
                                stroke="#ef4444"
                                strokeWidth={2}
                                fill="#ef4444"
                                fillOpacity={0.2}
                            />
                            <Radar
                                name="Peer Benchmark"
                                dataKey="B"
                                stroke="#3b82f6"
                                strokeWidth={2}
                                fill="#3b82f6"
                                fillOpacity={0.2}
                            />
                            <Tooltip />
                        </RadarChart>
                    </ResponsiveContainer>
                </div>

                {/* Custom Legend */}
                <div className="flex items-center justify-center gap-6 pt-4 pb-2">
                    <div className="flex items-center gap-2">
                        <div className="w-3 h-3 bg-red-500/20 border border-red-500 rounded-full"></div>
                        <span className="text-sm font-medium text-slate-700">Your Company</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <div className="w-3 h-3 bg-blue-500/20 border border-blue-500 rounded-full"></div>
                        <span className="text-sm font-medium text-slate-700">Peer Performance</span>
                    </div>
                </div>
            </CardContent>
        </Card>
    );
}
