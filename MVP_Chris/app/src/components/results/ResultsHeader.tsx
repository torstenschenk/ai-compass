import { TrendingUp, Users, Medal } from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';

interface ResultsHeaderProps {
    companyName: string;
    totalScore: number;
    clusterName: string;
    industry: string;
}

export function ResultsHeader({ companyName, totalScore, clusterName, industry }: ResultsHeaderProps) {
    // Convert 0-100 score to 1-5 scale
    const scoreOn5Scale = ((totalScore / 100) * 4) + 1;
    const formattedScore = scoreOn5Scale.toFixed(1);

    // Dummy logic for percentile based on score (simulated backend logic)
    const percentile = Math.min(99, Math.floor(40 + (scoreOn5Scale / 5) * 50));

    return (
        <section className="space-y-8">
            <div className="text-center max-w-3xl mx-auto space-y-4">
                <h1 className="text-4xl font-extrabold tracking-tight text-slate-900 sm:text-5xl">
                    AI Compass: Executive Results Report
                </h1>
                <div className="h-1 w-20 bg-blue-600 mx-auto rounded-full"></div>
                <p className="text-xl text-slate-600 leading-relaxed">
                    Results for <span className="font-semibold text-blue-900">{companyName}</span>.
                    Welcome to your AI Evolution Blueprint—a data-driven synthesis of your organizational
                    maturity and the strategic path forward.
                </p>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 pt-6">
                {/* Score Card */}
                <Card className="border-0 shadow-lg bg-white overflow-hidden relative group">
                    <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <Medal className="w-24 h-24 text-blue-600" />
                    </div>
                    <CardContent className="p-6">
                        <div className="flex items-center gap-4 mb-2">
                            <div className="p-3 bg-blue-100 rounded-xl text-blue-600">
                                <Medal className="w-6 h-6" />
                            </div>
                            <span className="text-sm font-semibold text-slate-500 uppercase tracking-wider">Total Overall Score</span>
                        </div>
                        <div className="mt-2 flex items-baseline gap-2">
                            <span className="text-5xl font-bold text-slate-900">{formattedScore}</span>
                            <span className="text-2xl text-slate-400 font-light">/5.0</span>
                        </div>
                    </CardContent>
                </Card>

                {/* Cluster Card */}
                <Card className="border-0 shadow-lg bg-white overflow-hidden relative group">
                    <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <Users className="w-24 h-24 text-purple-600" />
                    </div>
                    <CardContent className="p-6">
                        <div className="flex items-center gap-4 mb-2">
                            <div className="p-3 bg-purple-100 rounded-xl text-purple-600">
                                <Users className="w-6 h-6" />
                            </div>
                            <span className="text-sm font-semibold text-slate-500 uppercase tracking-wider">Company Cluster</span>
                        </div>
                        <div className="mt-2">
                            <span className="text-2xl font-bold text-slate-900 leading-tight block">{clusterName}</span>
                        </div>
                    </CardContent>
                </Card>

                {/* Benchmark Card */}
                <Card className="border-0 shadow-lg bg-white overflow-hidden relative group">
                    <div className="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <TrendingUp className="w-24 h-24 text-indigo-600" />
                    </div>
                    <CardContent className="p-6">
                        <div className="flex items-center gap-4 mb-2">
                            <div className="p-3 bg-indigo-100 rounded-xl text-indigo-600">
                                <TrendingUp className="w-6 h-6" />
                            </div>
                            <span className="text-sm font-semibold text-slate-500 uppercase tracking-wider">Benchmark</span>
                        </div>
                        <div className="mt-2">
                            <div className="text-2xl font-bold text-slate-900">Top {percentile}%</div>
                            <div className="text-sm text-slate-500 font-medium mt-1">in {industry || 'General Industry'}</div>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </section>
    );
}
