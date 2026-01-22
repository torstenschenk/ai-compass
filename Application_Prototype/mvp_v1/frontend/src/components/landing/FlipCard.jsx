import React, { useState } from 'react';
import { motion } from 'framer-motion';

export function FlipCard({ title, icon: Icon, what, why, index }) {
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
                    style={{ backfaceVisibility: 'hidden', WebkitBackfaceVisibility: 'hidden' }}
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
                        WebkitBackfaceVisibility: 'hidden',
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
