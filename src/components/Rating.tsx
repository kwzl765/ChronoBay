import { Star } from 'lucide-react';

interface RatingProps {
  rating: number;
  reviewCount?: number;
  size?: 'sm' | 'md';
  showCount?: boolean;
}

export default function Rating({
  rating,
  reviewCount,
  size = 'sm',
  showCount = true,
}: RatingProps) {
  const starSize = size === 'sm' ? 'h-3.5 w-3.5' : 'h-4 w-4';
  const fullStars = Math.floor(rating);
  const hasHalf = rating % 1 >= 0.5;

  return (
    <div className="flex items-center gap-1">
      <div className="flex items-center" aria-label={`Rated ${rating} out of 5`}>
        {Array.from({ length: 5 }).map((_, i) => {
          const filled = i < fullStars;
          const half = i === fullStars && hasHalf;
          return (
            <Star
              key={i}
              className={`${starSize} ${
                filled || half ? 'fill-accent text-accent' : 'fill-gray-200 text-gray-200'
              }`}
              aria-hidden="true"
            />
          );
        })}
      </div>
      {showCount && reviewCount !== undefined && (
        <span className="text-xs text-gray-400">({reviewCount})</span>
      )}
    </div>
  );
}
