import { useState, useEffect } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import { useWizard } from '@/hooks/useWizard';
import type { Dimension } from '@/types/questionnaire';
import { QuestionCard } from '@/components/questionnaire/QuestionCard';
import { DimensionProgress } from '@/components/questionnaire/DimensionProgress';
import { Button } from '@/components/ui/button';
import { ArrowLeft, ArrowRight, CheckCircle2, ChevronRight, Loader2 } from 'lucide-react';
import { Footer } from '@/components/layout/Footer';
import { compassLogo } from '@/assets/compassLogo';

export function Questionnaire() {
    const [searchParams] = useSearchParams();
    const navigate = useNavigate();
    const responseIdParam = searchParams.get('responseId');
    const responseId = responseIdParam ? parseInt(responseIdParam, 10) : null;

    const [dimensions, setDimensions] = useState<Dimension[]>([]);
    const [loading, setLoading] = useState(true);
    const [submitting, setSubmitting] = useState(false);

    // Fetch Questionnaire Data
    useEffect(() => {
        const fetchQuestionnaire = async () => {
            try {
                const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';
                const res = await fetch(`${apiUrl}/api/v1/questionnaire`);
                if (!res.ok) throw new Error('Failed to load questionnaire');
                const data = await res.json();
                setDimensions(data);
            } catch (error) {
                console.error(error);
                // Handle error (maybe redirect to home or show error state)
            } finally {
                setLoading(false);
            }
        };
        fetchQuestionnaire();
    }, []);

    const wizard = useWizard(dimensions, responseId);

    // Initial check for responseId
    useEffect(() => {
        if (!responseId && !loading) {
            // No ID? Redirect to start
            navigate('/company-snapshot');
        }
    }, [responseId, loading, navigate]);

    // Scroll to top on question change
    useEffect(() => {
        if (wizard.currentQuestion) {
            window.scrollTo({ top: 0, behavior: 'instant' });
        }
    }, [wizard.currentQuestion?.id]);

    // Handle Finish / Complete
    const handleFinish = async () => {
        if (!responseId) return;
        setSubmitting(true);
        try {
            const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';

            // 1. Save all items (Session -> DB)
            const items = Object.values(wizard.answers).map(a => ({
                question_id: a.questionId,
                answer_ids: a.selectedAnswerIds
            }));

            // Save in batches or one big batch. One big batch is robust for MVP.
            const saveRes = await fetch(`${apiUrl}/api/v1/responses/${responseId}/items`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ items })
            });

            if (!saveRes.ok) throw new Error("Failed to save answers");

            // 2. Trigger Completion
            const completeRes = await fetch(`${apiUrl}/api/v1/responses/${responseId}/complete`, {
                method: 'POST'
            });

            if (!completeRes.ok) throw new Error("Failed to complete assessment");

            // 3. Navigate to Results
            navigate(`/results?responseId=${responseId}`);

        } catch (error) {
            console.error("Completion failed", error);
            alert("Failed to submit assessment. Please try again.");
        } finally {
            setSubmitting(false);
        }
    };

    if (loading) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-50">
                <div className="flex flex-col items-center gap-4">
                    <Loader2 className="w-8 h-8 animate-spin text-blue-600" />
                    <p className="text-gray-500">Loading assessment...</p>
                </div>
            </div>
        );
    }

    if (!wizard.currentQuestion) {
        return (
            <div className="min-h-screen flex items-center justify-center bg-gray-50">
                <p>Questionnaire data not available.</p>
            </div>
        );
    }

    return (
        <div className="min-h-screen bg-gray-50 flex flex-col">
            {/* Header */}
            <header className="bg-white border-b border-gray-100 sticky top-0 z-10">
                <div className="max-w-7xl mx-auto px-6 h-14 flex items-center justify-between">
                    <div className="flex items-center gap-4">
                        <div className="w-8 h-8 flex items-center justify-center">
                            <img src={compassLogo} alt="AI Compass" className="w-full h-full object-contain" />
                        </div>
                        <span className="font-bold text-gray-900">AI Compass</span>
                        <span className="text-gray-300">|</span>
                        <span className="text-sm text-gray-500">
                            {wizard.currentDimension?.title}
                        </span>
                    </div>
                    {wizard.saveStatus === 'saved' && (
                        <span className="text-xs text-gray-400 flex items-center gap-1">
                            <CheckCircle2 className="w-3 h-3" /> Saved
                        </span>
                    )}
                    {wizard.saveStatus === 'dirty' && (
                        <span className="text-xs text-gray-400">Saving...</span>
                    )}
                </div>
            </header>

            <main className="flex-1 max-w-7xl mx-auto w-full px-6 py-8 flex gap-8">
                {/* Sidebar Progress */}
                <DimensionProgress
                    progress={wizard.progress}
                    currentDimensionId={wizard.currentDimension?.id}
                />

                {/* Main Content */}
                <div className="flex-1 flex flex-col max-w-3xl">
                    <div className="flex-1">
                        <QuestionCard
                            question={wizard.currentQuestion}
                            selectedAnswerIds={wizard.answers[wizard.currentQuestion.id]?.selectedAnswerIds || []}
                            onAnswerSelect={wizard.selectAnswer}
                        />
                    </div>

                    {/* Navigation Controls */}
                    <div className="mt-12 flex items-center justify-between border-t border-gray-100 pt-8">
                        <Button
                            variant="ghost"
                            onClick={wizard.goToPrev}
                            disabled={wizard.isOptionalSection && wizard.answers[wizard.currentQuestion.id] === undefined && false /* always allow back logic needs adjustment in hook for first question */}
                            className="text-gray-500 hover:text-gray-900"
                        >
                            <ArrowLeft className="w-4 h-4 mr-2" />
                            Back
                        </Button>

                        {!wizard.isLastQuestion ? (
                            <Button
                                onClick={wizard.goToNext}
                                disabled={!wizard.canGoNext}
                                className="bg-gray-900 hover:bg-gray-800 text-white min-w-[140px]"
                            >
                                Next
                                <ChevronRight className="w-4 h-4 ml-2" />
                            </Button>
                        ) : (
                            <Button
                                onClick={handleFinish}
                                disabled={!wizard.canGoNext || submitting}
                                className="bg-blue-600 hover:bg-blue-700 text-white min-w-[140px]"
                            >
                                {submitting ? (
                                    <>
                                        <Loader2 className="w-4 h-4 mr-2 animate-spin" />
                                        Submitting...
                                    </>
                                ) : (
                                    <>
                                        Finish Assessment
                                        <ArrowRight className="w-4 h-4 ml-2" />
                                    </>
                                )}
                            </Button>
                        )}
                    </div>
                </div>
            </main>
            <Footer />
        </div>
    );
}
