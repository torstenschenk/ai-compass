import React, { useState } from 'react';
import { Compass, Download, Loader2, ArrowRight } from 'lucide-react';
import { useLocation, Link, useNavigate } from 'react-router-dom';
import { Button } from "@/components/ui/button";
import { api } from '../lib/api';
import { toast } from "sonner";
import {
    AlertDialog,
    AlertDialogAction,
    AlertDialogCancel,
    AlertDialogContent,
    AlertDialogDescription,
    AlertDialogFooter,
    AlertDialogHeader,
    AlertDialogTitle,
    AlertDialogTrigger,
} from "@/components/ui/alert-dialog";

export function Navigation() {
    const location = useLocation();
    const navigate = useNavigate();
    const showDownload = location.pathname.includes('/results/');
    const showStart = location.pathname === '/';
    const responseId = showDownload ? location.pathname.split('/results/')[1] : null;
    const [isDownloading, setIsDownloading] = useState(false);
    const [showResetConfirm, setShowResetConfirm] = useState(false);

    const hasProgress = () => {
        return Object.keys(localStorage).some(key => key.startsWith('assessment_progress_')) ||
            localStorage.getItem('current_response_id');
    };

    const performReset = async () => {
        try {
            const currentResponseId = localStorage.getItem('current_response_id');
            if (currentResponseId) {
                await api.deleteResponseSession(currentResponseId);
            }
        } catch (error) {
            console.error("Backend reset failed", error);
        }

        // Clear assessment progress from localStorage
        Object.keys(localStorage).forEach(key => {
            if (key.startsWith('assessment_progress_')) {
                localStorage.removeItem(key);
            }
        });
        localStorage.removeItem('current_response_id');

        // Optionally clear session storage if we want a fresh start
        sessionStorage.removeItem('cached_questionnaire_data');

        if (location.pathname === '/') {
            window.location.reload();
        } else {
            navigate('/');
        }

        toast.success("Assessment reset. You can start a new one.");
        setShowResetConfirm(false);
    };

    const handleLogoClick = () => {
        if (hasProgress() && location.pathname !== '/') {
            setShowResetConfirm(true);
        } else {
            navigate('/');
        }
    };

    const handleDownload = async () => {
        if (!responseId) return;
        try {
            setIsDownloading(true);
            const blob = await api.downloadPDF(responseId);
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `ai_maturity_report_${responseId}.pdf`;
            document.body.appendChild(a);
            a.click();
            window.URL.revokeObjectURL(url);
            document.body.removeChild(a);
            toast.success("Report downloaded successfully!");
        } catch (error) {
            console.error("Download failed", error);
            toast.error("Failed to download report.");
        } finally {
            setIsDownloading(false);
        }
    };

    return (
        <>
            <nav className="fixed top-0 left-0 right-0 bg-white/90 backdrop-blur-sm z-50 border-b border-gray-200">
                <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
                    <div
                        className="flex items-center gap-3 cursor-pointer group"
                        onClick={handleLogoClick}
                    >
                        <div className="bg-gradient-to-br from-blue-600 to-purple-600 p-2 rounded-lg transition-transform group-hover:scale-110 active:scale-95 shadow-lg shadow-blue-500/20">
                            <Compass className="w-6 h-6 text-white" />
                        </div>
                        <span className="text-xl font-bold bg-gradient-to-r from-slate-900 to-slate-700 bg-clip-text text-transparent group-hover:from-blue-600 group-hover:to-purple-600 transition-all font-heading tracking-tight">AI Compass</span>
                    </div>
                    {showDownload && (
                        <Button
                            size="sm"
                            disabled={isDownloading}
                            className="relative px-6 h-10 text-sm font-bold rounded-xl transition-all shadow-[0_4px_14px_-4px_rgba(79,70,229,0.5)] active:scale-95 bg-gradient-to-r from-indigo-600 to-violet-600 hover:from-indigo-700 hover:to-violet-700 text-white border-0 ring-1 ring-white/20 overflow-hidden group"
                            onClick={handleDownload}
                        >
                            <div className="absolute inset-0 -translate-x-full group-hover:animate-[shimmer_2s_infinite] bg-gradient-to-r from-transparent via-white/20 to-transparent z-10" />
                            <span className="relative z-20 flex items-center">
                                {isDownloading ? <Loader2 className="w-4 h-4 mr-2 animate-spin" /> : <Download className="w-4 h-4 mr-2" />}
                                {isDownloading ? "Generating..." : "Download Report"}
                            </span>
                        </Button>
                    )}
                    {showStart && (
                        <Button asChild size="sm" className="hidden md:inline-flex bg-gradient-to-r from-blue-600 to-purple-600 text-white px-6 h-10 rounded-xl font-bold hover:shadow-lg transition-all border-0 shadow-[0_4px_14px_-4px_rgba(79,70,229,0.5)]">
                            <Link to="/snapshot" className="flex items-center gap-2">
                                Start Free Assessment
                                <ArrowRight className="w-4 h-4" />
                            </Link>
                        </Button>
                    )}
                </div>
            </nav>

            <AlertDialog open={showResetConfirm} onOpenChange={setShowResetConfirm}>
                <AlertDialogContent>
                    <AlertDialogHeader>
                        <AlertDialogTitle>Reset Assessment?</AlertDialogTitle>
                        <AlertDialogDescription>
                            This will clear your current progress and take you back to the home page. You will need to start over from the beginning.
                        </AlertDialogDescription>
                    </AlertDialogHeader>
                    <AlertDialogFooter>
                        <AlertDialogCancel>Cancel</AlertDialogCancel>
                        <AlertDialogAction onClick={performReset} className="bg-destructive text-destructive-foreground hover:bg-destructive/90">
                            Reset and Exit
                        </AlertDialogAction>
                    </AlertDialogFooter>
                </AlertDialogContent>
            </AlertDialog>
        </>
    );
}
