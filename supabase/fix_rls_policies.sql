-- RLSポリシー修正スクリプト
-- 既存のSupabaseプロジェクトでこのSQLを実行してください

-- 既存のポリシーを削除（存在する場合）
DROP POLICY IF EXISTS "Users can insert own data" ON users;

-- 新規登録を許可するポリシーを追加
CREATE POLICY "Users can insert own data" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);

-- 確認: 現在のポリシー一覧を表示
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check
FROM pg_policies
WHERE tablename = 'users'
ORDER BY policyname;
