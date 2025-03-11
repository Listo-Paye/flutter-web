"use client"

import { useState, useEffect, useRef, memo } from "react"
import { useParams, useNavigate } from "react-router-dom"
import { motion } from "framer-motion"
import { useData } from "../context/DataContext"
import { LucideArrowLeft, LucideDownload, LucideRefreshCw, LucideZoomIn, LucideZoomOut } from "lucide-react"
import LineChart from "../components/charts/LineChart"
import BarChart from "../components/charts/BarChart"
import PieChart from "../components/charts/PieChart"
import GaugeChart from "../components/charts/GaugeChart"
import AreaChart from "../components/charts/AreaChart"
import ScatterChart from "../components/charts/ScatterChart"

const DetailedView = () => {
  const { chartId } = useParams<{ chartId: string }>()
  const { chartData } = useData()
  const navigate = useNavigate()
  const [zoomLevel, setZoomLevel] = useState(100)
  const [isLoading, setIsLoading] = useState(false)
  const chartContainerRef = useRef<HTMLDivElement>(null)

  // Check if chart exists
  useEffect(() => {
    if (!chartId || !chartData[chartId]) {
      navigate("/dashboard")
    }
  }, [chartId, chartData, navigate])

  if (!chartId || !chartData[chartId]) {
    return null
  }

  const data = chartData[chartId]

  const handleRefresh = () => {
    setIsLoading(true)
    setTimeout(() => {
      setIsLoading(false)
    }, 500)
  }

  const handleZoomIn = () => {
    setZoomLevel((prev) => Math.min(prev + 10, 150))
  }

  const handleZoomOut = () => {
    setZoomLevel((prev) => Math.max(prev - 10, 50))
  }

  const handleDownload = () => {
    if (!chartContainerRef.current) return

    // In a real app, you would implement actual chart download functionality
    alert("Chart download functionality would be implemented here")
  }

  const renderChart = () => {
    switch (data.type) {
      case "line":
        return <LineChart data={data.data} options={data.options} />
      case "bar":
        return <BarChart data={data.data} options={data.options} />
      case "pie":
        return <PieChart data={data.data} options={data.options} />
      case "gauge":
        return <GaugeChart data={data.data} options={data.options} />
      case "area":
        return <AreaChart data={data.data} options={data.options} />
      case "scatter":
        return <ScatterChart data={data.data} options={data.options} />
      default:
        return <div>Unsupported chart type</div>
    }
  }

  return (
    <div className="container px-4 mx-auto">
      <div className="mb-6">
        <motion.button
          onClick={() => navigate("/dashboard")}
          className="flex items-center text-blue-600 hover:text-blue-800 dark:text-blue-400 dark:hover:text-blue-300"
          whileHover={{ x: -5 }}
          whileTap={{ scale: 0.95 }}
        >
          <LucideArrowLeft className="w-5 h-5 mr-2" />
          Back to Dashboard
        </motion.button>
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
        className="p-6 bg-white rounded-lg shadow-lg dark:bg-gray-800"
      >
        <div className="flex flex-col justify-between mb-6 space-y-4 md:flex-row md:items-center md:space-y-0">
          <div>
            <h1 className="text-2xl font-bold text-gray-800 dark:text-white">{data.title} - Detailed View</h1>
            <p className="text-gray-500 dark:text-gray-400">Explore and analyze the data in detail</p>
          </div>

          <div className="flex flex-wrap gap-3">
            <motion.button
              onClick={handleRefresh}
              className="flex items-center px-3 py-2 text-sm text-white bg-blue-600 rounded-md hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <LucideRefreshCw className={`w-4 h-4 mr-2 ${isLoading ? "animate-spin" : ""}`} />
              Refresh
            </motion.button>

            <motion.button
              onClick={handleDownload}
              className="flex items-center px-3 py-2 text-sm text-gray-700 bg-gray-100 rounded-md hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <LucideDownload className="w-4 h-4 mr-2" />
              Download
            </motion.button>

            <div className="flex items-center rounded-md overflow-hidden">
              <motion.button
                onClick={handleZoomOut}
                className="flex items-center px-2 py-2 text-sm text-gray-700 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                disabled={zoomLevel <= 50}
              >
                <LucideZoomOut className="w-4 h-4" />
              </motion.button>

              <span className="px-3 py-2 text-sm text-gray-700 bg-gray-100 dark:bg-gray-700 dark:text-gray-300">
                {zoomLevel}%
              </span>

              <motion.button
                onClick={handleZoomIn}
                className="flex items-center px-2 py-2 text-sm text-gray-700 bg-gray-100 hover:bg-gray-200 dark:bg-gray-700 dark:text-gray-300 dark:hover:bg-gray-600"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                disabled={zoomLevel >= 150}
              >
                <LucideZoomIn className="w-4 h-4" />
              </motion.button>
            </div>
          </div>
        </div>

        <div
          ref={chartContainerRef}
          className="relative"
          style={{
            height: "500px",
            transform: `scale(${zoomLevel / 100})`,
            transformOrigin: "top left",
            transition: "transform 0.3s ease",
          }}
        >
          {renderChart()}

          {/* Overlay for loading state */}
          {isLoading && (
            <div className="absolute inset-0 flex items-center justify-center bg-white/50 dark:bg-gray-800/50">
              <div className="w-10 h-10 border-4 border-t-blue-500 rounded-full animate-spin"></div>
            </div>
          )}
        </div>

        <div className="grid grid-cols-1 gap-6 mt-8 md:grid-cols-2 lg:grid-cols-3">
          <div className="p-4 bg-gray-50 rounded-lg dark:bg-gray-700">
            <h3 className="mb-2 text-lg font-semibold text-gray-800 dark:text-white">Data Summary</h3>
            <ul className="space-y-2 text-gray-600 dark:text-gray-300">
              <li>Total data points: {data.data.length}</li>
              <li>
                Average value: {(data.data.reduce((sum, point) => sum + point.value, 0) / data.data.length).toFixed(2)}
              </li>
              <li>Max value: {Math.max(...data.data.map((point) => point.value)).toFixed(2)}</li>
              <li>Min value: {Math.min(...data.data.map((point) => point.value)).toFixed(2)}</li>
            </ul>
          </div>

          <div className="p-4 bg-gray-50 rounded-lg dark:bg-gray-700">
            <h3 className="mb-2 text-lg font-semibold text-gray-800 dark:text-white">Chart Information</h3>
            <ul className="space-y-2 text-gray-600 dark:text-gray-300">
              <li>Type: {data.type}</li>
              <li>Last updated: Just now</li>
              <li>Update frequency: Real-time</li>
              <li>Data source: Simulated</li>
            </ul>
          </div>

          <div className="p-4 bg-gray-50 rounded-lg dark:bg-gray-700">
            <h3 className="mb-2 text-lg font-semibold text-gray-800 dark:text-white">Actions</h3>
            <div className="space-y-2">
              <button className="w-full px-4 py-2 text-sm text-white bg-blue-600 rounded-md hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800">
                Export Data as CSV
              </button>
              <button className="w-full px-4 py-2 text-sm text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 dark:bg-gray-600 dark:text-gray-200 dark:border-gray-600 dark:hover:bg-gray-500">
                Share Chart
              </button>
            </div>
          </div>
        </div>
      </motion.div>
    </div>
  )
}

export default memo(DetailedView)

