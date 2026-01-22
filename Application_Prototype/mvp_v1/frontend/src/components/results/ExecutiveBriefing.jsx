import React from 'react';
import { Card, CardContent } from "@/components/ui/card";
import { Quote } from 'lucide-react';
import { cn } from "@/lib/utils";

export function ExecutiveBriefing({ data }) {
    if (!data || !data.executive_briefing) return null;

    const briefing = data.executive_briefing;

    // Helper to format the markdown-like string to HTML
    // We handle ### headers and **bold** text specifically
    const formatBriefing = (text) => {
        if (!text) return "";

        let html = text
            // Replace the main header if it matches the specific pattern
            .replace(/### (.*?)\n/g, '<h3 class="text-xl font-bold text-primary mb-6 flex items-center gap-2">$1</h3>')
            // Handle bold text
            .replace(/\*\*(.*?)\*\*/g, '<strong class="text-slate-900 font-bold">$1</strong>')
            // Handle double newlines as paragraphs
            .split('\n\n')
            .map(para => {
                if (para.startsWith('<h3')) return para;
                return `<p class="mb-4 last:mb-0">${para.replace(/\n/g, '<br/>')}</p>`;
            })
            .join('');

        return html;
    };

    return (
        <section className="space-y-6">
            <div className="space-y-2">
                <h2 className="text-3xl font-bold tracking-tight text-primary">Executive Strategy Briefing</h2>
                <p className="text-muted-foreground text-lg">A concise synthesis of your strategic position and immediate priorities.</p>
            </div>

            <Card className="glass-premium overflow-hidden border-none relative">
                {/* Decorative background gradients for premium feel */}
                <div className="absolute top-0 right-0 w-96 h-96 bg-indigo-50/50 rounded-full -mr-48 -mt-48 blur-3xl pointer-events-none" />
                <div className="absolute bottom-0 left-0 w-64 h-64 bg-blue-50/50 rounded-full -ml-32 -mb-32 blur-3xl pointer-events-none" />

                <CardContent className="p-8 md:p-12 relative">
                    <div className="flex flex-col md:flex-row gap-8 items-start">
                        {/* Designer Quote Icon */}
                        <div className="hidden md:flex p-4 rounded-2xl bg-primary/5 text-primary/40 shrink-0 mt-2 border border-primary/10">
                            <Quote className="w-10 h-10 rotate-180" />
                        </div>

                        <div className="flex-1">
                            <div
                                className="text-slate-600 leading-relaxed text-lg font-medium"
                                dangerouslySetInnerHTML={{ __html: formatBriefing(briefing) }}
                            />

                            {/* Decorative line */}
                            <div className="mt-8 pt-8 border-t border-slate-100 flex items-center justify-between">
                                <span className="text-xs font-bold uppercase tracking-widest text-slate-400">AI-Compass Analysis Team</span>
                                <div className="flex gap-1">
                                    {[1, 2, 3].map(i => (
                                        <div key={i} className="w-1.5 h-1.5 rounded-full bg-primary/20" />
                                    ))}
                                </div>
                            </div>
                        </div>
                    </div>
                </CardContent>
            </Card>
        </section>
    );
}
