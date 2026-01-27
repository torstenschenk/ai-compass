import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { LandingPage } from '@/pages/LandingPage';
import { CompanySnapshot } from '@/pages/CompanySnapshot';
import { Questionnaire } from '@/pages/Questionnaire';
import { ResultsPage } from '@/pages/ResultsPage';
import ScrollToTop from '@/components/common/ScrollToTop';

function App() {
  return (
    <Router>
      <ScrollToTop />
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/company-snapshot" element={<CompanySnapshot />} />
        <Route path="/questionnaire" element={<Questionnaire />} />
        <Route path="/results" element={<ResultsPage />} />
      </Routes>
    </Router>
  );
}

export default App;
