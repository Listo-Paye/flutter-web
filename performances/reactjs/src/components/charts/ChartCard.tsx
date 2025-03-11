"use client"

import type React from "react"

import { memo, useState, useCallback } from "react"
import { motion } from "framer-motion"
import type { ChartData } from "../../utils/dataGenerator"
import LineChart from "./LineChart"
import BarChart from "./BarChart"
import PieChart from "./PieChart"
import GaugeChart from "./GaugeChart"
import AreaChart from "./AreaChart"
import ScatterChart from "./ScatterChart"
import { LucideRefreshCw, LucideMaximize } from "lucide-react"

interface ChartCardProps {
  chartId: string
  data: ChartData
  onClick: () => void
}

const ChartCard = ({ chartId, data, onClick }: ChartCardProps) => {
  const [isHovering, setIsHovering] = useState(false)
  const [isLoading, setIsLoading] = useState(false)

  const handleRefresh = useCallback((e: React.MouseEvent) => {
    e.stopPropagation()
    setIsLoading(true)

    // Simulate refresh delay
    setTimeout(() => {
      setIsLoading(false)
    }, 500)
  }, [])

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
    <motion.div
      className="overflow-hidden bg-white rounded-lg shadow-lg dark:bg-gray-800"
      whileHover={{ y: -5 }}
      onHoverStart={() => setIsHovering(true)}
      onHoverEnd={() => setIsHovering(false)}
      onClick={onClick}
      layout
    >
      <div className="relative p-4">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-gray-800 dark:text-white">{data.title}</h3>
          <div className="flex space-x-2">
            <motion.button
              className="p-1 text-gray-500 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 dark:text-gray-300"
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              onClick={handleRefresh}
              aria-label="Refresh chart"
            >
              <LucideRefreshCw className={`w-5 h-5 ${isLoading ? "animate-spin" : ""}`} />
            </motion.button>
            <motion.button
              className="p-1 text-gray-500 rounded-full hover:bg-gray-100 dark:hover:bg-gray-700 dark:text-gray-300"
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              aria-label="Expand chart"
            >
              <LucideMaximize className="w-5 h-5" />
            </motion.button>
          </div>
        </div>

        <div className="relative h-64">
          {renderChart()}

          {/* Overlay for loading state */}
          {isLoading && (
            <div className="absolute inset-0 flex items-center justify-center bg-white/50 dark:bg-gray-800/50">
              <div className="w-8 h-8 border-4 border-t-blue-500 rounded-full animate-spin"></div>
            </div>
          )}
        </div>
      </div>

      {/* Interactive footer that appears on hover */}
      <motion.div
        className="p-3 bg-gray-50 dark:bg-gray-700"
        initial={{ opacity: 0, height: 0 }}
        animate={{
          opacity: isHovering ? 1 : 0,
          height: isHovering ? "auto" : 0,
        }}
        transition={{ duration: 0.2 }}
      >
        <div className="flex items-center justify-between text-sm text-gray-500 dark:text-gray-400">
          <span>Updated just now</span>
          <span>Click to view details</span>
        </div>
      </motion.div>
    </motion.div>
  )
}

// Use memo to prevent unnecessary re-renders
export default memo(ChartCard)

