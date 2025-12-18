"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import TopHeader from "./top-header"

interface VideoScreenProps {
  topic: string
  onVideoEnd: () => void
  candyCount: number
  completedTopics: string[]
}

export default function VideoScreen({ topic, onVideoEnd, candyCount, completedTopics }: VideoScreenProps) {
  const [isPlaying, setIsPlaying] = useState(false)

  const handlePlay = () => {
    setIsPlaying(true)
    // Simulate video playing for 3 seconds then showing quiz
    setTimeout(() => {
      onVideoEnd()
    }, 3000)
  }

  const topicVideos: Record<string, { title: string; emoji: string }> = {
    Animals: { title: "This is a 🐶 Dog. Dog says Woof!", emoji: "🐶" },
    Environment: { title: "Look at the beautiful 🌳 Tree!", emoji: "🌳" },
    Family: { title: "This is a happy 👨‍👩‍👧 Family!", emoji: "👨‍👩‍👧" },
    Vehicles: { title: "Vroom! This is a 🚗 Car!", emoji: "🚗" },
    "Music & Sounds": { title: "Listen to the 🎵 Music!", emoji: "🎵" },
    "Numbers & Colors": { title: "Let's learn 🔢 Numbers!", emoji: "🔢" },
  }

  const video = topicVideos[topic] || topicVideos["Animals"]

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-200 via-purple-200 to-pink-200">
      <TopHeader candyCount={candyCount} completedTopics={completedTopics} />

      <div className="pt-24 flex items-center justify-center p-6">
        <div className="w-full max-w-4xl">
          {/* Video player card */}
          <div className="bg-white rounded-[3rem] shadow-2xl overflow-hidden">
            {/* Video area */}
            <div className="relative aspect-video bg-gradient-to-br from-blue-300 to-purple-300 flex items-center justify-center">
              {!isPlaying ? (
                <div className="text-center">
                  <div className="text-[12rem] mb-6 animate-bounce-fun">{video.emoji}</div>
                  <Button
                    onClick={handlePlay}
                    size="lg"
                    className="h-28 w-28 rounded-full bg-white hover:bg-white/90 shadow-2xl hover:scale-110 transition-all duration-300"
                  >
                    <span className="text-6xl">▶️</span>
                  </Button>
                </div>
              ) : (
                <div className="text-center">
                  <div className="text-[12rem] animate-pulse">{video.emoji}</div>
                  <div className="mt-6 px-8 py-4 bg-white/90 rounded-3xl inline-block">
                    <p className="text-3xl font-bold text-foreground">Playing...</p>
                  </div>
                </div>
              )}
            </div>

            {/* Video info */}
            <div className="p-8">
              <h2 className="text-3xl font-bold text-foreground text-center mb-4 text-balance">{video.title}</h2>
              <div className="flex items-center justify-center gap-4">
                <div className="flex gap-2">
                  {[1, 2, 3, 4, 5].map((i) => (
                    <div
                      key={i}
                      className="w-4 h-4 rounded-full bg-primary/30"
                      style={{
                        animation: isPlaying ? `pulse 1.5s ease-in-out ${i * 0.2}s infinite` : "none",
                      }}
                    />
                  ))}
                </div>
              </div>
            </div>
          </div>

          {/* Navigation hint */}
          <div className="mt-8 text-center">
            <p className="text-2xl text-foreground/60 font-medium">
              {isPlaying ? "Watch carefully! 👀" : "Tap play to start! 🎬"}
            </p>
          </div>
        </div>
      </div>
    </div>
  )
}
