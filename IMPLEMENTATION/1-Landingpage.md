**Section A**. The Hero Section (The Hook) 
Include image that fits well 
Headline: Navigate the AI Evolution with the AI Compass. 
Sub-headline: Stop guessing. Gain strategic clarity in 10-15 minutes. Benchmark your Organization against 500+ peers and receive a data-driven roadmap to AI maturity. No costs attached, just your valuable time.  
Primary CTA: [Start Free Assessment] 
Trust Signal: “Takes 10-15 mins | GDPR Compliant | Professional Framework”
Use the following code:
import { ArrowRight, Shield, Clock, Award } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

export function HeroSection() {
  return (
    <section className="pt-32 pb-20 px-6">
      <div className="max-w-7xl mx-auto">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h1 className="text-5xl lg:text-6xl font-bold text-gray-900 mb-6 leading-tight">
              Navigate the AI Evolution with the AI Compass.
            </h1>
            <p className="text-xl text-gray-600 mb-8 leading-relaxed">
              Stop guessing. Gain strategic clarity in 10-15 minutes. Benchmark your Organization against 500+ peers and receive a data-driven roadmap to AI maturity. No costs attached, just your valuable time.
            </p>
            <button className="group bg-gradient-to-r from-blue-600 to-purple-600 text-white px-8 py-4 rounded-lg text-lg font-semibold hover:shadow-xl transition-all flex items-center gap-2">
              Start Free Assessment
              <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
            </button>
            <div className="flex items-center gap-6 mt-8 text-sm text-gray-600">
              <div className="flex items-center gap-2">
                <Clock className="w-4 h-4" />
                <span>Takes 10-15 mins</span>
              </div>
              <div className="flex items-center gap-2">
                <Shield className="w-4 h-4" />
                <span>GDPR Compliant</span>
              </div>
              <div className="flex items-center gap-2">
                <Award className="w-4 h-4" />
                <span>Professional Framework</span>
              </div>
            </div>
          </div>
          <div className="relative">
            <div className="absolute inset-0 bg-gradient-to-br from-blue-600/20 to-purple-600/20 rounded-2xl blur-3xl"></div>
            <ImageWithFallback
              src="https://images.unsplash.com/photo-1697577418970-95d99b5a55cf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxhcnRpZmljaWFsJTIwaW50ZWxsaWdlbmNlJTIwdGVjaG5vbG9neXxlbnwxfHx8fDE3NjgyMDU3MDZ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral"
              alt="AI Technology"
              className="relative rounded-2xl shadow-2xl w-full h-auto"
            />
          </div>
        </div>
      </div>
    </section>
  );
}


**Section B**: make a flip card with title on the front and "what" plus "why" on the back.  
Headline: The Value Proposition (The "Why") Why the AI Compass? 
Sub-headline: AI is not a tool you buy; it is a capability you build. The AI Compass is a professional consulting tool designed to provide the diagnostic clarity needed to ensure your investment leads to growth, not just expense.
1) Assess Your Current AI Maturity Level 
What it is: A comprehensive multi-dimensional audit that evaluates your organization across 7 core pillars: Strategy, People, Data, Use Cases, Processes, Compliance, and Tech Infrastructure.  Why it’s necessary: You cannot improve what you do not measure. By establishing an objective baseline, you move away from guesswork and gain a scientific understanding of your organization's actual readiness.
2) Benchmarking Beyond the Hype
What it is: A comparative analysis that measures your digital capabilities against a verified database of 500+ peer companies and industry leaders. Why it’s necessary: Strategic positioning is relative. Benchmarking tells you if you are truly leading your industry or if competitors are gaining a technological advantage that will be difficult to close later.
3) Bridging the Human-Tech Divide
What it is: An evaluation of organizational culture, employee mindset, and internal AI literacy levels. Why it’s necessary: Technology only scales as fast as your people. Identifying psychological resistance or skill gaps early ensures your culture supports your technical transformation instead of blocking it.
4) Risk & Compliance Safeguard
What it is: A proactive audit of your alignment with emerging standards, such as the EU AI Act, and internal data ethics protocols. Why it’s necessary: Moving fast is important, but moving safely is vital. This safeguard protects your company’s reputation and future-proofs your operations against shifting legal landscapes.
5) Identify Gaps and Opportunities
What it is: A precise gap-analysis tool that reveals hidden weaknesses in your digital foundation while highlighting untapped areas for innovation. Why it’s necessary: To reach the next maturity level, you must know exactly what is holding you back. Pinpointing these "friction points" allows you to fix the foundation while simultaneously seizing "low-hanging fruit."
6) Prioritized Strategic Advisory
What it is: A structured advisory module that translates your maturity gaps into a prioritized sequence of strategic topics and focus areas (e.g., "Data Foundation" before "Customer-facing AI"). Why it’s necessary: SMEs often suffer from "pilot fatigue" by trying to do everything at once. This advisory ensures that you tackle the right topics in the right order, focusing resources on the thematic areas that will resolve your specific business bottlenecks most effectively.
Use the following code:
import { useState } from 'react';
import { motion } from 'motion/react';
import { LucideIcon } from 'lucide-react';

