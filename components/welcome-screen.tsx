"use client"

import { Button } from "@/components/ui/button"

interface WelcomeScreenProps {
  childName: string
  onStart: () => void
}

export default function WelcomeScreen({ childName, onStart }: WelcomeScreenProps) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-yellow-200 via-orange-200 to-pink-200 flex items-center justify-center p-6 relative overflow-hidden">
      {/* Animated background elements */}
      <div className="absolute top-10 left-10 text-7xl animate-wiggle">🌟</div>
      <div className="absolute top-10 right-10 text-6xl animate-bounce-fun">🎨</div>
      <div className="absolute bottom-10 left-10 text-7xl animate-float">🎵</div>
      <div className="absolute bottom-10 right-10 text-6xl animate-wiggle" style={{ animationDelay: "0.5s" }}>
        🚀
      </div>

      <div className="text-center max-w-2xl">
        {/* Main illustration */}
        <div className="mb-8">
          <div className="text-[10rem] mb-4 animate-bounce-fun">🐶</div>
        </div>

        {/* Welcome text */}
        <h1 className="text-5xl md:text-6xl font-bold text-foreground mb-6 text-balance">Hello {childName}! 👋</h1>

        <p className="text-3xl md:text-4xl text-foreground/80 mb-12 font-medium text-balance">
          {"Let's learn something fun today!"}
        </p>

        {/* Start button */}
        <Button
          onClick={onStart}
          size="lg"
          className="h-24 px-16 text-3xl font-bold rounded-[2rem] bg-gradient-to-r from-green-400 to-blue-400 hover:from-green-500 hover:to-blue-500 text-white shadow-2xl hover:shadow-3xl transition-all duration-300 hover:scale-110"
        >
          Start Learning 🚀
        </Button>

        {/* Sound icon (decorative) */}
        <div className="mt-12">
          <button className="text-5xl opacity-50 hover:opacity-100 transition-opacity">🔊</button>
        </div>
      </div>
    </div>
  )
}
