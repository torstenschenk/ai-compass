import { FileText, Download, CheckCircle, ShieldCheck } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';

export function DownloadReport() {
    return (
        <Card className="border-0 shadow-lg bg-white overflow-hidden">
            <CardContent className="p-10 flex flex-col md:flex-row items-center gap-10">
                {/* Visual Icon */}
                <div className="shrink-0 relative group">
                    <div className="absolute inset-0 bg-blue-100 rounded-full scale-110 group-hover:scale-125 transition-transform duration-500"></div>
                    <div className="relative bg-white p-6 rounded-2xl shadow-sm border border-slate-100 text-blue-600">
                        <FileText className="w-16 h-16" />
                        <div className="absolute -bottom-2 -right-2 bg-green-500 text-white p-1.5 rounded-full border-2 border-white">
                            <CheckCircle className="w-4 h-4" />
                        </div>
                    </div>
                </div>

                {/* Content */}
                <div className="flex-1 space-y-4 text-center md:text-left">
                    <h2 className="text-2xl font-bold text-slate-900">
                        Download Your Comprehensive Report
                    </h2>
                    <p className="text-slate-600 text-lg leading-relaxed max-w-2xl">
                        Get the full 15-page PDF analysis including detailed dimension breakdowns,
                        peer benchmarking data, and an expanded roadmap for your team.
                    </p>

                    <div className="flex flex-col sm:flex-row gap-4 pt-2 justify-center md:justify-start">
                        <div className="flex items-center gap-2 text-sm text-slate-500 bg-slate-50 px-3 py-1.5 rounded-lg border border-slate-100">
                            <ShieldCheck className="w-4 h-4 text-slate-400" />
                            <span>Enterprise-Grade Security</span>
                        </div>
                    </div>
                </div>

                {/* Action */}
                <div className="shrink-0">
                    <Button size="lg" className="h-14 px-8 text-lg bg-slate-900 hover:bg-slate-800 text-white shadow-xl hover:shadow-2xl transition-all gap-3">
                        <Download className="w-6 h-6" />
                        Download PDF Report
                    </Button>
                    <p className="text-center text-xs text-slate-400 mt-3">
                        Generated instantly. Valid for 30 days.
                    </p>
                </div>
            </CardContent>
        </Card>
    );
}