interface FlipCardProps {
  title: string;
  icon: LucideIcon;
  what: string;
  why: string;
  index: number;
}

export function FlipCard({ title, icon: Icon, what, why, index }: FlipCardProps) {
  const [isFlipped, setIsFlipped] = useState(false);

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5, delay: index * 0.1 }}
      viewport={{ once: true }}
      className="h-[400px]"
      style={{ perspective: '1000px' }}
    >
      <motion.div
        className="relative w-full h-full cursor-pointer"
        style={{ transformStyle: 'preserve-3d' }}
        animate={{ rotateY: isFlipped ? 180 : 0 }}
        transition={{ duration: 0.6 }}
        onClick={() => setIsFlipped(!isFlipped)}
      >
        {/* Front */}
        <div
          className="absolute inset-0 bg-white rounded-xl shadow-lg border border-gray-200 p-8 flex flex-col items-center justify-center text-center"
          style={{ backfaceVisibility: 'hidden' }}
        >
          <div className="bg-gradient-to-br from-blue-100 to-purple-100 p-4 rounded-full mb-4">
            <Icon className="w-8 h-8 text-blue-600" />
          </div>
          <h3 className="text-xl font-semibold text-gray-900">{title}</h3>
          <p className="text-sm text-gray-500 mt-2">Click to flip</p>
        </div>

        {/* Back */}
        <div
          className="absolute inset-0 bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl shadow-lg p-8 text-white overflow-y-auto"
          style={{
            backfaceVisibility: 'hidden',
            transform: 'rotateY(180deg)',
          }}
        >
          <div className="space-y-4">
            <div>
              <h4 className="font-semibold mb-2 text-blue-100">What it is:</h4>
              <p className="text-sm leading-relaxed">{what}</p>
            </div>
            <div>
              <h4 className="font-semibold mb-2 text-blue-100">Why it's necessary:</h4>
              <p className="text-sm leading-relaxed">{why}</p>
            </div>
          </div>
        </div>
      </motion.div>
    </motion.div>
  );
}

And the following code:
import { FlipCard } from './FlipCard';
import { BarChart3, Users, TrendingUp, Shield, Target, Lightbulb } from 'lucide-react';

