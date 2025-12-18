"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card } from "@/components/ui/card"
import TopHeader from "./top-header"

interface QuizScreenProps {
  topic: string
  childName: string
  onComplete: () => void
  onCorrectAnswer: () => void
  candyCount: number
  completedTopics: string[]
}

export default function QuizScreen({
  topic,
  childName,
  onComplete,
  onCorrectAnswer,
  candyCount,
  completedTopics,
}: QuizScreenProps) {
  const [answered, setAnswered] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [showConfetti, setShowConfetti] = useState(false)

  const quizData: Record<string, { question: string; options: { emoji: string; label: string; correct: boolean }[] }> =
    {
      Animals: {
        question: "Which one is the Dog? 🐶",
        options: [
          { emoji: "🐱", label: "Cat", correct: false },
          { emoji: "🐶", label: "Dog", correct: true },
          { emoji: "🐰", label: "Rabbit", correct: false },
        ],
      },
      Environment: {
        question: "Which one is the Tree? 🌳",
        options: [
          { emoji: "🌳", label: "Tree", correct: true },
          { emoji: "🌺", label: "Flower", correct: false },
          { emoji: "☀️", label: "Sun", correct: false },
        ],
      },
      Family: {
        question: "Which one is the Family? 👨‍👩‍👧",
        options: [
          { emoji: "👨‍👩‍👧", label: "Family", correct: true },
          { emoji: "🏠", label: "House", correct: false },
          { emoji: "🎈", label: "Balloon", correct: false },
        ],
      },
      Vehicles: {
        question: "Which one is the Car? 🚗",
        options: [
          { emoji: "🚗", label: "Car", correct: true },
          { emoji: "🚲", label: "Bike", correct: false },
          { emoji: "✈️", label: "Plane", correct: false },
        ],
      },
      "Music & Sounds": {
        question: "Which one makes Music? 🎵",
        options: [
          { emoji: "🎸", label: "Guitar", correct: true },
          { emoji: "📚", label: "Book", correct: false },
          { emoji: "⚽", label: "Ball", correct: false },
        ],
      },
      "Numbers & Colors": {
        question: "Which number is THREE? 3️⃣",
        options: [
          { emoji: "1️⃣", label: "One", correct: false },
          { emoji: "3️⃣", label: "Three", correct: true },
          { emoji: "5️⃣", label: "Five", correct: false },
        ],
      },
    }

  const quiz = quizData[topic] || quizData["Animals"]

  const handleAnswer = (correct: boolean) => {
    setAnswered(true)
    setIsCorrect(correct)
    if (correct) {
      setShowConfetti(true)
      onCorrectAnswer()
    }
  }

  const handleContinue = () => {
    onComplete()
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-200 via-blue-200 to-purple-200 relative overflow-hidden">
      <TopHeader candyCount={candyCount} completedTopics={completedTopics} />

      <div className="pt-24 flex items-center justify-center p-6">
        {/* Confetti animation */}
        {showConfetti && (
          <>
            {[...Array(20)].map((_, i) => (
              <div
                key={i}
                className="absolute text-4xl animate-ping"
                style={{
                  left: `${Math.random() * 100}%`,
                  top: `${Math.random() * 100}%`,
                  animationDelay: `${Math.random() * 0.5}s`,
                  animationDuration: "1s",
                }}
              >
                {["🎉", "⭐", "🌟", "✨", "🎊"][Math.floor(Math.random() * 5)]}
              </div>
            ))}
          </>
        )}

        <div className="w-full max-w-3xl">
          {!answered ? (
            <div className="text-center">
              {/* Question */}
              <div className="mb-12">
                <h2 className="text-4xl md:text-5xl font-bold text-foreground mb-4 text-balance">{quiz.question}</h2>
                <p className="text-2xl text-foreground/70">Tap the right answer!</p>
              </div>

              {/* Options */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                {quiz.options.map((option, index) => (
                  <Card
                    key={index}
                    className="p-0 overflow-hidden border-0 shadow-xl hover:shadow-2xl transition-all duration-300 hover:scale-110 cursor-pointer rounded-[2rem]"
                    onClick={() => handleAnswer(option.correct)}
                  >
                    <div className="bg-white p-10 text-center flex flex-col items-center justify-center gap-4 h-full">
                      <div className="text-9xl animate-bounce-fun" style={{ animationDelay: `${index * 0.2}s` }}>
                        {option.emoji}
                      </div>
                      <p className="text-2xl font-bold text-foreground">{option.label}</p>
                    </div>
                  </Card>
                ))}
              </div>
            </div>
          ) : (
            <div className="text-center">
              {/* Result */}
              <div className="mb-12">
                <div className="text-[12rem] mb-8 animate-bounce-fun">{isCorrect ? "🎉" : "💭"}</div>
                <h2 className="text-5xl md:text-6xl font-bold text-foreground mb-4">
                  {isCorrect ? `Yay! You got a candy 🍬` : "Try Again!"}
                </h2>
                {isCorrect && (
                  <div className="flex items-center justify-center gap-2 mb-6">
                    <span className="text-6xl">⭐</span>
                    <span className="text-6xl">⭐</span>
                    <span className="text-6xl">⭐</span>
                  </div>
                )}
                {!isCorrect && (
                  <p className="text-3xl text-foreground/70 mb-8">Think about it again! You can do it! 💪</p>
                )}
              </div>

              {/* Continue button */}
              <Button
                onClick={handleContinue}
                size="lg"
                className="h-24 px-16 text-3xl font-bold rounded-[2rem] bg-gradient-to-r from-green-400 to-blue-400 hover:from-green-500 hover:to-blue-500 text-white shadow-2xl hover:shadow-3xl transition-all duration-300 hover:scale-110"
              >
                {isCorrect ? "Learn More! 🚀" : "Back to Topics 🏠"}
              </Button>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
