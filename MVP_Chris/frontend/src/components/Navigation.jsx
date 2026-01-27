import { Compass, Download } from 'lucide-react';
import { useLocation } from 'react-router-dom';
import { Button } from "@/components/ui/button";

export function Navigation() {
    const location = useLocation();
    const showDownload = location.pathname.includes('/results/');

    return (
        <nav className="fixed top-0 left-0 right-0 bg-white/90 backdrop-blur-sm z-50 border-b border-gray-200">
            <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
                <div className="flex items-center gap-3">
                    <div className="bg-gradient-to-br from-blue-600 to-purple-600 p-2 rounded-lg">
                        <Compass className="w-6 h-6 text-white" />
                    </div>
                    <span className="text-xl font-semibold text-gray-900">AI Compass</span>
                </div>
                {showDownload && (
                    <Button
                        size="sm"
                        className="relative px-6 h-10 text-sm font-bold rounded-xl transition-all shadow-[0_4px_14px_-4px_rgba(79,70,229,0.5)] active:scale-95 bg-gradient-to-r from-indigo-600 to-violet-600 hover:from-indigo-700 hover:to-violet-700 text-white border-0 ring-1 ring-white/20 overflow-hidden group"
                        onClick={() => document.getElementById('download-cta')?.scrollIntoView({ behavior: 'smooth' })}
                    >
                        <div className="absolute inset-0 -translate-x-full group-hover:animate-[shimmer_2s_infinite] bg-gradient-to-r from-transparent via-white/20 to-transparent z-10" />
                        <span className="relative z-20 flex items-center">
                            Download Report <Download className="w-4 h-4 ml-2" />
                        </span>
                    </Button>
                )}
            </div>
        </nav>
    );
}
