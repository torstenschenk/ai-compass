'use client';

import { motion } from 'motion/react';
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer } from 'recharts';
import { Award, TrendingUp, Target, Zap } from 'lucide-react';

export function OutcomePreview() {
    const radarData = [
        { subject: 'Strategy', value: 4, fullMark: 5 },
        { subject: 'People', value: 3, fullMark: 5 },
        { subject: 'Data', value: 3.5, fullMark: 5 },
        { subject: 'Use Cases', value: 4.5, fullMark: 5 },
        { subject: 'Processes', value: 2.5, fullMark: 5 },
        { subject: 'Compliance', value: 3, fullMark: 5 },
        { subject: 'Tech', value: 4, fullMark: 5 },
    ];

    const outcomes = [
        {
            icon: Award,
            title: 'Maturity Score',
            description: 'An overall index from 1 to 5.',
        },
        {
            icon: TrendingUp,
            title: 'Cluster Badge',
            description: 'Are you a Curious Experimenter or an AI-Enabled Leader?',
        },
        {
            icon: Target,
            title: 'Gap Analysis',
            description: 'Deep dive into which dimension is holding you back.',
        },
        {
            icon: Zap,
            title: 'Next Steps',
            description: 'Immediate \'Low-Hanging Fruit\' vs. Long-term strategic shifts.',
        },
    ];

    return (
        <section className="py-20 px-6 bg-gradient-to-br from-gray-50 to-blue-50">
            <div className="max-w-7xl mx-auto">
                <div className="text-center mb-16">
                    <h2 className="text-4xl font-bold text-gray-900 mb-4">The Outcome Preview</h2>
                    <p className="text-xl text-gray-600">Your results page will include:</p>
                </div>

                <div className="grid lg:grid-cols-2 gap-12 items-center">
                    <motion.div
                        initial={{ opacity: 0, x: -20 }}
                        whileInView={{ opacity: 1, x: 0 }}
                        transition={{ duration: 0.6 }}
                        viewport={{ once: true }}
                        className="bg-white rounded-2xl shadow-xl p-8"
                    >
                        <h3 className="text-2xl font-semibold text-gray-900 mb-6 text-center">
                            Your AI Maturity Radar
                        </h3>
                        <div className="w-full h-[400px]">
                            <ResponsiveContainer width="100%" height="100%">
                                <RadarChart data={radarData}>
                                    <PolarGrid stroke="#e5e7eb" />
                                    <PolarAngleAxis dataKey="subject" tick={{ fill: '#6b7280', fontSize: 14 }} />
                                    <PolarRadiusAxis angle={90} domain={[0, 5]} tick={{ fill: '#9ca3af', fontSize: 12 }} />
                                    <Radar
                                        name="AI Maturity"
                                        dataKey="value"
                                        stroke="#3b82f6"
                                        fill="#3b82f6"
                                        fillOpacity={0.6}
                                    />
                                </RadarChart>
                            </ResponsiveContainer>
                        </div>
                    </motion.div>

                    <div className="space-y-6">
                        {outcomes.map((outcome, index) => (
                            <motion.div
                                key={index}
                                initial={{ opacity: 0, x: 20 }}
                                whileInView={{ opacity: 1, x: 0 }}
                                transition={{ duration: 0.5, delay: index * 0.1 }}
                                viewport={{ once: true }}
                                className="flex gap-4 bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-shadow"
                            >
                                <div className="flex-shrink-0">
                                    <div className="w-12 h-12 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
                                        <outcome.icon className="w-6 h-6 text-white" />
                                    </div>
                                </div>
                                <div>
                                    <h4 className="font-semibold text-gray-900 mb-1">{outcome.title}</h4>
                                    <p className="text-gray-600 text-sm">{outcome.description}</p>
                                </div>
                            </motion.div>
                        ))}
                    </div>
                </div>
            </div>
        </section>
    );
}