export function ValueProposition() {
  const cards = [
    {
      title: 'Assess Your Current AI Maturity Level',
      icon: BarChart3,
      what: 'A comprehensive multi-dimensional audit that evaluates your organization across 7 core pillars: Strategy, People, Data, Use Cases, Processes, Compliance, and Tech Infrastructure.',
      why: 'You cannot improve what you do not measure. By establishing an objective baseline, you move away from guesswork and gain a scientific understanding of your organization\'s actual readiness.',
    },
    {
      title: 'Benchmarking Beyond the Hype',
      icon: TrendingUp,
      what: 'A comparative analysis that measures your digital capabilities against a verified database of 500+ peer companies and industry leaders.',
      why: 'Strategic positioning is relative. Benchmarking tells you if you are truly leading your industry or if competitors are gaining a technological advantage that will be difficult to close later.',
    },
    {
      title: 'Bridging the Human-Tech Divide',
      icon: Users,
      what: 'An evaluation of organizational culture, employee mindset, and internal AI literacy levels.',
      why: 'Technology only scales as fast as your people. Identifying psychological resistance or skill gaps early ensures your culture supports your technical transformation instead of blocking it.',
    },
    {
      title: 'Risk & Compliance Safeguard',
      icon: Shield,
      what: 'A proactive audit of your alignment with emerging standards, such as the EU AI Act, and internal data ethics protocols.',
      why: 'Moving fast is important, but moving safely is vital. This safeguard protects your company\'s reputation and future-proofs your operations against shifting legal landscapes.',
    },
    {
      title: 'Identify Gaps and Opportunities',
      icon: Target,
      what: 'A precise gap-analysis tool that reveals hidden weaknesses in your digital foundation while highlighting untapped areas for innovation.',
      why: 'To reach the next maturity level, you must know exactly what is holding you back. Pinpointing these "friction points" allows you to fix the foundation while simultaneously seizing "low-hanging fruit."',
    },
    {
      title: 'Prioritized Strategic Advisory',
      icon: Lightbulb,
      what: 'A structured advisory module that translates your maturity gaps into a prioritized sequence of strategic topics and focus areas (e.g., "Data Foundation" before "Customer-facing AI").',
      why: 'SMEs often suffer from "pilot fatigue" by trying to do everything at once. This advisory ensures that you tackle the right topics in the right order, focusing resources on the thematic areas that will resolve your specific business bottlenecks most effectively.',
    },
  ];

  return (
    <section id="benefits" className="py-20 px-6 bg-gray-50">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            The Value Proposition
          </h2>
          <p className="text-xl text-gray-600 max-w-3xl mx-auto">
            AI is not a tool you buy; it is a capability you build. The AI Compass is a professional consulting tool designed to provide the diagnostic clarity needed to ensure your investment leads to growth, not just expense.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {cards.map((card, index) => (
            <FlipCard
              key={index}
              title={card.title}
              icon={card.icon}
              what={card.what}
              why={card.why}
              index={index}
            />
          ))}
        </div>
      </div>
    </section>
  );
}


**Section C**: 3 step process.  Content: The Process (The "How")
Guided Assessment: 27 questions covering 7 key dimensions (Strategy, People, Data, Use Cases, Processes, Compliance, and Tech Infrastructure).
Instant Analysis: Our AI supported algorithm identifies your unique Company Cluster Profile and your current potential.
Growth Roadmap: Receive custom recommendations to move from your current level to the next.
Use the following code:
import { motion } from 'motion/react';
import { ClipboardList, Sparkles, Map } from 'lucide-react';

