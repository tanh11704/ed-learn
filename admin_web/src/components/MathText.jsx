import katex from 'katex';
import 'katex/dist/katex.min.css';

const mathPattern = /(\\\[[\s\S]*?\\\]|\\\([\s\S]*?\\\)|\$\$[\s\S]*?\$\$|\$[^$\n]+\$)/g;

function parseMathToken(token) {
  if (token.startsWith('\\(') && token.endsWith('\\)')) {
    return { value: token.slice(2, -2), displayMode: false };
  }
  if (token.startsWith('\\[') && token.endsWith('\\]')) {
    return { value: token.slice(2, -2), displayMode: true };
  }
  if (token.startsWith('$$') && token.endsWith('$$')) {
    return { value: token.slice(2, -2), displayMode: true };
  }
  if (token.startsWith('$') && token.endsWith('$')) {
    return { value: token.slice(1, -1), displayMode: false };
  }
  return null;
}

function renderMath(token) {
  const parsed = parseMathToken(token);
  if (!parsed) return null;

  try {
    return katex.renderToString(parsed.value, {
      displayMode: parsed.displayMode,
      throwOnError: false,
      strict: false,
    });
  } catch {
    return null;
  }
}

export default function MathText({ children, as: Tag = 'span', className = '' }) {
  const text = children == null ? '' : String(children);
  const parts = text.split(mathPattern).filter((part) => part !== '');

  return (
    <Tag className={className}>
      {parts.map((part, index) => {
        const html = renderMath(part);
        if (!html) return <span key={`${part}-${index}`}>{part}</span>;
        return (
          <span
            key={`${part}-${index}`}
            className="math-text-fragment"
            dangerouslySetInnerHTML={{ __html: html }}
          />
        );
      })}
    </Tag>
  );
}
