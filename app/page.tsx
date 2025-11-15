export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-white">
      <div className="z-10 w-full max-w-5xl items-center justify-between">
        <h1 className="text-4xl font-bold mb-8 text-center text-gray-900">
          Practice Management
        </h1>
        <p className="text-xl text-center mb-8 text-gray-700">
          大学陸上部向けチーム管理SaaS
        </p>
        <div className="flex gap-4 justify-center">
          <a
            href="/login"
            className="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
          >
            ログイン
          </a>
          <a
            href="/register"
            className="px-6 py-3 bg-gray-200 text-gray-900 rounded-lg hover:bg-gray-300 transition"
          >
            新規登録
          </a>
        </div>
      </div>
    </main>
  );
}
