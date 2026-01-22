import { Calendar } from 'lucide-react';
import { Button } from '@/components/ui/button';

export function ExpertConsultation() {
    return (
        <div className="bg-slate-900 rounded-2xl overflow-hidden relative shadow-2xl">
            <div className="absolute top-0 right-0 w-64 h-64 bg-blue-600 rounded-full blur-[100px] opacity-20 -translate-y-1/2 translate-x-1/2"></div>

            <div className="relative p-8 md:p-12 flex flex-col md:flex-row items-center gap-8 text-center md:text-left">
                <div className="space-y-4 flex-1">
                    <h2 className="text-3xl font-bold text-white tracking-tight">Turn this Roadmap into Reality</h2>
                    <p className="text-slate-300 text-lg max-w-xl text-balance">
                        Ready to turn insights into impact? Your AI Compass results provide the map — now let’s execute the journey.
                        Contact our experts for a deep-dive session to precisely locate your "Quick Wins" and define a high-ROI roadmap.
                        Let’s bridge your gaps together and set your AI trajectory in motion.
                    </p>

                    <div className="flex flex-col sm:flex-row gap-3 pt-4 justify-center md:justify-start">
                        <Button size="lg" className="bg-blue-600 hover:bg-blue-500 text-white font-semibold gap-2">
                            <Calendar className="w-5 h-5" />
                            Book Strategy Session
                        </Button>
                    </div>
                </div>

                {/* Profile Avatar / visual element */}
                <div className="shrink-0 bg-slate-800 p-2 rounded-xl border border-slate-700 shadow-xl rotate-3 transform hover:rotate-0 transition-transform">
                    {/* Placeholder image logic by using a div if no image */}
                    <div className="w-48 h-56 bg-gradient-to-br from-slate-700 to-slate-800 rounded-lg flex flex-col items-center justify-center text-slate-500">
                        <span className="text-4xl mb-2">👨‍💻</span>
                        <span className="text-xs font-medium">Chris M.</span>
                        <span className="text-[10px] uppercase tracking-wider opacity-60">AI Consultant</span>
                    </div>
                </div>
            </div>
        </div>
    );
}
