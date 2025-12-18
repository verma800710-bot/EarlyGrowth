# Kid Learning App

An interactive learning application for children featuring video lessons, quizzes, and progress tracking.

## Features

- 🎓 Interactive video lessons
- 📝 Engaging quizzes with instant feedback
- 📊 Progress tracking dashboard
- 🎨 Kid-friendly interface with colorful design
- 🔐 Simple login system

## Getting Started

### Prerequisites

- Node.js 18+ installed
- pnpm, npm, or yarn package manager

### Installation

1. Clone the repository
2. Install dependencies:

```bash
pnpm install
# or
npm install
# or
yarn install
```

### Development

Run the development server:

```bash
pnpm dev
# or
npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) to view the app.

### Building for Production

```bash
pnpm build
# or
npm run build
# or
yarn build
```

### Running Production Build

```bash
pnpm start
# or
npm start
# or
yarn start
```

## Deployment

### Deploy to Vercel

The easiest way to deploy this app is using the Vercel Platform:

1. Push your code to a Git repository (GitHub, GitLab, or Bitbucket)
2. Import your repository to [Vercel](https://vercel.com/new)
3. Vercel will automatically detect Next.js and configure the build settings
4. Click "Deploy" and your app will be live!

Alternatively, you can deploy directly from v0 by clicking the "Publish" button.

## Tech Stack

- **Framework:** Next.js 16
- **React:** 19.2
- **Styling:** Tailwind CSS 4
- **UI Components:** Radix UI + shadcn/ui
- **Icons:** Lucide React
- **TypeScript:** Full type safety

## Project Structure

```
├── app/                  # Next.js app directory
│   ├── layout.tsx       # Root layout
│   ├── page.tsx         # Home page
│   └── globals.css      # Global styles
├── components/          # React components
│   ├── ui/             # UI component library
│   ├── login-screen.tsx
│   ├── welcome-screen.tsx
│   ├── dashboard-screen.tsx
│   ├── video-screen.tsx
│   └── quiz-screen.tsx
├── lib/                # Utility functions
├── hooks/              # Custom React hooks
└── public/             # Static assets
```

## Learn More

- [Next.js Documentation](https://nextjs.org/docs)
- [Vercel Documentation](https://vercel.com/docs)
- [Tailwind CSS](https://tailwindcss.com)

## License

MIT
