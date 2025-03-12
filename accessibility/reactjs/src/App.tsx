"use client"

import { useState } from "react"
import Header from "./components/Header"
import Sidebar from "./components/Sidebar"
import TaskDashboard from "./components/TaskDashboard"
import Footer from "./components/Footer"
import TaskModal from "./components/TaskModal"
import { useTaskContext } from "./context/TaskContext"

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const { selectedTask, setSelectedTask } = useTaskContext()

  // Skip to content link for keyboard users
  return (
    <div className="flex flex-col min-h-screen bg-gray-50">
      <a
        href="#main-content"
        className="sr-only focus:not-sr-only focus:absolute focus:z-50 focus:p-4 focus:bg-white focus:text-blue-700"
      >
        Aller au contenu principal
      </a>

      <Header onMenuToggle={() => setSidebarOpen(!sidebarOpen)} />

      <div className="flex flex-1 overflow-hidden">
        <Sidebar isOpen={sidebarOpen} onClose={() => setSidebarOpen(false)} />

        <main id="main-content" className="flex-1 overflow-auto p-4 md:p-6" tabIndex={-1}>
          <TaskDashboard />
        </main>
      </div>

      <Footer />

      {selectedTask && <TaskModal isOpen={!!selectedTask} onClose={() => setSelectedTask(null)} />}
    </div>
  )
}

export default App

