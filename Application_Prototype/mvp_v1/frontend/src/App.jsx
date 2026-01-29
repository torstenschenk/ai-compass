import React from 'react';
import { Routes, Route } from 'react-router-dom';
import LandingPage from './pages/LandingPage';
import CompanySnapshot from './pages/CompanySnapshot';
import QuestionnaireWizard from './pages/QuestionnaireWizard';
import ResultsPage from './pages/ResultsPage';

import { Toaster } from "@/components/ui/sonner"

function App() {
  return (
    <div className="min-h-screen bg-slate-50 text-slate-900">
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/snapshot" element={<CompanySnapshot />} />
        <Route path="/assessment/:responseId" element={<QuestionnaireWizard />} />
        <Route path="/results/:responseId" element={<ResultsPage />} />
      </Routes>
      <Toaster position="bottom-left" />
    </div>
  );
}

export default App;
