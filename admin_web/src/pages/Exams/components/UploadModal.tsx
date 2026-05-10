import { useState, useRef } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, UploadCloud, FileCheck } from 'lucide-react';

interface UploadModalProps {
  isOpen: boolean;
  onClose: () => void;
  onUpload: (file: File, subject: string) => void;
}

export default function UploadModal({ isOpen, onClose, onUpload }: UploadModalProps) {
  const [selectedFile, setSelectedFile] = useState<File | null>(null);
  const [isDragging, setIsDragging] = useState(false);
  const [uploadSubject, setUploadSubject] = useState('Toán học');
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleClose = () => {
    setSelectedFile(null);
    onClose();
  };

  const handleSubmit = () => {
    if (selectedFile) {
      onUpload(selectedFile, uploadSubject);
      handleClose();
    }
  };

  return (
    <AnimatePresence>
      {isOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center px-4">
          <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} onClick={handleClose} className="absolute inset-0 bg-black/60 backdrop-blur-sm" />
          <motion.div initial={{ opacity: 0, scale: 0.95, y: 20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.95, y: 20 }} className="relative w-full max-w-lg bg-sidebar border border-border rounded-2xl shadow-2xl overflow-hidden">
            <div className="flex items-center justify-between p-6 border-b border-border">
              <h3 className="text-lg font-bold text-foreground">Upload đề thi lên hệ thống</h3>
              <button onClick={handleClose} className="text-muted-foreground hover:text-foreground transition-colors"><X size={20} /></button>
            </div>

            <div className="p-6 space-y-5">
              <input type="file" ref={fileInputRef} className="hidden" accept=".pdf,.docx,.doc,.jpg,.png" onChange={(e) => { if (e.target.files?.length) setSelectedFile(e.target.files[0]); }} />
              <div 
                onClick={() => fileInputRef.current?.click()} 
                onDragOver={(e) => { e.preventDefault(); setIsDragging(true); }} 
                onDragLeave={() => setIsDragging(false)} 
                onDrop={(e) => { e.preventDefault(); setIsDragging(false); if (e.dataTransfer.files?.length) setSelectedFile(e.dataTransfer.files[0]); }}
                className={`border-2 border-dashed rounded-xl p-8 flex flex-col items-center justify-center text-center transition-all cursor-pointer group ${isDragging ? 'border-primary bg-primary-subtle' : 'border-border bg-muted hover:border-primary'}`}
              >
                {selectedFile ? (
                  <div className="flex flex-col items-center text-emerald-500">
                    <div className="w-12 h-12 bg-emerald-500/10 rounded-full flex items-center justify-center mb-4"><FileCheck size={24} /></div>
                    <p className="text-foreground font-medium mb-1 line-clamp-1 px-4">{selectedFile.name}</p>
                    <p className="text-xs text-muted-foreground">{(selectedFile.size / 1024 / 1024).toFixed(2)} MB</p>
                  </div>
                ) : (
                  <>
                    <div className="w-12 h-12 bg-primary-subtle text-primary rounded-full flex items-center justify-center mb-4 group-hover:scale-110 transition-transform"><UploadCloud size={24} /></div>
                    <p className="text-foreground font-medium mb-1">Kéo thả file vào đây hoặc click để chọn</p>
                    <p className="text-xs text-muted-foreground">Hỗ trợ PDF, DOCX, JPG (Tối đa 50MB)</p>
                  </>
                )}
              </div>

              <div className="space-y-1.5">
                <label className="text-sm font-medium text-muted-foreground">Môn học</label>
                <select value={uploadSubject} onChange={(e) => setUploadSubject(e.target.value)} className="w-full bg-muted border border-border text-foreground text-sm rounded-lg px-3 py-2.5 focus:outline-none focus:border-primary">
                  <option value="Toán học">Toán học</option>
                  <option value="Vật lý">Vật lý</option>
                  <option value="Hóa học">Hóa học</option>
                  <option value="Tiếng Anh">Tiếng Anh</option>
                </select>
              </div>
            </div>

            <div className="flex items-center justify-end gap-3 p-6 border-t border-border bg-muted/50">
              <button onClick={handleClose} className="px-4 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors">Hủy bỏ</button>
              <button onClick={handleSubmit} disabled={!selectedFile} className={`px-4 py-2 text-sm font-medium rounded-lg transition-colors flex items-center gap-2 ${selectedFile ? 'bg-primary hover:bg-primary/90 text-primary-foreground' : 'bg-muted text-muted-foreground cursor-not-allowed'}`}>
                Bắt đầu Upload
              </button>
            </div>
          </motion.div>
        </div>
      )}
    </AnimatePresence>
  );
}