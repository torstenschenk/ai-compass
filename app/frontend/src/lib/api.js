/**
 * API Client for AI-Compass Backend
 */

const API_BASE_URL = (import.meta.env.VITE_API_URL || '/api/v1').replace(/\/$/, '');

/**
 * Helper to handle API responses
 */
async function handleResponse(response) {
    if (!response.ok) {
        const errorBody = await response.json().catch(() => ({}));
        const errorMessage = errorBody.detail || response.statusText || 'API Error';
        throw new Error(errorMessage);
    }
    return response.json();
}

export const api = {
    /**
     * Fetch questionnaire with all questions
     */
    getQuestionnaire: async () => {
        const response = await fetch(`${API_BASE_URL}/questionnaire`);
        return handleResponse(response);
    },

    /**
     * Create a new assessment session
     * @param {Object} sessionData 
     */
    createSession: async (sessionData) => {
        const response = await fetch(`${API_BASE_URL}/sessions`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(sessionData),
        });
        return handleResponse(response);
    },

    /**
     * Autosave an answer
     * @param {number} sessionId 
     * @param {number} questionId 
     * @param {Array<number>} answerIds 
     */
    saveAnswer: async (sessionId, questionId, answerIds) => {
        const response = await fetch(`${API_BASE_URL}/sessions/${sessionId}/items`, {
            method: 'PATCH',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                question_id: questionId,
                answer_ids: answerIds
            }),
        });
        return handleResponse(response);
    },

    /**
     * Complete the assessment
     * @param {number} sessionId 
     */
    completeAssessment: async (sessionId) => {
        const response = await fetch(`${API_BASE_URL}/sessions/${sessionId}/complete`, {
            method: 'POST',
        });
        return handleResponse(response);
    },

    /**
     * Get results
     * @param {number} sessionId 
     */
    getResults: async (sessionId) => {
        const response = await fetch(`${API_BASE_URL}/sessions/${sessionId}/results`);
        return handleResponse(response);
    },

    /**
     * Download PDF Report
     * @param {number} sessionId
     */
    downloadPDF: async (sessionId) => {
        const response = await fetch(`${API_BASE_URL}/sessions/${sessionId}/pdf`);
        if (!response.ok) throw new Error("PDF Generation Failed");
        return response.blob();
    },

    /**
     * Clear assessment session on backend
     * @param {number} sessionId
     */
    deleteSession: async (sessionId) => {
        const response = await fetch(`${API_BASE_URL}/sessions/${sessionId}`, {
            method: 'DELETE',
        });
        return handleResponse(response);
    },
};
