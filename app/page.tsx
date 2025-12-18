"use client"

import { useState, useEffect } from "react"
import LoginScreen from "@/components/login-screen"
import WelcomeScreen from "@/components/welcome-screen"
import DashboardScreen from "@/components/dashboard-screen"
import VideoScreen from "@/components/video-screen"
import QuizScreen from "@/components/quiz-screen"

export default function Home() {
  const [currentScreen, setCurrentScreen] = useState<"login" | "welcome" | "dashboard" | "video" | "quiz">("login")
  const [childName, setChildName] = useState("")
  const [childAge, setChildAge] = useState(3)
  const [selectedTopic, setSelectedTopic] = useState("")
  const [candyCount, setCandyCount] = useState(0)
  const [completedTopics, setCompletedTopics] = useState<string[]>([])

  useEffect(() => {
    const savedData = localStorage.getItem(`learningData_${childName}`)
    if (savedData) {
      const data = JSON.parse(savedData)
      setCandyCount(data.candyCount || 0)
      setCompletedTopics(data.completedTopics || [])
    }
  }, [childName])

  useEffect(() => {
    if (childName) {
      localStorage.setItem(`learningData_${childName}`, JSON.stringify({ candyCount, completedTopics }))
    }
  }, [candyCount, completedTopics, childName])

  const handleLogin = (name: string, age: number) => {
    setChildName(name)
    setChildAge(age)
    setCurrentScreen("welcome")
  }

  const handleStartLearning = () => {
    setCurrentScreen("dashboard")
  }

  const handleTopicSelect = (topic: string) => {
    setSelectedTopic(topic)
    setCurrentScreen("video")
  }

  const handleVideoEnd = () => {
    setCurrentScreen("quiz")
  }

  const handleQuizComplete = () => {
    setCurrentScreen("dashboard")
  }

  const handleCorrectAnswer = () => {
    setCandyCount((prev) => prev + 1)
    if (!completedTopics.includes(selectedTopic)) {
      setCompletedTopics((prev) => [...prev, selectedTopic])
    }
  }

  return (
    <main className="min-h-screen">
      {currentScreen === "login" && <LoginScreen onLogin={handleLogin} />}
      {currentScreen === "welcome" && <WelcomeScreen childName={childName} onStart={handleStartLearning} />}
      {currentScreen === "dashboard" && (
        <DashboardScreen
          childName={childName}
          onTopicSelect={handleTopicSelect}
          candyCount={candyCount}
          completedTopics={completedTopics}
        />
      )}
      {currentScreen === "video" && (
        <VideoScreen
          topic={selectedTopic}
          onVideoEnd={handleVideoEnd}
          candyCount={candyCount}
          completedTopics={completedTopics}
        />
      )}
      {currentScreen === "quiz" && (
        <QuizScreen
          topic={selectedTopic}
          childName={childName}
          onComplete={handleQuizComplete}
          onCorrectAnswer={handleCorrectAnswer}
          candyCount={candyCount}
          completedTopics={completedTopics}
        />
      )}
    </main>
  )
}
