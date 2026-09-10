import { Link } from 'react-router-dom';
import { Home, ArrowLeft } from 'lucide-react';
import Seo from '@/components/Seo';

export default function NotFoundPage() {
  return (
    <>
      <Seo title="Page Not Found — ChronoBay" description="The page you are looking for does not exist." />
      <div className="flex min-h-[60vh] items-center justify-center bg-gray-50 py-20">
        <div className="text-center">
          <p className="text-7xl font-extrabold text-navy-600 sm:text-8xl">404</p>
          <div className="mt-4 flex justify-center">
            <span className="h-1 w-16 bg-accent" aria-hidden="true" />
          </div>
          <h1 className="mt-6 text-xl font-bold text-charcoal sm:text-2xl">
            Page Not Found
          </h1>
          <p className="mx-auto mt-3 max-w-md text-sm text-gray-500">
            The page you are looking for might have been removed, had its name changed,
            or is temporarily unavailable.
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Link to="/" className="btn-primary">
              <Home className="h-4 w-4" />
              Back to Home
            </Link>
            <Link to="/shop" className="btn-secondary">
              <ArrowLeft className="h-4 w-4" />
              Browse Watches
            </Link>
          </div>
        </div>
      </div>
    </>
  );
}
