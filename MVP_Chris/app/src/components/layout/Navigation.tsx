import { useNavigate } from 'react-router-dom';
import { compassLogo } from '@/assets/compassLogo';

export function Navigation() {
    const navigate = useNavigate();

    return (
        <nav className="fixed w-full bg-white/80 backdrop-blur-md z-50 border-b border-gray-100">
            <div className="max-w-7xl mx-auto px-6 h-20 flex items-center justify-between">
                <div
                    className="flex items-center gap-2 font-bold text-2xl text-gray-900 cursor-pointer"
                    onClick={() => navigate('/')}
                >
                    <div className="w-8 h-8 flex items-center justify-center">
                        <img src={compassLogo} alt="AI Compass" className="w-full h-full object-contain" />
                    </div>
                    Compass
                </div>


            </div>
        </nav>
    );
}
