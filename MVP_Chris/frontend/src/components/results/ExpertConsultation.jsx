import React from 'react';
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Calendar, CheckCircle, ArrowRight } from 'lucide-react';
import { toast } from "sonner";

export function ExpertConsultation() {
    const handleBooking = () => {
        toast.info("Consultation booking feature coming soon!", {
            description: "We are currently integrating with our scheduling system."
        });
    };

    return (
        <section className="py-12 relative isolate overflow-hidden">
            {/* Background Effects */}
            <div className="absolute inset-0 -z-10 bg-slate-900" />
            <div className="absolute inset-0 -z-10 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-purple-900/50 via-slate-900 to-slate-900" />
            <div className="absolute top-0 right-0 -z-10 h-[500px] w-[500px] bg-indigo-600/30 rounded-full blur-[100px] opacity-50" />
            <div className="absolute bottom-0 left-0 -z-10 h-[500px] w-[500px] bg-blue-600/20 rounded-full blur-[100px] opacity-30" />

            <div className="mx-auto max-w-7xl px-6 lg:px-8">
                <div className="mx-auto max-w-2xl text-center mb-12">
                    <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">Expert Consultation & Next Steps</h2>
                    <p className="mt-4 text-lg text-slate-300">
                        Transition from digital analysis to human-led transformation.
                    </p>
                </div>

                <div className="relative rounded-3xl bg-white/5 backdrop-blur-xl ring-1 ring-white/10 p-8 sm:p-12 overflow-hidden">
                    <div className="absolute top-0 right-0 -mr-16 -mt-16 w-64 h-64 bg-indigo-500/20 rounded-full blur-3xl" />

                    <div className="flex flex-col md:flex-row items-center gap-12 relative z-10">
                        {/* Left Content */}
                        <div className="flex-1 space-y-8 text-center md:text-left">
                            <div className="inline-flex items-center gap-2 rounded-full bg-indigo-500/20 px-4 py-1.5 text-sm font-medium text-indigo-200 ring-1 ring-inset ring-indigo-500/30">
                                <Calendar className="w-4 h-4" /> Limited Availability
                            </div>

                            <h3 className="text-3xl md:text-4xl font-bold text-white tracking-tight">
                                Book Your Strategy Deep-Dive
                            </h3>

                            <p className="text-lg text-slate-300 leading-relaxed max-w-xl">
                                "Every SME journey is unique. Schedule a 30-minute debrief with an AI Compass strategist to validate your roadmap and identify industry-specific 'Low-Hanging Fruit'."
                            </p>

                            <div className="flex flex-col sm:flex-row gap-4 justify-center md:justify-start pt-2">
                                <Button
                                    size="lg"
                                    onClick={handleBooking}
                                    className="bg-white text-slate-900 hover:bg-indigo-50 font-bold text-lg h-14 px-8 rounded-full shadow-2xl shadow-indigo-500/20"
                                >
                                    Schedule Consultation <ArrowRight className="ml-2 w-5 h-5" />
                                </Button>
                            </div>
                        </div>

                        {/* Right Content / Features */}
                        <div className="flex-shrink-0 w-full md:w-auto">
                            <div className="bg-slate-900/50 rounded-2xl p-6 ring-1 ring-white/10 max-w-sm mx-auto">
                                <ul className="space-y-4">
                                    {[
                                        "30-minute expert session",
                                        "Industry-specific benchmarks",
                                        "Roadmap validation",
                                        "Budget ROI modeling"
                                    ].map((feature, i) => (
                                        <li key={i} className="flex items-center gap-3 text-slate-200">
                                            <div className="flex-none p-1 rounded-full bg-emerald-500/20 text-emerald-400">
                                                <CheckCircle className="w-4 h-4" />
                                            </div>
                                            <span className="font-medium">{feature}</span>
                                        </li>
                                    ))}
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    );
}
