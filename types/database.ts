// データベースの型定義

export type UserRole = 'athlete' | 'coach';

export type User = {
  id: string;
  email: string;
  name: string;
  role: UserRole;
  team_id?: string;
  created_at: string;
  updated_at: string;
};

export type Team = {
  id: string;
  name: string;
  coach_id: string;
  created_at: string;
  updated_at: string;
};

export type TrainingType =
  | 'interval'
  | 'tempo'
  | 'long_run'
  | 'recovery'
  | 'race'
  | 'other';

export type Training = {
  id: string;
  user_id: string;
  date: string;
  distance: number; // km
  duration: number; // 秒
  pace?: number; // 秒/km
  heart_rate?: number; // bpm
  training_type: TrainingType;
  notes?: string;
  sleep_hours?: number;
  condition?: number; // 1-5のスケール
  created_at: string;
  updated_at: string;
};

export type PersonalBest = {
  id: string;
  user_id: string;
  distance: number; // メートル
  time: number; // 秒
  date: string;
  location?: string;
  created_at: string;
  updated_at: string;
};
