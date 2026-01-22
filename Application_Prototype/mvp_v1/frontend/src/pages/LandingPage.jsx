import React from 'react';
import { HeroSection } from '@/components/landing/HeroSection';
import { ValueProposition } from '@/components/landing/ValueProposition';
import { ProcessSection } from '@/components/landing/ProcessSection';
import { OutcomePreview } from '@/components/landing/OutcomePreview';
import { CTASection } from '@/components/landing/CTASection';
import { Footer } from '@/components/Footer';
import { Navigation } from '@/components/Navigation';

import { PageBackground } from '@/components/ui/PageBackground';

export default function LandingPage() {
    // Navigation is fixed at the top, content starts below
    return (
        <div className="min-h-screen flex flex-col font-sans relative overflow-x-hidden">
            <PageBackground />
            <Navigation />
            <main className="flex-grow">
                <HeroSection />
                <ValueProposition />
                <ProcessSection />
                <OutcomePreview />
                <CTASection />
            </main>
            <Footer />
        </div>
    );
}
