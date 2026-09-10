import { CheckCircle2, XCircle, Info, X } from 'lucide-react';
import { useShop } from '@/context/ShopContext';

const iconMap = {
  success: CheckCircle2,
  error: XCircle,
  info: Info,
};

const colorMap = {
  success: 'text-green-600',
  error: 'text-red-600',
  info: 'text-navy-600',
};

export default function ToastContainer() {
  const { toasts, dismissToast } = useShop();

  return (
    <div
      className="fixed bottom-4 right-4 z-[100] flex flex-col gap-2"
      aria-live="polite"
      aria-atomic="true"
    >
      {toasts.map((toast) => {
        const Icon = iconMap[toast.type];
        return (
          <div
            key={toast.id}
            className="flex items-center gap-3 rounded bg-white px-4 py-3 shadow-card-hover animate-slideUp min-w-[260px] max-w-[360px]"
            role="status"
          >
            <Icon className={`h-5 w-5 shrink-0 ${colorMap[toast.type]}`} aria-hidden="true" />
            <p className="flex-1 text-sm text-charcoal">{toast.message}</p>
            <button
              onClick={() => dismissToast(toast.id)}
              className="shrink-0 rounded p-1 text-gray-400 hover:bg-gray-100 hover:text-charcoal"
              aria-label="Dismiss notification"
            >
              <X className="h-4 w-4" />
            </button>
          </div>
        );
      })}
    </div>
  );
}
