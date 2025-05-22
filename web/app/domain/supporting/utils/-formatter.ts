export function formatNumber(value: number, options?: Intl.NumberFormatOptions) {
  const formatter = new Intl.NumberFormat('de-DE', options);

  return formatter.format(value);
}

export function formatPercent(value: number, options?: Intl.NumberFormatOptions) {
  return formatNumber(value, {
    style: 'percent',
    ...options
  });
}

export function formatSeconds(duration: number, options?: Intl.NumberFormatOptions) {
  return formatNumber(duration, {
    style: 'unit',
    unit: 'second',
    maximumFractionDigits: 0,
    ...options
  });
}

export function formatIndicator(value: number, options?: Intl.NumberFormatOptions) {
  return formatNumber(value, {
    maximumFractionDigits: 2,
    roundingMode: 'trunc',
    ...options
  });
}
