import RegisterForm from '@/components/forms/RegisterForm';

export default function RegisterPage() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center p-24 bg-white">
      <div className="w-full max-w-md">
        <h1 className="text-3xl font-bold mb-8 text-center text-gray-900">新規登録</h1>
        <RegisterForm />
      </div>
    </main>
  );
}
