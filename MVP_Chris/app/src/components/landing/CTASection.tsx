import { motion } from 'motion/react';
import { ArrowRight } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

export function CTASection() {
    const navigate = useNavigate();

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
                    <button
                        onClick={() => navigate('/company-snapshot')}
                        className="group bg-white text-blue-600 px-10 py-5 rounded-lg text-lg font-semibold hover:shadow-2xl transition-all inline-flex items-center gap-3 cursor-pointer"
                    >
                        Start Now
                        <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                    </button>
                </motion.div>
            </div>
        </section>
    );
}
