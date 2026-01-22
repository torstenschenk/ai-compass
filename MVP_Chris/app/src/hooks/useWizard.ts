import { useState, useEffect, useCallback, useMemo } from 'react';
import type { Dimension, Question, DimensionProgress } from '@/types/questionnaire';

export interface AnswerState {
    questionId: number;
    selectedAnswerIds: number[];
    lastChangedAt: number;
}

export type SaveState = "idle" | "dirty" | "saving" | "saved" | "error";

export function useWizard(dimensions: Dimension[], responseId: number | null) {
    // Initialize state from local storage if available
    const [answers, setAnswers] = useState<Record<number, AnswerState>>({});

    const [currentQuestionIndex, setCurrentQuestionIndex] = useState(0);
    const [isOptionalSection, setIsOptionalSection] = useState(false);
    const [saveStatus, setSaveStatus] = useState<SaveState>("idle");

    // Load initial state
    useEffect(() => {
        if (!responseId || dimensions.length === 0) return;

        try {
            const savedAnswers = localStorage.getItem(`ai_compass_answers:${responseId}`);
            if (savedAnswers) {
                setAnswers(JSON.parse(savedAnswers));
            }

            // Could also save/restore current index, but starting from 0 or calculating first unanswered is safer/better UX sometimes.
            // For now, let's start at 0 unless we implement "resume where left off" logic deeply.
        } catch (e) {
            console.error("Failed to load saved answers", e);
        }
    }, [responseId, dimensions]);

    // Save to local storage on change
    useEffect(() => {
        if (!responseId) return;
        localStorage.setItem(`ai_compass_answers:${responseId}`, JSON.stringify(answers));
        setSaveStatus("saved"); // In MVP, local storage save is instant "saved"
    }, [answers, responseId]);

    const flatQuestions = useMemo(() => {
        if (!dimensions.length) return [];
        // Flatten questions for easier navigation logic, but keep dimension awareness
        const flats: { q: Question; dimIndex: number; qIndexInDim: number }[] = [];
        dimensions.forEach((dim, dIdx) => {
            dim.questions.forEach((q, qIdx) => {
                // Filter by optional if implementing strict sectioning, 
                // but typically we just iterate through all.
                // The spec says Required Section THEN Optional Section.
                // So we should sort/filter based on that.
                flats.push({ q, dimIndex: dIdx, qIndexInDim: qIdx });
            });
        });
        return flats;
    }, [dimensions]);

    // Separate required and optional questions for the "Two Sections" logic
    const requiredQuestions = useMemo(() => flatQuestions.filter(i => !i.q.optional), [flatQuestions]);
    const optionalQuestions = useMemo(() => flatQuestions.filter(i => i.q.optional), [flatQuestions]);

    const activeQuestions = isOptionalSection ? optionalQuestions : requiredQuestions;
    const currentQuestionWrapper = activeQuestions[currentQuestionIndex];
    const currentQuestion = currentQuestionWrapper?.q;
    const currentDimension = dimensions[currentQuestionWrapper?.dimIndex];

    const isLastQuestion = currentQuestionIndex === activeQuestions.length - 1;

    const selectAnswer = useCallback((questionId: number, answerIds: number[]) => {
        setAnswers(prev => ({
            ...prev,
            [questionId]: {
                questionId,
                selectedAnswerIds: answerIds,
                lastChangedAt: Date.now()
            }
        }));
        setSaveStatus("dirty");
    }, []);

    const goToNext = useCallback(() => {
        if (currentQuestionIndex < activeQuestions.length - 1) {
            setCurrentQuestionIndex(prev => prev + 1);
        } else if (!isOptionalSection && optionalQuestions.length > 0) {
            // Finished required, move to optional? 
            // Usually we show an interstitial or "Done" for required.
            // Spec says: Finish (Required) -> Show "Optional Questions" button.
        }
    }, [currentQuestionIndex, activeQuestions.length, isOptionalSection, optionalQuestions.length]);

    const goToPrev = useCallback(() => {
        if (currentQuestionIndex > 0) {
            setCurrentQuestionIndex(prev => prev - 1);
        } else if (isOptionalSection) {
            // Go back to required section?
            setIsOptionalSection(false);
            setCurrentQuestionIndex(requiredQuestions.length - 1);
        }
    }, [currentQuestionIndex, isOptionalSection, requiredQuestions.length]);

    const enterOptionalSection = useCallback(() => {
        setIsOptionalSection(true);
        setCurrentQuestionIndex(0);
    }, []);

    // Progress Computation
    const progress: DimensionProgress[] = useMemo(() => {
        return dimensions.map(dim => {
            let reqAnswered = 0;
            let reqTotal = 0;
            let optAnswered = 0;
            let optTotal = 0;

            dim.questions.forEach(q => {
                const isAnswered = answers[q.id]?.selectedAnswerIds.length > 0;
                if (!q.optional) {
                    reqTotal++;
                    if (isAnswered) reqAnswered++;
                } else {
                    optTotal++;
                    if (isAnswered) optAnswered++;
                }
            });

            return {
                dimensionId: dim.id,
                name: dim.title,
                requiredAnswered: reqAnswered,
                requiredTotal: reqTotal,
                optionalAnswered: optAnswered,
                optionalTotal: optTotal,
                requiredComplete: reqTotal > 0 && reqAnswered === reqTotal
            };
        });
    }, [dimensions, answers]);

    // Overall progress
    const overallProgress = useMemo(() => {
        const totalReq = requiredQuestions.length;
        const answeredReq = requiredQuestions.filter(qa => answers[qa.q.id]?.selectedAnswerIds.length > 0).length;
        return (answeredReq / (totalReq || 1)) * 100;
    }, [requiredQuestions, answers]);

    return {
        currentQuestion,
        currentDimension,
        answers,
        selectAnswer,
        goToNext,
        goToPrev,
        isLastQuestion,
        isOptionalSection,
        enterOptionalSection,
        progress,
        overallProgress,
        saveStatus,
        canGoNext: currentQuestion && answers[currentQuestion.id]?.selectedAnswerIds.length > 0
    };
}
