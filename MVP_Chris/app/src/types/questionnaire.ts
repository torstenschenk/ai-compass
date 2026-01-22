export interface AnswerOption {
    id: number;
    text: string;
    level: number;
    weight: number;
}

export interface Question {
    id: number;
    text: string;
    header?: string;
    type: string; // 'Choice' | 'Checklist' | 'Slider' | 'Statement'
    weight: number;
    optional: boolean;
    answers: AnswerOption[];
}

export interface Dimension {
    id: number;
    title: string;
    weight: number;
    questions: Question[];
}

export type QuestionnaireData = Dimension[];

export interface DimensionProgress {
    dimensionId: number;
    name: string;
    requiredAnswered: number;
    requiredTotal: number;
    optionalAnswered: number;
    optionalTotal: number;
    requiredComplete: boolean;
}
