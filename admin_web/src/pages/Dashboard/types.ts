import { LucideIcon } from 'lucide-react';

export interface StatItem {
  id: string;
  title: string;
  value: string | number;
  change: string;
  trend: 'up' | 'down' | 'neutral';
  icon: LucideIcon;
  color: string;
}

export interface Activity {
  id: number;
  action: string;
  user: string;
  time: string;
  type: 'exam' | 'user' | 'system' | 'finance';
}

export interface SystemMetrics {
  cpu: number;
  ram: number;
  storage: number;
  aiQueue: number;
}