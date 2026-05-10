import React from 'react';
import { Pencil, Trash2, CheckCircle2 } from 'lucide-react';
import { Question } from '../types';

export default function QuestionList({ questions }: { questions: Question[] }) {
  return (
    <div className="flex flex-col gap-3">
      {questions.map((q, index) => (
        <div key={q.id} className="group bg-card border border-border rounded-2xl p-5 hover:border-border transition-all flex items-center gap-6">
          <div className="w-10 h-10 rounded-full bg-muted flex items-center justify-center text-muted-foreground font-bold text-sm border border-border">
            {index + 1}
          </div>
          
          <div className="flex-1">
            <p className="text-foreground font-medium mb-3 line-clamp-1">{q.content}</p>
            <div className="flex items-center gap-3">
              <span className="text-[10px] px-2 py-0.5 bg-muted text-muted-foreground rounded border border-border">{q.subject}</span>
              <span className={`text-[10px] px-2 py-0.5 rounded border ${
                q.level === 'Nhận biết' ? 'text-green-400 border-green-400/20 bg-green-400/5' : 'text-orange-400 border-orange-400/20 bg-orange-400/5'
              }`}>{q.level}</span>
              <span className="text-[10px] px-2 py-0.5 bg-muted text-muted-foreground rounded border border-border">{q.type}</span>
              <span className="flex items-center gap-1 text-[10px] text-emerald-400 ml-2">
                <CheckCircle2 size={12}/> {q.status}
              </span>
            </div>
          </div>

          <div className="flex items-center gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
            <button className="p-2 hover:bg-muted rounded-lg text-muted-foreground hover:text-foreground"><Pencil size={18}/></button>
            <button className="p-2 hover:bg-red-500/10 rounded-lg text-red-500"><Trash2 size={18}/></button>
          </div>
        </div>
      ))}
    </div>
  );
}