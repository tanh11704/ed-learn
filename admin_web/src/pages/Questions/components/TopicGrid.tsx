import React from 'react';
import { BookOpen, MoreVertical, LayoutGrid, Clock } from 'lucide-react';
import { Topic } from '../types';

interface TopicGridProps {
  topics: Topic[];
  onSelect: (topic: Topic) => void;
}

export default function TopicGrid({ topics, onSelect }: TopicGridProps) {
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      {topics.map((topic) => (
        <div 
          key={topic.id}
          onClick={() => onSelect(topic)}
          className="group bg-card border border-border rounded-[24px] p-6 hover:border-primary/50 transition-all cursor-pointer relative"
        >
          <div className="flex justify-between items-start mb-6">
            <div className="p-3 bg-primary-subtle rounded-2xl border border-primary/20 text-primary">
              <BookOpen size={24} />
            </div>
            <button className="text-muted-foreground hover:text-foreground"><MoreVertical size={20}/></button>
          </div>
          
          <h3 className="text-xl font-bold text-foreground mb-2 group-hover:text-primary transition-colors line-clamp-1">
            {topic.title}
          </h3>
          
          <div className="flex items-center gap-3 mb-6">
            <span className="text-[10px] font-bold px-2 py-1 bg-muted text-muted-foreground rounded uppercase border border-border">
              {topic.category}
            </span>
            <span className="text-muted-foreground text-xs flex items-center gap-1">
              <LayoutGrid size={14}/> {topic.count} câu hỏi
            </span>
          </div>

          <div className="flex justify-between items-center pt-4 border-t border-border text-[11px] text-muted-foreground">
            <span className="flex items-center gap-1"><Clock size={12}/> {topic.updatedAt}</span>
            <span className="bg-muted px-2 py-0.5 rounded">{topic.author}</span>
          </div>
        </div>
      ))}
    </div>
  );
}