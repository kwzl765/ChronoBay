import { Link } from 'react-router-dom';
import type { ReactNode } from 'react';

interface EmptyStateProps {
  icon: ReactNode;
  title: string;
  description: string;
  actionLabel?: string;
  actionTo?: string;
}

export default function EmptyState({
  icon,
  title,
  description,
  actionLabel,
  actionTo,
}: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center rounded border border-dashed border-gray-300 bg-gray-50 px-6 py-16 text-center">
      <div className="flex h-16 w-16 items-center justify-center rounded bg-gray-200 text-gray-400">
        {icon}
      </div>
      <h1 className="mt-4 text-lg font-semibold text-charcoal">{title}</h1>
      <p className="mt-1 max-w-sm text-sm text-gray-500">{description}</p>
      {actionLabel && actionTo && (
        <Link to={actionTo} className="btn-primary mt-6">
          {actionLabel}
        </Link>
      )}
    </div>
  );
}
