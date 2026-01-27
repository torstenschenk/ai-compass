import type { DimensionProgress as DimensionProgressType } from '@/types/questionnaire';
import { cn } from '@/components/ui/utils';
import { Check } from 'lucide-react';

interface DimensionProgressProps {
    progress: DimensionProgressType[];
    currentDimensionId?: number;
}

export function DimensionProgress({ progress, currentDimensionId }: DimensionProgressProps) {
    return (
        <div className="hidden lg:block w-64 shrink-0 space-y-8 pr-8 border-r border-gray-100">
            <div className="space-y-4">
                <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider">
                    Your Progress
                </h3>

                <div className="space-y-2">
                    {progress.filter(d => d.name !== 'General Psychology').map((dim) => {
                        const isActive = dim.dimensionId === currentDimensionId;
                        const percent = dim.requiredTotal > 0
                            ? Math.round((dim.requiredAnswered / dim.requiredTotal) * 100)
                            : 0;

                        return (
                            <div
                                key={dim.dimensionId}
                                className={cn(
                                    "p-3 rounded-lg transition-all duration-200",
                                    isActive ? "bg-blue-50" : "bg-transparent"
                                )}
                            >
                                <div className="flex items-center justify-between mb-2">
                                    <span className={cn(
                                        "text-sm font-medium",
                                        isActive ? "text-blue-700" : "text-gray-600",
                                        dim.requiredComplete && "text-gray-900"
                                    )}>
                                        {dim.name}
                                    </span>
                                    {dim.requiredComplete && (
                                        <Check className="w-4 h-4 text-green-500" />
                                    )}
                                </div>
                                <div className="h-1.5 w-full bg-gray-100 rounded-full overflow-hidden">
                                    <div
                                        className={cn(
                                            "h-full transition-all duration-500 ease-out rounded-full",
                                            dim.requiredComplete ? "bg-green-500" : "bg-blue-600"
                                        )}
                                        style={{ width: `${percent}%` }}
                                    />
                                </div>
                            </div>
                        );
                    })}
                </div>
            </div>
        </div>
    );
}
