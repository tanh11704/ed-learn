// import React from 'react';
// import { LayoutGrid, BookOpen, Clock, MoreVertical, Play } from 'lucide-react';
// import { QuestionTopic } from '../types';

// interface SubjectGridProps {
//   topics: QuestionTopic[];
//   onSelectTopic: (topic: QuestionTopic) => void;
// }

// export default function SubjectGrid({ topics, onSelectTopic }: SubjectGridProps) {
//   return (
//     <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
//       {topics.map((topic) => (
//         <div 
//           key={topic.id}
//           onClick={() => onSelectTopic(topic)}
//           className="group relative bg-card border border-border rounded-[28px] p-6 hover:border-border transition-all cursor-pointer shadow-xl"
//         >
//           {/* Icon & Menu */}
//           <div className="flex justify-between items-start mb-6">
//             <div className={`p-3 rounded-2xl ${topic.iconColor} bg-opacity-10 border border-current border-opacity-20`}>
//               <BookOpen size={24} className={topic.iconColor.replace('bg-', 'text-')} />
//             </div>
//             <button className="text-muted-foreground hover:text-foreground transition-colors">
//               <MoreVertical size={20} />
//             </button>
//           </div>

//           {/* Info */}
//           <div className="mb-6">
//             <h3 className="text-foreground text-xl font-bold mb-3 group-hover:text-primary transition-colors">
//               {topic.title}
//             </h3>
//             <div className="flex items-center gap-3">
//               <span className="text-[11px] font-bold px-2.5 py-1 bg-muted text-muted-foreground rounded-lg tracking-wider uppercase border border-border/50">
//                 {topic.subject}
//               </span>
//               <span className="text-muted-foreground text-sm flex items-center gap-1.5">
//                 <LayoutGrid size={14} /> {topic.questionCount} câu hỏi
//               </span>
//             </div>
//           </div>

//           {/* Footer */}
//           <div className="flex items-center justify-between pt-4 border-t border-border/80 text-[12px] text-muted-foreground">
//             <span className="flex items-center gap-1.5">
//               <Clock size={14} /> {topic.createdAt}
//             </span>
//             <span className="bg-muted/50 px-3 py-1 rounded-full border border-border/30">
//               {topic.author}
//             </span>
//           </div>

//           {/* Hover Overlay - Hiện nút "Vào học/Quản lý" */}
//           <div className="absolute inset-0 bg-black/40 backdrop-blur-[2px] rounded-[28px] opacity-0 group-hover:opacity-100 transition-all flex items-center justify-center">
//              <div className="bg-white text-black font-bold px-6 py-3 rounded-2xl flex items-center gap-2 shadow-2xl scale-90 group-hover:scale-100 transition-transform">
//                <Play size={18} fill="black" /> Mở chủ đề
//              </div>
//           </div>
//         </div>
//       ))}
//     </div>
//   );
// }