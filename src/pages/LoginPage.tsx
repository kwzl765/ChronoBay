import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, Eye, EyeOff, User, ArrowRight, AlertCircle, Loader2 } from 'lucide-react';
import Seo from '@/components/Seo';
import { useShop } from '@/context/ShopContext';
import { useAuth } from '@/context/AuthContext';

export default function LoginPage() {
  const { showToast } = useShop();
  const { signInWithEmail, signUpWithEmail, signInWithGoogle } = useAuth();
  const navigate = useNavigate();
  const [mode, setMode] = useState<'login' | 'register'>('login');
  const [showPassword, setShowPassword] = useState(false);
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [name, setName] = useState('');
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [authError, setAuthError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setAuthError(null);
    const newErrors: Record<string, string> = {};

    if (mode === 'register' && !name.trim()) {
      newErrors.name = 'Name is required';
    }
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      newErrors.email = 'Please enter a valid email address';
    }
    if (password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
    }

    setErrors(newErrors);
    if (Object.keys(newErrors).length > 0) return;

    setSubmitting(true);
    try {
      if (mode === 'login') {
        const { error } = await signInWithEmail(email, password);
        if (error) {
          setAuthError(error);
          return;
        }
        showToast('success', 'Welcome back to ChronoBay!');
        navigate('/');
      } else {
        const { error } = await signUpWithEmail(email, password, name);
        if (error) {
          setAuthError(error);
          return;
        }
        showToast('success', 'Account created successfully!');
        navigate('/');
      }
    } finally {
      setSubmitting(false);
    }
  };

  const handleGoogle = async () => {
    setAuthError(null);
    setGoogleLoading(true);
    try {
      const { error } = await signInWithGoogle();
      if (error) {
        setAuthError(error);
        setGoogleLoading(false);
      }
    } catch {
      setGoogleLoading(false);
    }
  };

  return (
    <>
      <Seo
        title={mode === 'login' ? 'Sign In — ChronoBay' : 'Create Account — ChronoBay'}
        description="Sign in to your ChronoBay account or create a new one to track orders and save favorites."
      />
      <div className="flex min-h-[calc(100vh-200px)] items-center justify-center bg-gray-50 py-12">
        <div className="w-full max-w-md">
          <div className="rounded border border-gray-200 bg-white p-8 shadow-card">
            {/* Tabs */}
            <div className="mb-6 flex rounded bg-gray-100 p-1">
              <button
                onClick={() => { setMode('login'); setAuthError(null); }}
                className={`flex-1 rounded py-2 text-sm font-medium transition-colors ${
                  mode === 'login' ? 'bg-white text-charcoal shadow-sm' : 'text-gray-500'
                }`}
              >
                Sign In
              </button>
              <button
                onClick={() => { setMode('register'); setAuthError(null); }}
                className={`flex-1 rounded py-2 text-sm font-medium transition-colors ${
                  mode === 'register' ? 'bg-white text-charcoal shadow-sm' : 'text-gray-500'
                }`}
              >
                Create Account
              </button>
            </div>

            <h1 className="text-xl font-bold text-navy-600">
              {mode === 'login' ? 'Welcome Back' : 'Join ChronoBay'}
            </h1>
            <p className="mt-1 text-sm text-gray-500">
              {mode === 'login'
                ? 'Sign in to access your account, orders, and wishlist.'
                : 'Create an account to start your watch journey.'}
            </p>

            {authError && (
              <div className="mt-4 flex items-start gap-2 rounded border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
                <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
                <span>{authError}</span>
              </div>
            )}

            {/* Google sign-in */}
            <button
              onClick={handleGoogle}
              disabled={googleLoading || submitting}
              className="mt-5 flex w-full items-center justify-center gap-3 rounded border border-gray-300 bg-white py-2.5 text-sm font-medium text-charcoal transition-colors hover:bg-gray-50 disabled:opacity-60"
            >
              {googleLoading ? (
                <Loader2 className="h-5 w-5 animate-spin text-gray-400" />
              ) : (
                <svg className="h-5 w-5" viewBox="0 0 24 24" aria-hidden="true">
                  <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
                  <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
                  <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" />
                  <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84C6.71 7.31 9.14 5.38 12 5.38z" />
                </svg>
              )}
              Continue with Google
            </button>

            {/* Divider */}
            <div className="my-5 flex items-center gap-3">
              <div className="h-px flex-1 bg-gray-200" />
              <span className="text-xs text-gray-400">or</span>
              <div className="h-px flex-1 bg-gray-200" />
            </div>

            <form onSubmit={handleSubmit} className="space-y-4" noValidate>
              {mode === 'register' && (
                <div>
                  <label htmlFor="name" className="block text-sm font-medium text-charcoal mb-1.5">
                    Full Name
                  </label>
                  <div className="relative">
                    <User className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" aria-hidden="true" />
                    <input
                      id="name"
                      type="text"
                      value={name}
                      onChange={(e) => setName(e.target.value)}
                      className="input-base pl-10"
                      placeholder="John Doe"
                      aria-invalid={!!errors.name}
                      autoComplete="name"
                    />
                  </div>
                  {errors.name && <p className="mt-1 text-xs text-red-600">{errors.name}</p>}
                </div>
              )}

              <div>
                <label htmlFor="email" className="block text-sm font-medium text-charcoal mb-1.5">
                  Email Address
                </label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" aria-hidden="true" />
                  <input
                    id="email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="input-base pl-10"
                    placeholder="your@email.com"
                    aria-invalid={!!errors.email}
                    autoComplete="email"
                  />
                </div>
                {errors.email && <p className="mt-1 text-xs text-red-600">{errors.email}</p>}
              </div>

              <div>
                <label htmlFor="password" className="block text-sm font-medium text-charcoal mb-1.5">
                  Password
                </label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" aria-hidden="true" />
                  <input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    className="input-base pl-10 pr-10"
                    placeholder="••••••••"
                    aria-invalid={!!errors.password}
                    autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-charcoal"
                    aria-label={showPassword ? 'Hide password' : 'Show password'}
                  >
                    {showPassword ? <EyeOff className="h-5 w-5" /> : <Eye className="h-5 w-5" />}
                  </button>
                </div>
                {errors.password && <p className="mt-1 text-xs text-red-600">{errors.password}</p>}
              </div>

              {mode === 'login' && (
                <div className="flex items-center justify-between">
                  <label className="flex items-center gap-2 text-sm text-gray-500">
                    <input type="checkbox" className="h-4 w-4 rounded border-gray-300 text-accent focus:ring-accent" />
                    Remember me
                  </label>
                  <button type="button" className="text-sm font-medium text-accent hover:underline">
                    Forgot password?
                  </button>
                </div>
              )}

              <button type="submit" disabled={submitting || googleLoading} className="btn-primary w-full">
                {submitting ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <>
                    {mode === 'login' ? 'Sign In' : 'Create Account'}
                    <ArrowRight className="h-4 w-4" />
                  </>
                )}
              </button>
            </form>

            <p className="mt-6 text-center text-sm text-gray-500">
              {mode === 'login' ? "Don't have an account? " : 'Already have an account? '}
              <button
                onClick={() => { setMode(mode === 'login' ? 'register' : 'login'); setAuthError(null); }}
                className="font-medium text-accent hover:underline"
              >
                {mode === 'login' ? 'Create one' : 'Sign in'}
              </button>
            </p>
          </div>

          <p className="mt-4 text-center text-xs text-gray-400">
            <Link to="/" className="hover:text-accent">← Back to home</Link>
          </p>
        </div>
      </div>
    </>
  );
}
