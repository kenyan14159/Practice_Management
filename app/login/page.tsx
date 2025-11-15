import LoginForm from '@/components/forms/LoginForm';

export default function LoginPage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-white">
      <div className="w-full max-w-md">
        <h1 className="text-3xl font-bold mb-8 text-center text-gray-900">ログイン</h1>
        <LoginForm />
      </div>
    </main>
  );
}
