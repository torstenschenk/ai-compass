import { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { useNavigate } from 'react-router-dom';
import { Button } from '@/components/ui/button';
import {
    Form,
    FormControl,
    FormField,
    FormItem,
    FormLabel,
    FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';

import { Navigation } from '@/components/layout/Navigation';
import { Footer } from '@/components/layout/Footer';

const formSchema = z.object({
    companyName: z.string().min(2, {
        message: "Company name must be at least 2 characters.",
    }),
    industry: z.string().min(1, { message: "Please select an industry." }),
    website: z.string().url().optional().or(z.literal('')),
    employeeBand: z.string().min(1, { message: "Please select an employee band." }),
    city: z.string().optional(),
    email: z.string().email().optional().or(z.literal('')),
});

const industries = [
    "Manufacturing",
    "Retail",
    "Healthcare",
    "Finance",
    "Services",
    "Logistics",
    "IT/Software",
    "Other"
];

const employeeBands = [
    "1-10",
    "11-50",
    "51-250",
    "251-1000",
    "1000+"
];

export function CompanySnapshot() {
    const navigate = useNavigate();
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const form = useForm<z.infer<typeof formSchema>>({
        resolver: zodResolver(formSchema),
        defaultValues: {
            companyName: "",
            website: "",
            city: "",
            email: "",
        },
    });

    async function onSubmit(values: z.infer<typeof formSchema>) {
        setLoading(true);
        setError(null);

        try {
            // Use local dev server URL - update this for production later
            const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8000';

            const payload = {
                company: {
                    company_name: values.companyName,
                    industry: values.industry,
                    website: values.website || null,
                    number_of_employees: values.employeeBand,
                    city: values.city || null,
                    email: values.email || null,
                }
            };

            const response = await fetch(`${apiUrl}/api/v1/responses`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(payload),
            });

            if (!response.ok) {
                throw new Error('Failed to create assessment session');
            }

            const data = await response.json();

            // Store token and ID
            localStorage.setItem(`ai_compass_access_token:${data.response_id}`, data.access_token);

            // Navigate to questionnaire with response ID
            navigate(`/questionnaire?responseId=${data.response_id}`);

        } catch (err) {
            setError(err instanceof Error ? err.message : 'An error occurred');
            console.error(err);
        } finally {
            setLoading(false);
        }
    }

    return (
        <div className="min-h-screen bg-gray-50">
            <Navigation />

            <main className="container max-w-2xl mx-auto pt-32 pb-16 px-6">
                <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 md:p-12">
                    <div className="mb-8 text-center">
                        <h1 className="text-3xl font-bold text-gray-900 mb-2">Start Assessment</h1>
                        <p className="text-gray-600">Tell us a bit about your company to get started.</p>
                    </div>

                    <Form {...form}>
                        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-6">

                            <FormField
                                control={form.control}
                                name="companyName"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Company Name</FormLabel>
                                        <FormControl>
                                            <Input placeholder="Acme Ltd" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <FormField
                                    control={form.control}
                                    name="industry"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Industry</FormLabel>
                                            <Select onValueChange={field.onChange} defaultValue={field.value}>
                                                <FormControl>
                                                    <SelectTrigger>
                                                        <SelectValue placeholder="Select industry" />
                                                    </SelectTrigger>
                                                </FormControl>
                                                <SelectContent>
                                                    {industries.map((ind) => (
                                                        <SelectItem key={ind} value={ind}>{ind}</SelectItem>
                                                    ))}
                                                </SelectContent>
                                            </Select>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="employeeBand"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Employees</FormLabel>
                                            <Select onValueChange={field.onChange} defaultValue={field.value}>
                                                <FormControl>
                                                    <SelectTrigger>
                                                        <SelectValue placeholder="Select range" />
                                                    </SelectTrigger>
                                                </FormControl>
                                                <SelectContent>
                                                    {employeeBands.map((band) => (
                                                        <SelectItem key={band} value={band}>{band}</SelectItem>
                                                    ))}
                                                </SelectContent>
                                            </Select>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />
                            </div>

                            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <FormField
                                    control={form.control}
                                    name="website"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>Website <span className="text-gray-400 font-normal">(Optional)</span></FormLabel>
                                            <FormControl>
                                                <Input placeholder="https://acme.com" {...field} />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />

                                <FormField
                                    control={form.control}
                                    name="city"
                                    render={({ field }) => (
                                        <FormItem>
                                            <FormLabel>City <span className="text-gray-400 font-normal">(Optional)</span></FormLabel>
                                            <FormControl>
                                                <Input placeholder="Berlin" {...field} />
                                            </FormControl>
                                            <FormMessage />
                                        </FormItem>
                                    )}
                                />
                            </div>

                            <FormField
                                control={form.control}
                                name="email"
                                render={({ field }) => (
                                    <FormItem>
                                        <FormLabel>Email <span className="text-gray-400 font-normal">(Optional)</span></FormLabel>
                                        <FormControl>
                                            <Input placeholder="contact@acme.com" {...field} />
                                        </FormControl>
                                        <FormMessage />
                                    </FormItem>
                                )}
                            />

                            {error && (
                                <div className="p-3 text-sm text-red-600 bg-red-50 rounded-lg">
                                    {error}
                                </div>
                            )}

                            <Button type="submit" className="w-full h-12 text-base font-medium" disabled={loading}>
                                {loading ? "Creating Session..." : "Begin Assessment"}
                            </Button>
                        </form>
                    </Form>
                </div>
            </main>
            <Footer />
        </div>
    );
}
