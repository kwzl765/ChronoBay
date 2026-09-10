import { Link } from 'react-router-dom';

interface LogoProps {
  variant?: 'dark' | 'light';
  className?: string;
}

export default function Logo({ variant = 'dark', className = '' }: LogoProps) {
  const textColor = variant === 'light' ? 'text-white' : 'text-navy-600';
  const subColor = variant === 'light' ? 'text-gray-300' : 'text-charcoal-muted';

  return (
    <Link
      to="/"
      className={`flex items-center gap-2 ${className}`}
      aria-label="ChronoBay home"
    >
      <span className="flex h-9 w-9 items-center justify-center rounded bg-navy-600">
        <svg viewBox="0 0 32 32" className="h-6 w-6" fill="none" aria-hidden="true">
          <circle cx="16" cy="16" r="9" stroke="#F58220" strokeWidth="2.5" />
          <line x1="16" y1="16" x2="16" y2="10" stroke="#F58220" strokeWidth="2.5" strokeLinecap="round" />
          <line x1="16" y1="16" x2="20" y2="16" stroke="#F58220" strokeWidth="2.5" strokeLinecap="round" />
        </svg>
      </span>
      <span className="flex flex-col leading-none">
        <span className={`text-xl font-extrabold tracking-tight ${textColor}`}>
          Chrono<span className="text-accent">Bay</span>
        </span>
        <span className={`hidden text-[10px] font-medium uppercase tracking-[0.15em] ${subColor} sm:block`}>
          Official Watch Store
        </span>
      </span>
    </Link>
  );
}
