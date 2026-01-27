import { HeroSection } from '@/components/landing/HeroSection';
import { ValueProposition } from '@/components/landing/ValueProposition';
import { ProcessSection } from '@/components/landing/ProcessSection';
import { OutcomePreview } from '@/components/landing/OutcomePreview';
import { CTASection } from '@/components/landing/CTASection';

import { Navigation } from '@/components/layout/Navigation';
import { Footer } from '@/components/layout/Footer';

export function LandingPage() {
    return (
        <div className="min-h-screen bg-gray-50">
            <Navigation />
            <HeroSection />
            <ValueProposition />
            <ProcessSection />
            <OutcomePreview />
            <CTASection />

            <Footer />
        </div>
    );
}
