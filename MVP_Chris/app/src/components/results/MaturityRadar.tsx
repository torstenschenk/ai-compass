import { ResponsiveContainer, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, Radar, Tooltip, Legend } from 'recharts';
import { Card, CardHeader, CardTitle, CardContent } from '@/components/ui/card';

interface DimensionScore {
    dimension_name: string;
    score: number;
    industry_score?: number;
}

interface MaturityRadarProps {
    dimensions: DimensionScore[];
}

export function MaturityRadar({ dimensions }: MaturityRadarProps) {
    // Transform data for Radar Chart
    // Filter out "General Psychology" (Dimension 8) as it's not a maturity metric
    const data = dimensions
        .filter(d => d.dimension_name !== 'General Psychology')
        .map(d => ({
            subject: d.dimension_name,
            A: d.score,
            B: d.industry_score || 1, // Use Real Industry Average
            fullMark: 5,
        }));

    return (
        <Card className="shadow-lg border-0">
            <CardHeader className="bg-slate-50 border-b border-slate-100 py-3">
                <CardTitle className="flex items-center gap-2 text-xl text-slate-800">
                    <span className="text-2xl">🎯</span> Multi-Dimensional Maturity
                </CardTitle>
            </CardHeader>
            <CardContent className="p-2 pt-0 h-[350px]">
                <ResponsiveContainer width="100%" height="100%">
                    <RadarChart cx="50%" cy="42%" outerRadius="85%" data={data}>
                        <PolarGrid stroke="#e2e8f0" />
                        <PolarAngleAxis
                            dataKey="subject"
                            tick={{ fill: '#475569', fontSize: 12, fontWeight: 500 }}
                        />
                        <PolarRadiusAxis
                            angle={30}
                            domain={[0, 5]}
                            tickCount={6}
                            tick={{ fill: '#94a3b8', fontSize: 10 }}
                        />
                        <Radar
                            name="Industry Average"
                            dataKey="B"
                            stroke="#94a3b8"
                            strokeWidth={2}
                            strokeDasharray="4 4"
                            fill="#cbd5e1"
                            fillOpacity={0.1}
                        />
                        <Radar
                            name="Your Score"
                            dataKey="A"
                            stroke="#bc7210"
                            strokeWidth={3}
                            fill="#f59e0b"
                            fillOpacity={0.3}
                        />
                        <Tooltip />
                        <Legend wrapperStyle={{ paddingTop: '10px' }} />
                    </RadarChart>
                </ResponsiveContainer>
            </CardContent>
        </Card>
    );
}