export function ProcessSection() {
  const steps = [
    {
      number: '01',
      title: 'Guided Assessment',
      description: '27 questions covering 7 key dimensions (Strategy, People, Data, Use Cases, Processes, Compliance, and Tech Infrastructure).',
      icon: ClipboardList,
    },
    {
      number: '02',
      title: 'Instant Analysis',
      description: 'Our AI supported algorithm identifies your unique Company Cluster Profile and your current potential.',
      icon: Sparkles,
    },
    {
      number: '03',
      title: 'Growth Roadmap',
      description: 'Receive custom recommendations to move from your current level to the next.',
      icon: Map,
    },
  ];

  return (
    <section id="how-it-works" className="py-20 px-6 bg-white">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">The Process</h2>
          <p className="text-xl text-gray-600">Three simple steps to your AI roadmap</p>
        </div>

        <div className="relative">
          {/* Connection Line */}
          <div className="hidden lg:block absolute top-1/2 left-0 right-0 h-1 bg-gradient-to-r from-blue-200 via-purple-200 to-blue-200 -translate-y-1/2 z-0"></div>

          <div className="grid md:grid-cols-3 gap-8 relative z-10">
            {steps.map((step, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                whileInView={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: index * 0.2 }}
                viewport={{ once: true }}
                className="relative"
              >
                <div className="bg-white border-2 border-gray-200 rounded-xl p-8 hover:border-blue-600 transition-colors hover:shadow-xl">
                  <div className="flex items-center justify-center w-16 h-16 bg-gradient-to-br from-blue-600 to-purple-600 rounded-full mb-6 mx-auto">
                    <step.icon className="w-8 h-8 text-white" />
                  </div>
                  <div className="text-center">
                    <div className="text-5xl font-bold text-gray-200 mb-2">{step.number}</div>
                    <h3 className="text-xl font-semibold text-gray-900 mb-3">{step.title}</h3>
                    <p className="text-gray-600 leading-relaxed">{step.description}</p>
                  </div>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

**Section D**. The Outcome Preview (The "Gold") Visual Element as radar chart Content: "Your results page will include:" Maturity Score: An overall index from 1 to 5. Cluster Badge: Are you a Curious Experimenter or an AI-Enabled Leader? Gap Analysis: Deep dive into which dimension is holding you back. Next Steps: Immediate 'Low-Hanging Fruit' vs. Long-term strategic shifts.
Use the following code:
import { motion } from 'motion/react';
import { Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer } from 'recharts';
import { Award, TrendingUp, Target, Zap } from 'lucide-react';

export function OutcomePreview() {
  const radarData = [
    { subject: 'Strategy', value: 4, fullMark: 5 },
    { subject: 'People', value: 3, fullMark: 5 },
    { subject: 'Data', value: 3.5, fullMark: 5 },
    { subject: 'Use Cases', value: 4.5, fullMark: 5 },
    { subject: 'Processes', value: 2.5, fullMark: 5 },
    { subject: 'Compliance', value: 3, fullMark: 5 },
    { subject: 'Tech', value: 4, fullMark: 5 },
  ];

  const outcomes = [
    {
      icon: Award,
      title: 'Maturity Score',
      description: 'An overall index from 1 to 5.',
    },
    {
      icon: TrendingUp,
      title: 'Cluster Badge',
      description: 'Are you a Curious Experimenter or an AI-Enabled Leader?',
    },
    {
      icon: Target,
      title: 'Gap Analysis',
      description: 'Deep dive into which dimension is holding you back.',
    },
    {
      icon: Zap,
      title: 'Next Steps',
      description: 'Immediate \'Low-Hanging Fruit\' vs. Long-term strategic shifts.',
    },
  ];

  return (
    <section className="py-20 px-6 bg-gradient-to-br from-gray-50 to-blue-50">
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">The Outcome Preview</h2>
          <p className="text-xl text-gray-600">Your results page will include:</p>
        </div>

        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            whileInView={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.6 }}
            viewport={{ once: true }}
            className="bg-white rounded-2xl shadow-xl p-8"
          >
            <h3 className="text-2xl font-semibold text-gray-900 mb-6 text-center">
              Your AI Maturity Radar
            </h3>
            <ResponsiveContainer width="100%" height={400}>
              <RadarChart data={radarData}>
                <PolarGrid stroke="#e5e7eb" />
                <PolarAngleAxis dataKey="subject" tick={{ fill: '#6b7280', fontSize: 14 }} />
                <PolarRadiusAxis angle={90} domain={[0, 5]} tick={{ fill: '#9ca3af', fontSize: 12 }} />
                <Radar
                  name="AI Maturity"
                  dataKey="value"
                  stroke="#3b82f6"
                  fill="#3b82f6"
                  fillOpacity={0.6}
                />
              </RadarChart>
            </ResponsiveContainer>
          </motion.div>

          <div className="space-y-6">
            {outcomes.map((outcome, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, x: 20 }}
                whileInView={{ opacity: 1, x: 0 }}
                transition={{ duration: 0.5, delay: index * 0.1 }}
                viewport={{ once: true }}
                className="flex gap-4 bg-white rounded-xl p-6 shadow-lg hover:shadow-xl transition-shadow"
              >
                <div className="flex-shrink-0">
                  <div className="w-12 h-12 bg-gradient-to-br from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
                    <outcome.icon className="w-6 h-6 text-white" />
                  </div>
                </div>
                <div>
                  <h4 className="font-semibold text-gray-900 mb-1">{outcome.title}</h4>
                  <p className="text-gray-600 text-sm">{outcome.description}</p>
                </div>
              </motion.div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}



**Section E** CTA: Ready to discover your AI Maturity? [Start Now]
Use the following code:
import { motion } from 'motion/react';
import { ArrowRight } from 'lucide-react';

export function CTASection() {
  return (
    <section className="py-20 px-6 bg-gradient-to-r from-blue-600 to-purple-600">
      <div className="max-w-4xl mx-auto text-center">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.6 }}
          viewport={{ once: true }}
        >
          <h2 className="text-4xl font-bold text-white mb-6">
            Ready to discover your AI Maturity?
          </h2>
          <p className="text-xl text-blue-100 mb-8">
            Join 500+ organizations that have already mapped their AI journey
          </p>
          <button className="group bg-white text-blue-600 px-10 py-5 rounded-lg text-lg font-semibold hover:shadow-2xl transition-all inline-flex items-center gap-3">
            Start Now
            <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
          </button>
        </motion.div>
      </div>
    </section>
  );
}
