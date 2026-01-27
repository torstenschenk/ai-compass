import type { Question } from '@/types/questionnaire';
import { cn } from '@/components/ui/utils';
import { motion } from 'motion/react';

interface QuestionCardProps {
    question: Question;
    selectedAnswerIds: number[];
    onAnswerSelect: (questionId: number, answerIds: number[]) => void;
}

export function QuestionCard({ question, selectedAnswerIds, onAnswerSelect }: QuestionCardProps) {
    const isMulti = question.type === 'Checklist' || question.type === 'multi_choice';
    const isSlider = question.type === 'Slider';
    const isStatement = question.type === 'Statement';

    const handleSelect = (answerId: number) => {
        if (isMulti) {
            const newIds = selectedAnswerIds.includes(answerId)
                ? selectedAnswerIds.filter(id => id !== answerId)
                : [...selectedAnswerIds, answerId];
            onAnswerSelect(question.id, newIds);
        } else {
            onAnswerSelect(question.id, [answerId]);
        }
    };

    // Helper to render question text with non-bold suffix if present
    const renderQuestionText = (text: string) => {
        const splitPhrase = "(Select all that apply)";
        if (text.includes(splitPhrase)) {
            const parts = text.split(splitPhrase);
            return (
                <>
                    {parts[0]}
                    <span className="font-normal text-gray-500 text-lg md:text-xl block mt-1">
                        {splitPhrase}{parts[1]}
                    </span>
                </>
            );
        }
        return text;
    };

    return (
        <div className="max-w-3xl mx-auto">
            <motion.div
                key={question.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.4 }}
                className="space-y-8"
            >
                <div className="space-y-4 relative">
                    {question.header && (
                        <h3 className="text-sm font-semibold uppercase tracking-wider text-blue-600">
                            {question.header}
                        </h3>
                    )}
                    <h2 className={cn(
                        "font-bold text-gray-900 leading-tight relative",
                        isStatement ? "text-2xl md:text-3xl font-serif italic text-center py-2 px-6 text-blue-900" : "text-2xl"
                    )}>
                        {isStatement && <span className="text-5xl text-blue-200 absolute -top-4 left-0 font-sans select-none">"</span>}
                        {renderQuestionText(question.text)}
                        {isStatement && <span className="text-5xl text-blue-200 absolute -bottom-6 right-0 font-sans leading-none select-none">"</span>}
                    </h2>
                </div>

                {isSlider ? (
                    <div className="space-y-6 py-2">
                        <div className="bg-blue-50/50 rounded-xl p-6 border border-blue-100 text-center min-h-[100px] flex items-center justify-center">
                            <span className="text-xl font-medium text-blue-900 transition-all duration-300">
                                {selectedAnswerIds.length > 0
                                    ? question.answers.find(a => selectedAnswerIds.includes(a.id))?.text
                                    : <span className="text-gray-400 italic">Drag to select...</span>}
                            </span>
                        </div>
                        <div className="px-4">
                            <input
                                type="range"
                                min="0"
                                max={question.answers.length - 1}
                                step="1"
                                value={selectedAnswerIds.length > 0
                                    ? question.answers.findIndex(a => a.id === selectedAnswerIds[0])
                                    : 0}
                                onChange={(e) => handleSelect(question.answers[parseInt(e.target.value)].id)}
                                className="w-full h-3 bg-gray-200 rounded-lg appearance-none cursor-pointer accent-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500/50"
                            />
                            <div className="flex justify-between mt-2 text-xs text-gray-500 uppercase tracking-wide font-semibold">
                                <span>Low</span>
                                <span>High</span>
                            </div>
                        </div>
                    </div>
                ) : (
                    <div className="grid gap-3">
                        {question.answers.map((answer) => {
                            const isSelected = selectedAnswerIds.includes(answer.id);
                            return (
                                <div
                                    key={answer.id}
                                    onClick={() => handleSelect(answer.id)}
                                    className={cn(
                                        "p-4 rounded-xl border-2 cursor-pointer transition-all duration-200 flex items-center justify-between group",
                                        isSelected
                                            ? "border-blue-600 bg-blue-50/30"
                                            : "border-gray-200 hover:border-blue-300 hover:bg-gray-50"
                                    )}
                                >
                                    <span className={cn(
                                        "text-base font-medium",
                                        isSelected ? "text-blue-900" : "text-gray-700"
                                    )}>
                                        {answer.text}
                                    </span>

                                    {/* Checkbox / Radio Visual */}
                                    <div className={cn(
                                        "w-5 h-5 flex items-center justify-center transition-all relative",
                                        isMulti ? "rounded-md border-2" : "rounded-full border-2",
                                        isSelected
                                            ? "border-blue-600"
                                            : "border-gray-300 group-hover:border-blue-400"
                                    )}>
                                        {/* Multi-select Tick (Sticking out) */}
                                        {isMulti && isSelected && (
                                            <svg
                                                viewBox="0 0 24 24"
                                                fill="none"
                                                stroke="currentColor"
                                                strokeWidth="4"
                                                strokeLinecap="round"
                                                strokeLinejoin="round"
                                                className="w-6 h-6 text-blue-600 absolute -top-1 -right-1 pointer-events-none drop-shadow-sm"
                                            >
                                                <polyline points="20 6 9 17 4 12" />
                                            </svg>
                                        )}

                                        {/* Radio Dot (Centered) */}
                                        {!isMulti && isSelected && (
                                            <div className="w-2.5 h-2.5 bg-blue-600 rounded-full" />
                                        )}
                                    </div>
                                </div>
                            );
                        })}
                    </div>
                )}
            </motion.div>
        </div>
    );
}
