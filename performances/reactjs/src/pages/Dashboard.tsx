"use client"

import { useState, useEffect, useRef, memo } from "react"
import { motion } from "framer-motion"
import { useData } from "../context/DataContext"
import ChartCard from "../components/charts/ChartCard"
import ControlPanel from "../components/dashboard/ControlPanel"
import { useNavigate } from "react-router-dom"

const Dashboard = () => {
  const { chartData, updateInterval, setUpdateInterval, refreshData } = useData()
  const [isRefreshing, setIsRefreshing] = useState(false)
  const [cpuUsage, setCpuUsage] = useState<number | null>(null)
  const [memoryUsage, setMemoryUsage] = useState<number | null>(null)
  const [fps, setFps] = useState<number | null>(null)
  const fpsRef = useRef<number>(0)
  const frameCountRef = useRef<number>(0)
  const lastTimeRef = useRef<number>(performance.now())
  const navigate = useNavigate()

  // FPS counter
  useEffect(() => {
    let animationFrameId: number

    const updateFps = (time: number) => {
      frameCountRef.current++

      const elapsed = time - lastTimeRef.current

      if (elapsed >= 1000) {
        // Update every second
        fpsRef.current = Math.round((frameCountRef.current * 1000) / elapsed)
        setFps(fpsRef.current)
        frameCountRef.current = 0
        lastTimeRef.current = time
      }

      animationFrameId = requestAnimationFrame(updateFps)
    }

    animationFrameId = requestAnimationFrame(updateFps)

    return () => {
      cancelAnimationFrame(animationFrameId)
    }
  }, [])

  // Simulate CPU and memory monitoring
  useEffect(() => {
    const monitorResources = () => {
      // In a real app, you might use performance API
      // This is just a simulation
      setCpuUsage(Math.random() * 30 + 10) // 10-40%

      // Simulate memory usage in MB
      if (window.performance && (performance as any).memory) {
        const memoryInfo = (performance as any).memory
        setMemoryUsage(Math.round(memoryInfo.usedJSHeapSize / (1024 * 1024)))
      } else {
        // Fallback for browsers without memory API
        setMemoryUsage(Math.random() * 200 + 100) // 100-300MB
      }
    }

    const intervalId = setInterval(monitorResources, 2000)
    monitorResources() // Initial call

    return () => clearInterval(intervalId)
  }, [])

  const handleRefresh = () => {
    setIsRefreshing(true)
    refreshData()
    setTimeout(() => setIsRefreshing(false), 500)
  }

  const handleChartClick = (chartId: string) => {
    navigate(`/detailed/${chartId}`)
  }

  // Animation variants for staggered chart appearance
  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
      },
    },
  }

  const itemVariants = {
    hidden: { y: 20, opacity: 0 },
    visible: {
      y: 0,
      opacity: 1,
      transition: {
        type: "spring",
        stiffness: 100,
        damping: 12,
      },
    },
  }

  return (
    <div className="container px-4 mx-auto">
      <ControlPanel
        updateInterval={updateInterval}
        setUpdateInterval={setUpdateInterval}
        onRefresh={handleRefresh}
        isRefreshing={isRefreshing}
        cpuUsage={cpuUsage}
        memoryUsage={memoryUsage}
        fps={fps}
      />

      <motion.div
        className="grid grid-cols-1 gap-6 mt-6 md:grid-cols-2 lg:grid-cols-3"
        variants={containerVariants}
        initial="hidden"
        animate="visible"
      >
        {Object.entries(chartData).map(([chartId, data]) => (
          <motion.div key={chartId} variants={itemVariants} whileHover={{ scale: 1.02 }}>
            <ChartCard chartId={chartId} data={data} onClick={() => handleChartClick(chartId)} />
          </motion.div>
        ))}
      </motion.div>
    </div>
  )
}

// Use memo to prevent unnecessary re-renders
export default memo(Dashboard)

