"use client"

import type React from "react"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Slider } from "@/components/ui/slider"

interface LoginScreenProps {
  onLogin: (name: string, age: number) => void
}

export default function LoginScreen({ onLogin }: LoginScreenProps) {
  const [name, setName] = useState("")
  const [age, setAge] = useState([3])
  const [email, setEmail] = useState("")

  const ageEmojis = ["👶", "👶", "🧒", "🧒", "🧒", "🧒"]

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    if (name.trim()) {
      onLogin(name, age[0])
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-pink-200 via-purple-200 to-blue-200 flex items-center justify-center p-6 relative overflow-hidden">
      {/* Floating decorative elements */}
      <div className="absolute top-10 left-10 text-6xl animate-float">☁️</div>
      <div className="absolute top-20 right-20 text-5xl animate-bounce-fun">⭐</div>
      <div className="absolute bottom-20 left-20 text-6xl animate-wiggle">🎈</div>
      <div className="absolute bottom-10 right-10 text-5xl animate-float" style={{ animationDelay: "1s" }}>
        🌈
      </div>

      <div className="w-full max-w-md">
        <div className="bg-white rounded-[2.5rem] shadow-2xl p-10 relative">
          {/* Decorative header image */}
          <div className="text-center mb-8">
            <div className="text-7xl mb-4 animate-bounce-fun">🐻</div>
            <h1 className="text-4xl font-bold text-primary mb-2">{"Let's Get Started!"}</h1>
            <p className="text-lg text-muted-foreground">Create your learning profile</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Child Name */}
            <div className="space-y-3">
              <label className="text-xl font-semibold text-foreground block">{"What's your name?"} 🌟</label>
              <Input
                type="text"
                value={name}
                onChange={(e) => setName(e.target.value)}
                placeholder="Enter name here..."
                className="h-16 text-2xl rounded-3xl border-4 border-primary/20 focus:border-primary px-6"
                required
              />
            </div>

            {/* Age Slider */}
            <div className="space-y-4">
              <label className="text-xl font-semibold text-foreground block">
                How old are you? {ageEmojis[age[0]]}
              </label>
              <div className="flex items-center gap-4">
                <span className="text-2xl font-bold text-primary min-w-[3rem]">{age[0]}</span>
                <Slider value={age} onValueChange={setAge} max={5} min={0} step={1} className="flex-1" />
              </div>
            </div>

            {/* Parent Email */}
            <div className="space-y-3">
              <label className="text-sm font-medium text-muted-foreground block">Parent Email (optional) 📧</label>
              <Input
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="parent@example.com"
                className="h-12 text-base rounded-2xl border-2 border-border"
              />
            </div>

            {/* Submit Button */}
            <Button
              type="submit"
              size="lg"
              className="w-full h-20 text-2xl font-bold rounded-3xl bg-gradient-to-r from-pink-400 via-purple-400 to-blue-400 hover:from-pink-500 hover:via-purple-500 hover:to-blue-500 text-white shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105"
            >
              {"Let's Play & Learn 🎈"}
            </Button>
          </form>
        </div>
      </div>
    </div>
  )
}
