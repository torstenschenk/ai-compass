import { HeroSection } from "@/components/landing/HeroSection";
import { ValueProposition } from "@/components/landing/ValueProposition";
import { ProcessSection } from "@/components/landing/ProcessSection";
import { OutcomePreview } from "@/components/landing/OutcomePreview";
import { CTASection } from "@/components/landing/CTASection";

export default function Home() {
  return (
    <main className="min-h-screen bg-white">
      <HeroSection />
      <ValueProposition />
      <ProcessSection />
      <OutcomePreview />
      <CTASection />
    </main>
  );
}
