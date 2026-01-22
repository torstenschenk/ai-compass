'use client';

import { motion } from 'motion/react';
import { ArrowRight } from 'lucide-react';
import { Button } from '@/components/ui/button';

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
                    <Button className="group bg-white text-blue-600 px-10 py-6 rounded-lg text-lg font-semibold hover:shadow-2xl transition-all inline-flex items-center gap-3 h-auto">
                        Start Now
                        <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                    </Button>
                </motion.div>
            </div>
        </section>
    );
}
