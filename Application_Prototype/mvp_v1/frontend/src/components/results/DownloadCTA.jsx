import React from 'react';
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { FileDown, Check, Download } from 'lucide-react';
import { toast } from "sonner";

export function DownloadCTA({ responseId }) {
    const handleDownload = () => {
        // Placeholder for real PDF endpoint
        // window.location.href = `/api/v1/responses/${responseId}/pdf`;
        toast.success("PDF Report queued for generation!", {
            description: "Check your email in a few minutes (Simulation)."
        });
    };

    return (
        <section className="py-8 flex justify-center">
            <Card className="w-full max-w-4xl border border-slate-200 shadow-xl rounded-2xl overflow-hidden">
                <CardContent className="p-8 md:p-12 flex flex-col md:flex-row items-center gap-8 md:gap-12">
                    {/* Icon Section */}
                    <div className="flex-shrink-0">
                        <div className="w-20 h-20 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                            <FileDown className="w-10 h-10" />
                        </div>
                    </div>

                    {/* Content Section */}
                    <div className="flex-1 text-center md:text-left space-y-4">
                        <h2 className="text-2xl md:text-3xl font-bold text-slate-900">Download Your Complete Report</h2>
                        <p className="text-slate-600 text-lg">
                            Get a comprehensive PDF version of your AI maturity assessment for offline review and team sharing.
                        </p>

                        {/* Features Grid */}
                        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 pt-4">
                            <div className="flex items-center gap-2 justify-center md:justify-start">
                                <span className="bg-green-100 text-green-600 rounded-full p-1"><Check className="w-3 h-3" /></span>
                                <span className="text-sm font-medium text-slate-700">Complete Analysis</span>
                            </div>
                            <div className="flex items-center gap-2 justify-center md:justify-start">
                                <span className="bg-green-100 text-green-600 rounded-full p-1"><Check className="w-3 h-3" /></span>
                                <span className="text-sm font-medium text-slate-700">Visual Charts</span>
                            </div>
                            <div className="flex items-center gap-2 justify-center md:justify-start">
                                <span className="bg-green-100 text-green-600 rounded-full p-1"><Check className="w-3 h-3" /></span>
                                <span className="text-sm font-medium text-slate-700">Shareable Format</span>
                            </div>
                        </div>
                    </div>

                    {/* Button Section */}
                    <div className="flex-shrink-0">
                        <Button
                            onClick={handleDownload}
                            size="lg"
                            className="bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 text-white font-bold h-14 px-8 shadow-lg md:w-auto w-full"
                        >
                            <Download className="mr-2 w-5 h-5" /> Download Full Report
                        </Button>
                    </div>
                </CardContent>
            </Card>
        </section>
    );
}
