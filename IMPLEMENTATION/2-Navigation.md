The header shall be displayed as followed, use the following code:
import { Compass } from 'lucide-react';

export function Navigation() {
  return (
    <nav className="fixed top-0 left-0 right-0 bg-white/90 backdrop-blur-sm z-50 border-b border-gray-200">
      <div className="max-w-7xl mx-auto px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="bg-gradient-to-br from-blue-600 to-purple-600 p-2 rounded-lg">
            <Compass className="w-6 h-6 text-white" />
          </div>
          <span className="text-xl font-semibold text-gray-900">AI Compass</span>
        </div>
        <div className="flex items-center gap-6">
          <a href="#how-it-works" className="text-gray-600 hover:text-gray-900 transition-colors">
            How it works
          </a>
          <a href="#benefits" className="text-gray-600 hover:text-gray-900 transition-colors">
            Benefits
          </a>
          <button className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors">
            Get Started
          </button>
        </div>
      </div>
    </nav>
  );
}
