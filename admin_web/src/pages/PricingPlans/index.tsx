import { Check } from 'lucide-react';
import { MOCK_PRICING_PLANS } from '../../mock/placeholders';

function formatVnd(n: number) {
  if (n === 0) return '0 ₫';
  return `${n.toLocaleString('vi-VN')} ₫`;
}

export default function PricingPlansPage() {
  return (
    <div className="space-y-6 max-w-6xl mx-auto pb-10">
      <div>
        <h1 className="text-2xl font-bold text-foreground tracking-tight">Gói cước &amp; dịch vụ</h1>
        <p className="text-muted-foreground text-sm mt-1">
          Bảng giá tham chiếu (mock). Khi có backend, đồng bộ từ cấu hình thanh toán.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {MOCK_PRICING_PLANS.map((plan) => (
          <div
            key={plan.id}
            className={`rounded-2xl border p-6 flex flex-col ${
              plan.highlight
                ? 'border-primary/50 bg-primary-subtle shadow-brand'
                : 'border-border bg-muted/50'
            }`}
          >
            <div className="flex items-center justify-between gap-2">
              <h2 className="text-lg font-semibold text-foreground">{plan.name}</h2>
              {plan.highlight && (
                <span className="text-[10px] font-bold uppercase tracking-wider text-primary bg-primary-subtle px-2 py-0.5 rounded-md border border-primary/30">
                  {plan.cta}
                </span>
              )}
            </div>
            <div className="mt-4">
              <p className="text-3xl font-bold text-foreground tabular-nums">{formatVnd(plan.priceMonthly)}</p>
              <p className="text-sm text-muted-foreground mt-1">/ tháng</p>
              <p className="text-sm text-muted-foreground mt-2">
                Hoặc <span className="text-foreground font-medium">{formatVnd(plan.priceYearly)}</span> / năm
              </p>
            </div>
            <ul className="mt-6 space-y-2 flex-1">
              {plan.features.map((f) => (
                <li key={f} className="flex gap-2 text-sm text-foreground/90">
                  <Check size={16} className="text-emerald-400 shrink-0 mt-0.5" />
                  {f}
                </li>
              ))}
            </ul>
            {!plan.highlight && (
              <p className="mt-6 text-xs text-muted-foreground border-t border-border pt-4">{plan.cta}</p>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}
