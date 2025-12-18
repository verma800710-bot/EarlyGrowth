"use client"

import { useEffect, useState } from "react"

interface TopHeaderProps {
  candyCount: number
  completedTopics: string[]
}

const topicIcons: Record<string, string> = {
  Animals: "🐶",
  Environment: "🌳",
  Family: "👨‍👩‍👧",
  Vehicles: "🚗",
  "Music & Sounds": "🎵",
  "Numbers & Colors": "🔢",
}

export default function TopHeader({ candyCount, completedTopics }: TopHeaderProps) {
  const [showCandyAnimation, setShowCandyAnimation] = useState(false)
  const [prevCandyCount, setPrevCandyCount] = useState(candyCount)

  useEffect(() => {
    if (candyCount > prevCandyCount) {
      setShowCandyAnimation(true)
      setTimeout(() => setShowCandyAnimation(false), 1000)
    }
    setPrevCandyCount(candyCount)
  }, [candyCount, prevCandyCount])

  return (
    <div className="fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-md shadow-lg">
      <div className="max-w-7xl mx-auto px-4 py-3 flex items-center justify-between gap-4">
        {/* Candy Counter */}
        <div className="flex items-center gap-2 bg-gradient-to-r from-pink-200 to-yellow-200 px-6 py-3 rounded-3xl shadow-md relative">
          {showCandyAnimation && (
            <div className="absolute -top-8 left-1/2 -translate-x-1/2 text-4xl animate-bounce">🍬</div>
          )}
          <span className="text-3xl animate-wiggle">🍬</span>
          <span className="text-xl font-bold text-foreground">x {candyCount}</span>
        </div>

        {/* Learning Progress */}
        <div className="flex items-center gap-2 flex-1 justify-center flex-wrap">
          {Object.entries(topicIcons).map(([topic, emoji]) => {
            const isCompleted = completedTopics.includes(topic)
            return (
              <div
                key={topic}
                className={`flex items-center gap-1 px-4 py-2 rounded-2xl transition-all ${
                  isCompleted ? "bg-green-200 shadow-md scale-100" : "bg-gray-200 opacity-50 scale-90"
                }`}
              >
                <span className="text-2xl">{emoji}</span>
                {isCompleted && <span className="text-lg">✔</span>}
              </div>
            )
          })}
        </div>
      </div>
    </div>
  )
}
