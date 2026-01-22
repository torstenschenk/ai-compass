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
        <section className="py-8">
            <div className="text-center mb-8 space-y-2">
                <h2 className="text-3xl font-bold tracking-tight text-primary">Expert Consultation & Next Steps</h2>
                <p className="text-muted-foreground text-lg">Transitioning from a digital report to human-led transformation.</p>
            </div>

            <Card className="border-none shadow-2xl overflow-hidden relative">
                {/* Gradient Background */}
                <div className="absolute inset-0 bg-gradient-to-br from-blue-500 to-purple-600" />

                <CardContent className="relative z-10 p-8 md:p-12 flex flex-col items-center text-center space-y-8">
                    <div className="p-4 bg-white/20 backdrop-blur-sm rounded-full text-white mb-2">
                        <Calendar className="w-8 h-8 md:w-10 md:h-10" />
                    </div>

                    <div className="space-y-4 max-w-2xl">
                        <h3 className="text-3xl md:text-4xl font-bold text-white tracking-tight">
                            Book Your Results Deep-Dive
                        </h3>
                        <div className="bg-black/10 backdrop-blur-sm p-6 rounded-xl">
                            <p className="text-lg text-white/90 leading-relaxed font-medium">
                                "Every SME journey is unique. Schedule a 30-minute debrief with an AI Compass strategist to walk through these results, validate the roadmap against your current budget, and identify the 'Low-Hanging Fruit' specific to your industry."
                            </p>
                        </div>
                    </div>

                    <Button
                        size="lg"
                        onClick={handleBooking}
                        className="bg-white text-blue-600 hover:bg-blue-50 font-bold text-lg px-8 py-6 h-auto shadow-lg transform hover:-translate-y-1 transition-all"
                    >
                        Schedule Consultation <ArrowRight className="ml-2 w-5 h-5" />
                    </Button>

                    <div className="flex flex-col md:flex-row gap-6 md:gap-12 text-white/90 text-sm font-medium pt-4">
                        <div className="flex items-center gap-2 bg-white/10 px-4 py-2 rounded-full">
                            <CheckCircle className="w-4 h-4" /> 30-minute session
                        </div>
                        <div className="flex items-center gap-2 bg-white/10 px-4 py-2 rounded-full">
                            <CheckCircle className="w-4 h-4" /> Industry-specific insights
                        </div>
                        <div className="flex items-center gap-2 bg-white/10 px-4 py-2 rounded-full">
                            <CheckCircle className="w-4 h-4" /> Budget validation
                        </div>
                    </div>
                </CardContent>
            </Card>
        </section>
    );
}
