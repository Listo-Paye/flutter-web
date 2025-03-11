"use client"

import { useState, useEffect, Suspense, lazy } from "react"
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom"
import { AnimatePresence } from "framer-motion"
import Navbar from "./components/navigation/Navbar"
import Sidebar from "./components/navigation/Sidebar"
import LoadingSpinner from "./components/ui/LoadingSpinner"
import { DataProvider } from "./context/DataContext"
import { ThemeProvider } from "./context/ThemeContext"
import "./App.css"

// Lazy load dashboard components for code splitting
const Dashboard = lazy(() => import("./pages/Dashboard"))
const DetailedView = lazy(() => import("./pages/DetailedView"))
const Settings = lazy(() => import("./pages/Settings"))

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Simulate initial data loading
    const timer = setTimeout(() => {
      setIsLoading(false)
    }, 1000)

    return () => clearTimeout(timer)
  }, [])

  const toggleSidebar = () => {
    setSidebarOpen(!sidebarOpen)
  }

  if (isLoading) {
    return <LoadingSpinner fullScreen />
  }

  return (
    <BrowserRouter>
      <ThemeProvider>
        <DataProvider>
          <div className="flex h-screen overflow-hidden bg-gray-100 dark:bg-gray-900">
            <Sidebar isOpen={sidebarOpen} toggleSidebar={toggleSidebar} />
            <div className="flex flex-col flex-1 w-0 overflow-hidden">
              <Navbar toggleSidebar={toggleSidebar} />
              <main className="relative flex-1 overflow-y-auto focus:outline-none">
                <div className="py-6">
                  <AnimatePresence mode="wait">
                    <Suspense fallback={<LoadingSpinner />}>
                      <Routes>
                        <Route path="/dashboard" element={<Dashboard />} />
                        <Route path="/detailed/:chartId" element={<DetailedView />} />
                        <Route path="/settings" element={<Settings />} />
                        <Route path="*" element={<Navigate to="/dashboard" replace />} />
                      </Routes>
                    </Suspense>
                  </AnimatePresence>
                </div>
              </main>
            </div>
          </div>
        </DataProvider>
      </ThemeProvider>
    </BrowserRouter>
  )
}

export default App

