# セットアップガイド

このドキュメントでは、Practice Managementアプリケーションのセットアップ手順を詳しく説明します。

## 前提条件

- Node.js 18.x以上
- npm または yarn
- Supabaseアカウント
- Gitがインストールされていること

## ステップバイステップガイド

### 1. プロジェクトのセットアップ

```bash
# リポジトリをクローン
git clone <your-repo-url>
cd Practice_Management

# 依存関係をインストール
npm install

# または yarnを使用
yarn install
```

### 2. Supabaseプロジェクトの作成

1. [Supabase](https://supabase.com/)にアクセス
2. 「New Project」をクリック
3. プロジェクト名を入力（例: `practice-management`）
4. データベースパスワードを設定（後で使用するのでメモしておく）
5. リージョンを選択（日本の場合は `Northeast Asia (Tokyo)` を推奨）
6. プロジェクトが作成されるまで待つ（1-2分程度）

### 3. Supabaseの環境変数を取得

1. Supabaseダッシュボードで作成したプロジェクトを開く
2. 左側のメニューから「Settings」→「API」を選択
3. 以下の情報をメモ:
   - **Project URL**: `URL`セクションの値
   - **anon/public key**: `Project API keys`セクションの`anon public`キー

### 4. データベースのセットアップ

#### 初回セットアップの場合

1. Supabaseダッシュボードで「SQL Editor」を開く
2. 「New Query」をクリック
3. `supabase/schema.sql`の内容をコピー＆ペースト
4. 「Run」ボタンをクリックしてSQLを実行
5. エラーが出なければ成功

#### 既にデータベースを作成済みの場合（RLSポリシーの修正）

**重要**: 既にデータベースを作成している場合は、以下の手順でRLSポリシーを修正してください。

1. Supabaseダッシュボードで「SQL Editor」を開く
2. 「New Query」をクリック
3. `supabase/fix_rls_policies.sql`の内容をコピー＆ペースト
4. 「Run」ボタンをクリックしてSQLを実行
5. 実行結果に以下のポリシーが表示されれば成功:
   - `Users can view own data`
   - `Users can insert own data` ← これが重要！
   - `Users can update own data`

#### データベースの確認

データベースのテーブルが正しく作成されたか確認するには:
- 左側のメニューから「Table Editor」を開く
- `users`, `teams`, `trainings`, `personal_bests`テーブルが表示されていることを確認

### 5. 環境変数の設定

プロジェクトのルートディレクトリで以下を実行:

```bash
cp .env.example .env.local
```

`.env.local`を開いて編集:

```env
# Supabase (ステップ3で取得した値を設定)
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here

# NextAuth.js
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-generated-secret-here
```

#### NEXTAUTH_SECRETの生成

以下のコマンドでランダムな秘密鍵を生成:

```bash
openssl rand -base64 32
```

生成された文字列を`NEXTAUTH_SECRET`にコピー＆ペースト

### 6. 開発サーバーの起動

```bash
npm run dev
```

ブラウザで [http://localhost:3000](http://localhost:3000) を開く

以下のページが表示されれば成功:
- トップページ: Practice Managementのロゴとログイン・新規登録ボタン

### 7. テストユーザーの作成

1. [http://localhost:3000/register](http://localhost:3000/register) にアクセス
2. テストユーザーを作成:
   - 名前: テストユーザー
   - メールアドレス: test@example.com
   - ユーザー種別: 選手 or コーチ
   - パスワード: testpassword123
   - パスワード（確認）: testpassword123
3. 「登録」をクリック
4. 登録成功のアラートが表示されたら、ログインページにリダイレクトされる
5. ログイン情報を入力してダッシュボードにアクセス

## トラブルシューティング

### 問題: 新規登録時に "new row violates row-level security policy for table 'users'" エラーが発生

**症状**: 新規登録フォームで情報を入力して「登録」ボタンを押すと、以下のエラーが表示される:
```
new row violates row-level security policy for table "users"
```

**原因**: usersテーブルのRLSポリシーにINSERT権限が設定されていない

**解決策**: Supabaseで`supabase/fix_rls_policies.sql`を実行

1. Supabaseダッシュボードで「SQL Editor」を開く
2. 「New Query」をクリック
3. 以下のSQLを実行:

```sql
-- 既存のポリシーを削除（存在する場合）
DROP POLICY IF EXISTS "Users can insert own data" ON users;

-- 新規登録を許可するポリシーを追加
CREATE POLICY "Users can insert own data" ON users
  FOR INSERT WITH CHECK (auth.uid() = id);
```

4. 「Run」をクリック
5. 新規登録を再度試す

### 問題: npm installでエラーが発生する

**解決策1**: Node.jsのバージョンを確認

```bash
node --version
```

Node.js 18.x以上であることを確認してください。

**解決策2**: キャッシュをクリア

```bash
npm cache clean --force
npm install
```

### 問題: Supabaseへの接続エラー

**症状**: ログインや登録時にエラーが発生

**解決策**:
1. `.env.local`の環境変数が正しく設定されているか確認
2. Supabaseプロジェクトが起動しているか確認
3. SupabaseダッシュボードでRow Level Security (RLS)のポリシーが正しく設定されているか確認

### 問題: NextAuth.jsのエラー

**症状**: `[next-auth][error][SIGNIN_OAUTH_ERROR]` などのエラー

**解決策**:
1. `NEXTAUTH_SECRET`が設定されているか確認
2. `NEXTAUTH_URL`が正しいURLになっているか確認（本番環境では`https://your-domain.com`）

### 問題: データベースのテーブルが作成されない

**解決策**:
1. SQLエディタでエラーメッセージを確認
2. `supabase/schema.sql`の内容を1つずつ実行して、どこでエラーが発生しているか特定
3. 既にテーブルが存在する場合は、`DROP TABLE IF EXISTS`を使用して削除してから再実行

## 次のステップ

セットアップが完了したら、以下の機能開発に進むことができます:

1. **練習記録の入力機能**: app/training/new/page.tsx の作成
2. **データ可視化**: Rechartsを使用したグラフ表示
3. **チーム管理機能**: コーチ向けのチームダッシュボード
4. **外部API連携**: Strava, Garminなどのデバイス連携

詳細はREADME.mdの「今後の開発予定」セクションを参照してください。

## 本番環境へのデプロイ

Vercelへのデプロイ手順:

1. [Vercel](https://vercel.com/)でアカウントを作成
2. GitHubリポジトリと連携
3. プロジェクトをインポート
4. 環境変数を設定（Settings → Environment Variables）:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `NEXTAUTH_URL` (本番URLに変更)
   - `NEXTAUTH_SECRET`
5. デプロイを実行

注意: 本番環境では必ず新しい`NEXTAUTH_SECRET`を生成してください。

## サポート

問題が解決しない場合は、GitHubのIssueを作成してください。
