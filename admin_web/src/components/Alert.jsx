export default function Alert({ type = 'error', children, onClose }) {
  return (
    <div className={`alert alert-${type}`}>
      <span>{children}</span>
      {onClose && (
        <button type="button" className="alert-close" onClick={onClose}>
          ×
        </button>
      )}
    </div>
  );
}
