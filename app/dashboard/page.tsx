import { redirect } from 'next/navigation';
import { getCurrentUser } from '@/lib/auth';

export default async function DashboardPage() {
  const user = await getCurrentUser();

  if (!user) {
    redirect('/login');
  }

  return (
    <main className="min-h-screen bg-gray-50">
      {/* ナビゲーションバー */}
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <h1 className="text-xl font-bold">Practice Management</h1>
            <div className="flex items-center gap-4">
              <span className="text-sm text-gray-600">{user.name}</span>
              <a
                href="/api/auth/signout"
                className="text-sm text-red-600 hover:text-red-700"
              >
                ログアウト
              </a>
            </div>
          </div>
        </div>
      </nav>

      {/* メインコンテンツ */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8">
          <h2 className="text-2xl font-bold mb-2">
            ようこそ、{user.name}さん
          </h2>
          <p className="text-gray-600">
            {(user as any).role === 'coach'
              ? 'コーチダッシュボード'
              : '選手ダッシュボード'}
          </p>
        </div>

        {/* ダッシュボードグリッド */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* 今週の練習距離 */}
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold mb-2">今週の走行距離</h3>
            <p className="text-3xl font-bold text-blue-600">0.0 km</p>
            <p className="text-sm text-gray-500 mt-2">先週比: --</p>
          </div>

          {/* 今月の練習回数 */}
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold mb-2">今月の練習回数</h3>
            <p className="text-3xl font-bold text-green-600">0 回</p>
            <p className="text-sm text-gray-500 mt-2">目標: 20回</p>
          </div>

          {/* 最新の自己ベスト */}
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-semibold mb-2">最新の自己ベスト</h3>
            <p className="text-3xl font-bold text-purple-600">--</p>
            <p className="text-sm text-gray-500 mt-2">記録なし</p>
          </div>
        </div>

        {/* クイックアクション */}
        <div className="mt-8">
          <h3 className="text-xl font-bold mb-4">クイックアクション</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            <a
              href="/training/new"
              className="bg-blue-600 text-white p-4 rounded-lg hover:bg-blue-700 transition text-center"
            >
              練習記録を追加
            </a>
            <a
              href="/training"
              className="bg-gray-200 text-gray-800 p-4 rounded-lg hover:bg-gray-300 transition text-center"
            >
              練習記録一覧
            </a>
            <a
              href="/personal-bests"
              className="bg-gray-200 text-gray-800 p-4 rounded-lg hover:bg-gray-300 transition text-center"
            >
              自己ベスト
            </a>
            {(user as any).role === 'coach' && (
              <a
                href="/team"
                className="bg-gray-200 text-gray-800 p-4 rounded-lg hover:bg-gray-300 transition text-center"
              >
                チーム管理
              </a>
            )}
          </div>
        </div>

        {/* 最近の練習記録 */}
        <div className="mt-8">
          <h3 className="text-xl font-bold mb-4">最近の練習記録</h3>
          <div className="bg-white rounded-lg shadow overflow-hidden">
            <div className="p-6 text-center text-gray-500">
              まだ練習記録がありません。最初の練習記録を追加しましょう!
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}
