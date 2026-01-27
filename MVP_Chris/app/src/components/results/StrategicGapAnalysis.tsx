import { motion, AnimatePresence } from 'motion/react';
import { AlertTriangle, TrendingUp, Target, ArrowRight, ChevronRight } from 'lucide-react';
import { useState } from 'react';

// Types (Must utilize the types from schemas or define locally if needed for disjoint components)
// Ideally we import these, but for now we redefine minimal interfaces or use ones passed from parent
interface DimensionScore {
    dimension_name: string;
    score: number;
    // industry_score might be present but optional
}

interface StrategicFinding {
    type: string;
    title: string;
    score: number; // This often represents impact or gap size in findings
    context: string;
    dimension_name?: string;
    tactical_theme?: string;
}

interface StrategicGapAnalysisProps {
    executiveBriefing: string;
    findings: StrategicFinding[];
    dimensionScores: DimensionScore[];
}

export function StrategicGapAnalysis({ executiveBriefing, findings, dimensionScores }: StrategicGapAnalysisProps) {
    const [selectedGap, setSelectedGap] = useState<number | null>(null);

    if (!findings || findings.length === 0) return null;

    // 1. Calculate Insights
    const avgImpactScore = findings.reduce((acc, f) => acc + f.score, 0) / findings.length;
    const risksIdentified = findings.length; // Or filter by 'Weakness' / 'Anomaly'? Usage implies total findings shown.

    const insights = {
        risksIdentified: risksIdentified,
        avgImpactScore: avgImpactScore,
        urgency: avgImpactScore > 4.0 ? 'Critical' : 'High', // Simple logic
        timeframe: '3 months' // Default timeframe
    };

    // 2. Map Findings to Gaps
    const gaps = findings.map((f, index) => {
        // Find current maturity for the dimension related to this finding
        const relatedDim = dimensionScores.find(d => d.dimension_name === f.dimension_name);
        const currentMaturity = relatedDim ? relatedDim.score : 0; // Default to 0 if not found (or should we use f.score?)
        // In many gap analyses, finding.score IS the gap size or impact. 
        // But if we want to show "Current vs Target", we need the dimension score.

        return {
            id: index + 1,
            title: f.title,
            category: f.dimension_name || f.tactical_theme || 'Strategic',
            currentMaturity: Number(currentMaturity.toFixed(1)),
            targetMaturity: 5.0,
            strategicImpact: Number(Math.min(5, f.score / 4).toFixed(1)), // Normalize (approx 20 -> 5)
            urgency: (f.score / 4) > 3.5 ? 'critical' : 'high', // Adjusted threshold
            description: f.context,
            keyIssues: [f.context], // We don't have broken down issues, so use context
            recommendation: 'See detailed roadmap for specific action items.' // Placeholder as recommendation isn't in finding struct
        };
    });

    const getGapPercentage = (current: number, target: number) => {
        if (target === 0) return 0;
        return Math.max(0, ((target - current) / target) * 100);
    };

    return (
        <section className="py-16 px-6 bg-gradient-to-br from-gray-50 to-blue-50 rounded-3xl my-12">
            <div className="max-w-7xl mx-auto">
                {/* Section Header */}
                <div className="text-center mb-12">
                    <motion.h2
                        initial={{ opacity: 0, y: 20 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        className="text-4xl font-bold text-gray-900 mb-4"
                    >
                        Strategic Gap Analysis
                    </motion.h2>
                    <motion.p
                        initial={{ opacity: 0, y: 20 }}
                        whileInView={{ opacity: 1, y: 0 }}
                        viewport={{ once: true }}
                        transition={{ delay: 0.1 }}
                        className="text-xl text-gray-600 max-w-3xl mx-auto"
                    >
                        Structural risks identifying the delta between current capability and strategic ambition.
                    </motion.p>
                </div>

                {/* Key Insights Dashboard */}
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-12">
                    {[
                        { label: 'Critical Gaps', value: insights.risksIdentified, icon: Target },
                        { label: 'Avg Impact Score', value: insights.avgImpactScore.toFixed(1), icon: TrendingUp },
                        { label: 'Priority Level', value: insights.urgency, icon: AlertTriangle },
                        { label: 'Action Window', value: insights.timeframe, icon: ArrowRight },
                    ].map((metric, index) => (
                        <motion.div
                            key={index}
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ delay: 0.1 * index }}
                            className="bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-shadow"
                        >
                            <div className="w-12 h-12 rounded-lg bg-blue-50 flex items-center justify-center mb-4">
                                <metric.icon className="w-6 h-6 text-blue-600" />
                            </div>
                            <div className="text-3xl font-bold text-gray-900 mb-1">{metric.value}</div>
                            <div className="text-sm text-gray-500">{metric.label}</div>
                        </motion.div>
                    ))}
                </div>

                {/* Executive Summary */}
                <motion.div
                    initial={{ opacity: 0, y: 20 }}
                    whileInView={{ opacity: 1, y: 0 }}
                    viewport={{ once: true }}
                    className="bg-white rounded-2xl p-8 mb-8 shadow-xl border border-gray-100"
                >
                    <div className="flex items-start gap-4">
                        <div className="w-12 h-12 rounded-lg bg-blue-50 flex items-center justify-center flex-shrink-0">
                            <Target className="w-6 h-6 text-blue-600" />
                        </div>
                        <div className="flex-1">
                            <h3 className="text-2xl font-bold text-gray-900 mb-3">Strategic Verdict</h3>
                            <p className="text-lg text-gray-600 leading-relaxed mb-4">
                                Your AI maturity profile reveals <strong className="text-gray-900">high potential but decoupled execution</strong>.
                                The identified gaps create strategic debt that compounds over time, limiting ROI from existing AI investments.
                            </p>
                            <div className="flex items-center gap-2 text-blue-600">
                                <span className="font-semibold">Recommended Action:</span>
                                <span className="text-gray-600">Prioritize these areas to transform initiatives from experimental to scalable</span>
                            </div>
                        </div>
                    </div>
                </motion.div>

                {/* Gap Cards */}
                <div className="space-y-6">
                    {gaps.map((gap, index) => (
                        <motion.div
                            key={gap.id}
                            initial={{ opacity: 0, y: 20 }}
                            whileInView={{ opacity: 1, y: 0 }}
                            viewport={{ once: true }}
                            transition={{ delay: 0.1 * index }}
                            className="bg-white rounded-2xl shadow-lg border border-gray-200 overflow-hidden hover:shadow-xl transition-shadow"
                        >
                            {/* Card Header */}
                            <div className="p-8 border-b border-gray-100">
                                <div className="flex items-start justify-between mb-4">
                                    <div className="flex-1">
                                        <div className="flex items-center gap-3 mb-2">
                                            <span className={`px-3 py-1 rounded-lg text-xs font-semibold border ${gap.urgency === 'critical' ? 'bg-red-50 text-red-700 border-red-100' : 'bg-amber-50 text-amber-700 border-amber-100'
                                                }`}>
                                                {gap.urgency === 'critical' ? 'Critical Gap' : 'Gap'} {index + 1}
                                            </span>
                                            <span className="text-sm text-gray-500">{gap.category}</span>
                                        </div>
                                        <h3 className="text-2xl font-bold text-gray-900 mb-2">{gap.title}</h3>
                                        <p className="text-gray-600 leading-relaxed line-clamp-2">{gap.description}</p>
                                    </div>
                                    <button
                                        onClick={() => setSelectedGap(selectedGap === gap.id ? null : gap.id)}
                                        className="ml-4 w-10 h-10 rounded-lg bg-gray-50 flex items-center justify-center hover:bg-gray-100 transition-colors"
                                    >
                                        <ChevronRight className={`w-5 h-5 text-gray-600 transition-transform ${selectedGap === gap.id ? 'rotate-90' : ''}`} />
                                    </button>
                                </div>

                                {/* Metrics Visualization */}
                                <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mt-6">
                                    {/* Current vs Target Maturity */}
                                    <div>
                                        <div className="text-sm text-gray-500 mb-2">Current Maturity</div>
                                        <div className="flex items-baseline gap-2">
                                            <span className="text-3xl font-bold text-gray-900">{gap.currentMaturity}</span>
                                            <span className="text-gray-400">/</span>
                                            <span className="text-lg text-gray-500">{gap.targetMaturity}</span>
                                        </div>
                                        <div className="mt-2 h-2 bg-gray-100 rounded-full overflow-hidden">
                                            <div
                                                className="h-full bg-blue-600 rounded-full"
                                                style={{ width: `${(gap.currentMaturity / gap.targetMaturity) * 100}%` }}
                                            />
                                        </div>
                                    </div>

                                    {/* Strategic Impact */}
                                    <div>
                                        <div className="text-sm text-gray-500 mb-2">Strategic Impact</div>
                                        <div className="flex items-baseline gap-2">
                                            <span className="text-3xl font-bold text-orange-600">{gap.strategicImpact}</span>
                                            <span className="text-sm text-gray-400 font-medium">/ 5.0</span>
                                        </div>
                                        <div className="mt-2 h-2 bg-gray-100 rounded-full overflow-hidden">
                                            <div
                                                className="h-full bg-orange-500 rounded-full"
                                                style={{ width: `${(gap.strategicImpact / 5) * 100}%` }}
                                            />
                                        </div>
                                    </div>

                                    {/* Gap Size */}
                                    <div>
                                        <div className="text-sm text-gray-500 mb-2">Maturity Gap</div>
                                        <div className="text-3xl font-bold text-red-600">
                                            {getGapPercentage(gap.currentMaturity, gap.targetMaturity).toFixed(0)}%
                                        </div>
                                        <div className="mt-2 flex items-center gap-2">
                                            <div className="flex-1 h-2 bg-red-500 rounded-full" />
                                            <AlertTriangle className="w-4 h-4 text-red-500" />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            {/* Expandable Details */}
                            <AnimatePresence>
                                {selectedGap === gap.id && (
                                    <motion.div
                                        initial={{ height: 0, opacity: 0 }}
                                        animate={{ height: 'auto', opacity: 1 }}
                                        exit={{ height: 0, opacity: 0 }}
                                        transition={{ duration: 0.3 }}
                                        className="border-t border-gray-100 bg-gray-50 block overflow-hidden"
                                    >
                                        <div className="p-8">
                                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                                {/* Key Issues */}
                                                <div>
                                                    <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                                                        <div className="w-6 h-6 rounded-lg bg-red-50 flex items-center justify-center">
                                                            <AlertTriangle className="w-3 h-3 text-red-600" />
                                                        </div>
                                                        Context & Issues
                                                    </h4>
                                                    <p className="text-gray-600 leading-relaxed text-sm">
                                                        {gap.description}
                                                    </p>
                                                </div>

                                                {/* Recommendation */}
                                                <div>
                                                    <h4 className="font-semibold text-gray-900 mb-3 flex items-center gap-2">
                                                        <div className="w-6 h-6 rounded-lg bg-blue-50 flex items-center justify-center">
                                                            <Target className="w-3 h-3 text-blue-600" />
                                                        </div>
                                                        Recommended Action
                                                    </h4>
                                                    <p className="text-gray-700 leading-relaxed bg-blue-50 p-4 rounded-lg border border-blue-100 text-sm">
                                                        {gap.recommendation}
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </motion.div>
                                )}
                            </AnimatePresence>
                        </motion.div>
                    ))}
                </div>
            </div >
        </section >
    );
}
