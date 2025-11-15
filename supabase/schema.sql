-- Practice Management Database Schema

-- ユーザーテーブル
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('athlete', 'coach')),
  team_id UUID REFERENCES teams(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- チームテーブル
CREATE TABLE IF NOT EXISTS teams (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  coach_id UUID REFERENCES users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 練習記録テーブル
CREATE TABLE IF NOT EXISTS trainings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  date DATE NOT NULL,
  distance DECIMAL(10, 2) NOT NULL, -- km
  duration INTEGER NOT NULL, -- 秒
  pace DECIMAL(10, 2), -- 秒/km
  heart_rate INTEGER, -- bpm
  training_type TEXT NOT NULL CHECK (training_type IN ('interval', 'tempo', 'long_run', 'recovery', 'race', 'other')),
  notes TEXT,
  sleep_hours DECIMAL(4, 1),
  condition INTEGER CHECK (condition >= 1 AND condition <= 5),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 自己ベストテーブル
CREATE TABLE IF NOT EXISTS personal_bests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  distance INTEGER NOT NULL, -- メートル
  time INTEGER NOT NULL, -- 秒
  date DATE NOT NULL,
  location TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- インデックス
CREATE INDEX IF NOT EXISTS idx_trainings_user_id ON trainings(user_id);
CREATE INDEX IF NOT EXISTS idx_trainings_date ON trainings(date);
CREATE INDEX IF NOT EXISTS idx_personal_bests_user_id ON personal_bests(user_id);
CREATE INDEX IF NOT EXISTS idx_users_team_id ON users(team_id);

-- Row Level Security (RLS) の有効化
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE trainings ENABLE ROW LEVEL SECURITY;
ALTER TABLE personal_bests ENABLE ROW LEVEL SECURITY;

-- RLSポリシー: ユーザーは自分のデータのみ閲覧・編集可能
CREATE POLICY "Users can view own data" ON users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own data" ON users
  FOR UPDATE USING (auth.uid() = id);

-- RLSポリシー: 選手は自分の練習記録のみ閲覧・編集可能
CREATE POLICY "Athletes can view own trainings" ON trainings
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Athletes can insert own trainings" ON trainings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Athletes can update own trainings" ON trainings
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Athletes can delete own trainings" ON trainings
  FOR DELETE USING (auth.uid() = user_id);

-- RLSポリシー: コーチはチームメンバーの練習記録を閲覧可能
CREATE POLICY "Coaches can view team trainings" ON trainings
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM users u
      WHERE u.id = trainings.user_id
      AND u.team_id IN (
        SELECT id FROM teams WHERE coach_id = auth.uid()
      )
    )
  );

-- RLSポリシー: 自己ベスト
CREATE POLICY "Athletes can manage own personal bests" ON personal_bests
  FOR ALL USING (auth.uid() = user_id);

-- RLSポリシー: チーム
CREATE POLICY "Users can view teams" ON teams
  FOR SELECT USING (
    coach_id = auth.uid() OR
    id IN (SELECT team_id FROM users WHERE id = auth.uid())
  );

CREATE POLICY "Coaches can update own teams" ON teams
  FOR UPDATE USING (coach_id = auth.uid());

-- 更新時刻の自動更新トリガー
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_teams_updated_at BEFORE UPDATE ON teams
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_trainings_updated_at BEFORE UPDATE ON trainings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_personal_bests_updated_at BEFORE UPDATE ON personal_bests
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
