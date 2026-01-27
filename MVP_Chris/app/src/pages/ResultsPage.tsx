import { useState, useEffect } from 'react';
import { useSearchParams } from 'react-router-dom';
import { Loader2, Download, Share2 } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Footer } from '@/components/layout/Footer';

// New Components
import { ResultsHeader } from '@/components/results/ResultsHeader';
import { ClusterProfile as ClusterProfileComponent } from '@/components/results/ClusterProfile'; // Rename to avoid clash with interface
import { MaturityRadar } from '@/components/results/MaturityRadar';
import { StrategicGapAnalysis } from '@/components/results/StrategicGapAnalysis';
import { RoadmapView } from '@/components/results/RoadmapView';
import { ExpertConsultation } from '@/components/results/ExpertConsultation';
import { DownloadReport } from '@/components/results/DownloadReport';
import { compassLogo } from '@/assets/compassLogo';

// Types
interface DimensionScore {
    dimension_id: number;
    dimension_name: string; // Fixed type
    score: number;
    max_score: number;
    industry_score?: number;
}

interface ClusterProfile {
    cluster_id: number;
    name: string;
    description: string;
}

interface RoadmapItem {
    theme: string;
    source: string;
    impact: number;
    dimension: string;
    explanation: string;
}

interface StrategicFinding {
    type: string;
    title: string;
    score: number;
    context: string;
    dimension_name?: string;
    tactical_theme?: string;
}

interface StrategicGapAnalysisData {
    executive_briefing: string;
    detailed_findings: StrategicFinding[];
}

interface ResponseResult {
    id: number;
    company_name: string;
    overall_score: number;
    dimension_scores: DimensionScore[];
    cluster?: ClusterProfile;
    roadmap?: Record<string, RoadmapItem[]>;
    strategic_gap_analysis?: StrategicGapAnalysisData;
    industry?: string;
}

export function ResultsPage() {
    const [searchParams] = useSearchParams();
    const responseId = searchParams.get('responseId');
    const [results, setResults] = useState<ResponseResult | null>(null);
    const [loading, setLoading] = useState(true);
    const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';

    useEffect(() => {
        if (!responseId) return;

        const fetchResults = async () => {
            try {
                const res = await fetch(`${apiUrl}/api/v1/responses/${responseId}`);
                if (!res.ok) throw new Error('Failed to load results');
                const data = await res.json();
                setResults(data);
            } catch (error) {
                console.error(error);
            } finally {
                setLoading(false);
            }
        };
        fetchResults();
    }, [responseId]);

    if (loading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-50">
                <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
            </div>
        );
    }

    if (!results) {
        return <div>No results found.</div>;
    }

    return (
        <div className="min-h-screen bg-slate-50 font-sans text-slate-900 pb-20">
            {/* Sticky Header Actions for PDF/Share */}
            <header className="bg-white/80 backdrop-blur-md border-b border-slate-200 sticky top-0 z-50">
                <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="h-8 w-8 flex items-center justify-center">
                            <img src={compassLogo} alt="AI Compass" className="h-full w-full object-contain" />
                        </div>
                        <span className="font-bold text-slate-900 text-lg tracking-tight">AI Compass</span>
                        <span className="text-slate-300 mx-2">/</span>
                        <span className="text-slate-500 text-sm font-medium">Results for {results.company_name}</span>
                    </div>
                    <div className="flex gap-3">
                        <Button variant="ghost" size="sm" className="text-slate-600">
                            <Share2 className="w-4 h-4 mr-2" />
                            Share
                        </Button>
                        <Button
                            size="sm"
                            onClick={() => window.open(`${apiUrl}/api/v1/responses/${results.id}/report`, '_blank')}
                            className="bg-blue-600 hover:bg-blue-700 text-white shadow-sm"
                        >
                            <Download className="w-4 h-4 mr-2" />
                            Download PDF
                        </Button>
                    </div>
                </div>
            </header>

            <main className="max-w-7xl mx-auto px-6 py-12 space-y-16">

                {/* 1. Header & KPI Cards */}
                <ResultsHeader
                    companyName={results.company_name}
                    totalScore={results.overall_score}
                    clusterName={results.cluster?.name || "Unclassified"}
                    industry={results.industry || "General Industry"}
                />

                {/* 2. Cluster Profile & Description */}
                {results.cluster && (
                    <ClusterProfileComponent
                        currentClusterId={results.cluster.cluster_id}
                        description={results.cluster.description}
                    />
                )}

                {/* 3. Multi-Dimensional Maturity Radar (Stacked) */}
                <MaturityRadar dimensions={results.dimension_scores} />

                {/* 4. Strategic Gap Analysis (Stacked) */}
                {results.strategic_gap_analysis && (
                    <StrategicGapAnalysis
                        executiveBriefing={results.strategic_gap_analysis.executive_briefing}
                        findings={results.strategic_gap_analysis.detailed_findings}
                        dimensionScores={results.dimension_scores}
                    />
                )}

                {/* 5. Strategic Roadmap */}
                {results.roadmap && (
                    <RoadmapView roadmap={results.roadmap} />
                )}

                {/* 6. Expert Consultation CTA */}
                <ExpertConsultation />

                {/* 7. Download Report CTA */}
                <DownloadReport />

            </main>
            <Footer />
        </div>
    );
}
