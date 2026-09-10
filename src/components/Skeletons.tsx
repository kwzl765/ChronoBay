export function ProductCardSkeleton() {
  return (
    <div className="flex flex-col bg-white">
      <div className="skeleton aspect-square" />
      <div className="space-y-2 py-3">
        <div className="skeleton h-3 w-16 rounded" />
        <div className="skeleton h-4 w-full rounded" />
        <div className="skeleton h-3 w-20 rounded" />
        <div className="skeleton h-5 w-28 rounded pt-1" />
      </div>
    </div>
  );
}

export function ProductGridSkeleton({ count = 8 }: { count?: number }) {
  return (
    <div className="grid grid-cols-2 gap-4 md:grid-cols-3 lg:grid-cols-4">
      {Array.from({ length: count }).map((_, i) => (
        <ProductCardSkeleton key={i} />
      ))}
    </div>
  );
}
