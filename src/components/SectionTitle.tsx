interface SectionTitleProps {
  eyebrow?: string;
  title: string;
  link?: { label: string; to: string };
  centered?: boolean;
}

import { Link } from 'react-router-dom';
import { ArrowRight } from 'lucide-react';

export default function SectionTitle({
  eyebrow,
  title,
  link,
  centered = false,
}: SectionTitleProps) {
  return (
    <div
      className={`flex items-end justify-between gap-4 ${
        centered ? 'flex-col text-center' : ''
      }`}
    >
      <div className={centered ? 'flex flex-col items-center' : ''}>
        {eyebrow && (
          <div className={`flex items-center gap-2 ${centered ? 'justify-center' : ''}`}>
            <span className="h-px w-8 bg-accent" aria-hidden="true" />
            <span className="text-xs font-semibold uppercase tracking-[0.2em] text-accent">
              {eyebrow}
            </span>
            {centered && <span className="h-px w-8 bg-accent" aria-hidden="true" />}
          </div>
        )}
        <h2 className="mt-2 text-[26px] font-bold leading-tight text-navy-600 sm:text-[32px]">{title}</h2>
      </div>
      {link && !centered && (
        <Link
          to={link.to}
          className="group flex shrink-0 items-center gap-1 text-sm font-medium text-charcoal hover:text-accent transition-colors"
        >
          {link.label}
          <ArrowRight
            className="h-4 w-4 transition-transform group-hover:translate-x-1"
            aria-hidden="true"
          />
        </Link>
      )}
    </div>
  );
}
