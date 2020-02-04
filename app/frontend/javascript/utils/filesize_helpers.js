function formatFilesize(bytes, decimalPoint) {
  if (bytes === 0) {
    return '0 Bytes';
  }

  const base = 1024;
  // eslint-disable-next-line no-magic-numbers
  const dm = decimalPoint || 2;
  const sizes = [
    'Bytes',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB'
  ];

  // Log(base)(bytes) => log(e)(bytes) / log(e)(base)
  const magnitude = Math.floor(Math.log(bytes) / Math.log(base));

  const value = parseFloat((bytes / Math.pow(base, magnitude)).toFixed(dm));
  const unit = sizes[magnitude];

  return `${value} ${unit}`;
}

export { formatFilesize };
