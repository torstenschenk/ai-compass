import { useState } from 'react';
import { motion } from 'motion/react';
import { type LucideIcon, CornerDownRight } from 'lucide-react';

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
            className="h-full"
            style={{ perspective: '1000px' }}
        >
            <motion.div
                className="relative w-full h-full cursor-pointer group grid place-items-stretch"
                style={{ transformStyle: 'preserve-3d' }}
                animate={{ rotateY: isFlipped ? 180 : 0 }}
                transition={{ duration: 0.6 }}
                onClick={() => setIsFlipped(!isFlipped)}
            >
                {/* Front */}
                <div
                    className="bg-white rounded-xl shadow-lg border border-gray-200 p-6 flex flex-col items-center justify-center text-center relative col-start-1 row-start-1 h-full min-h-[280px]"
                    style={{ backfaceVisibility: 'hidden' }}
                >
                    <div className="bg-gradient-to-br from-blue-100 to-purple-100 p-4 rounded-full mb-4">
                        <Icon className="w-8 h-8 text-blue-600" />
                    </div>
                    <h3 className="text-xl font-semibold text-gray-900">{title}</h3>

                    <CornerDownRight className="absolute bottom-4 right-4 w-5 h-5 text-gray-400 group-hover:text-blue-500 transition-colors" />
                </div>

                {/* Back */}
                <div
                    className="bg-gradient-to-br from-blue-600 to-purple-600 rounded-xl shadow-lg p-6 text-white col-start-1 row-start-1 h-full min-h-[280px]"
                    style={{
                        backfaceVisibility: 'hidden',
                        transform: 'rotateY(180deg)',
                    }}
                >
                    <div className="space-y-3 h-full flex flex-col justify-center">
                        <div>
                            <h4 className="font-semibold mb-1 text-blue-100 text-base">What it is:</h4>
                            <p className="text-[0.95rem] leading-snug">{what}</p>
                        </div>
                        <div>
                            <h4 className="font-semibold mb-1 text-blue-100 text-base">Why it's necessary:</h4>
                            <p className="text-[0.95rem] leading-snug">{why}</p>
                        </div>
                    </div>
                </div>
            </motion.div>
        </motion.div>
    );
}
