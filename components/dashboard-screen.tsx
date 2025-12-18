"use client"

import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import TopHeader from "./top-header"

interface DashboardScreenProps {
  childName: string
  onTopicSelect: (topic: string) => void
  candyCount: number
  completedTopics: string[]
}

const topics = [
  { name: "Animals", emoji: "🐶", color: "from-pink-300 to-pink-400" },
  { name: "Environment", emoji: "🌳", color: "from-green-300 to-green-400" },
  { name: "Family", emoji: "👨‍👩‍👧", color: "from-purple-300 to-purple-400" },
  { name: "Vehicles", emoji: "🚗", color: "from-blue-300 to-blue-400" },
  { name: "Music & Sounds", emoji: "🎵", color: "from-yellow-300 to-yellow-400" },
  { name: "Numbers & Colors", emoji: "🔢", color: "from-orange-300 to-orange-400" },
]

export default function DashboardScreen({
  childName,
  onTopicSelect,
  candyCount,
  completedTopics,
}: DashboardScreenProps) {
  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-100 via-purple-100 to-pink-100">
      <TopHeader candyCount={candyCount} completedTopics={completedTopics} />

      <div className="pt-24 p-6">
        <div className="max-w-6xl mx-auto">
          <Card className="mb-8 bg-gradient-to-r from-blue-200 to-purple-200 border-0 shadow-xl rounded-[2rem] overflow-hidden">
            <div className="p-6 flex items-center gap-6">
              <div className="flex-shrink-0">
                <div className="relative w-48 h-32 bg-gradient-to-br from-indigo-300 to-purple-300 rounded-2xl flex items-center justify-center shadow-lg">
                  <span className="text-6xl">📺</span>
                  <div className="absolute inset-0 flex items-center justify-center">
                    <div className="w-16 h-16 bg-white/90 rounded-full flex items-center justify-center shadow-lg">
                      <span className="text-2xl">▶️</span>
                    </div>
                  </div>
                </div>
              </div>
              <div className="flex-1">
                <h3 className="text-2xl font-bold text-foreground mb-2">Parent Demo – How this app works</h3>
                <p className="text-lg text-foreground/70 mb-3">
                  Learn about the learning flow, candy reward system, and safe usage for kids
                </p>
                <Button className="bg-white text-primary hover:bg-white/90 rounded-2xl px-6 py-2 font-semibold shadow-md">
                  Watch Demo
                </Button>
              </div>
            </div>
          </Card>

          {/* Header */}
          <div className="flex items-center justify-between mb-8">
            {/* Search bar */}
            <div className="flex-1 max-w-md">
              <div className="relative">
                <input
                  type="text"
                  placeholder="Search..."
                  className="w-full h-16 rounded-3xl border-4 border-white bg-white px-6 pr-16 text-xl font-medium shadow-lg"
                  readOnly
                />
                <div className="absolute right-4 top-1/2 -translate-y-1/2 flex gap-2">
                  <span className="text-2xl">🎤</span>
                  <span className="text-2xl">🔍</span>
                </div>
              </div>
            </div>

            {/* Parent toggle */}
            <button className="ml-4 px-6 py-3 bg-white rounded-2xl text-sm font-medium shadow-lg hover:shadow-xl transition-shadow">
              Parent Mode
            </button>
          </div>

          {/* Welcome message */}
          <div className="mb-8 text-center">
            <h2 className="text-4xl md:text-5xl font-bold text-foreground mb-3 flex items-center justify-center gap-3">
              Choose What You Want to Learn 🎨
            </h2>
            <p className="text-xl text-muted-foreground">Tap any topic to start!</p>
          </div>

          {/* Topic grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            {topics.map((topic) => (
              <Card
                key={topic.name}
                className="p-0 overflow-hidden border-0 shadow-xl hover:shadow-2xl transition-all duration-300 hover:scale-105 cursor-pointer rounded-[2rem]"
                onClick={() => onTopicSelect(topic.name)}
              >
                <div
                  className={`bg-gradient-to-br ${topic.color} p-8 text-center h-full flex flex-col items-center justify-center gap-4`}
                >
                  <div className="text-8xl animate-bounce-fun">{topic.emoji}</div>
                  <h3 className="text-2xl font-bold text-white text-balance">{topic.name}</h3>
                </div>
              </Card>
            ))}
          </div>

          {/* Subscription banner */}
          <Card className="bg-gradient-to-r from-purple-200 to-pink-200 border-0 shadow-lg rounded-[2rem] p-8">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <span className="text-5xl">⭐</span>
                <div>
                  <h3 className="text-2xl font-bold text-foreground mb-1">Unlock more fun videos & games</h3>
                  <p className="text-lg text-foreground/70">Get access to 100+ learning activities</p>
                </div>
              </div>
              <Button
                size="lg"
                className="h-16 px-8 text-xl font-bold rounded-2xl bg-white text-primary hover:bg-white/90"
              >
                Learn More
              </Button>
            </div>
          </Card>

          {/* Progress section */}
          <div className="mt-8 text-center">
            <div className="inline-flex items-center gap-3 bg-white px-8 py-4 rounded-3xl shadow-lg">
              <span className="text-3xl">🐾</span>
              <p className="text-xl font-semibold text-foreground">You learned Animals today!</p>
              <div className="flex gap-1">
                <span className="text-2xl">🌟</span>
                <span className="text-2xl">🌟</span>
                <span className="text-2xl">🌟</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
