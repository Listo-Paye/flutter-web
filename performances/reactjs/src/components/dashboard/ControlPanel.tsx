"use client"

import { memo } from "react"
import { motion } from "framer-motion"
import { LucideRefreshCw, LucideCpu, LucideHardDrive, LucideZap } from "lucide-react"

interface ControlPanelProps {
  updateInterval: number
  setUpdateInterval: (interval: number) => void
  onRefresh: () => void
  isRefreshing: boolean
  cpuUsage: number | null
  memoryUsage: number | null
  fps: number | null
}

const ControlPanel = ({
  updateInterval,
  setUpdateInterval,
  onRefresh,
  isRefreshing,
  cpuUsage,
  memoryUsage,
  fps,
}: ControlPanelProps) => {
  return (
    <motion.div
      className="p-4 bg-white rounded-lg shadow-md dark:bg-gray-800"
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <div className="flex flex-col items-start justify-between gap-4 md:flex-row md:items-center">
        <div>
          <h2 className="text-xl font-bold text-gray-800 dark:text-white">Dashboard Controls</h2>
          <p className="text-sm text-gray-500 dark:text-gray-400">Adjust update frequency and monitor performance</p>
        </div>

        <div className="flex flex-wrap items-center gap-4">
          {/* Performance metrics */}
          <div className="flex gap-4">
            <div className="flex items-center gap-2 p-2 bg-gray-100 rounded-md dark:bg-gray-700">
              <LucideCpu className="w-4 h-4 text-blue-500" />
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                CPU: {cpuUsage !== null ? `${cpuUsage.toFixed(1)}%` : "N/A"}
              </span>
            </div>

            <div className="flex items-center gap-2 p-2 bg-gray-100 rounded-md dark:bg-gray-700">
              <LucideHardDrive className="w-4 h-4 text-green-500" />
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                Memory: {memoryUsage !== null ? `${memoryUsage.toFixed(0)} MB` : "N/A"}
              </span>
            </div>

            <div className="flex items-center gap-2 p-2 bg-gray-100 rounded-md dark:bg-gray-700">
              <LucideZap className="w-4 h-4 text-yellow-500" />
              <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
                FPS: {fps !== null ? fps : "N/A"}
              </span>
            </div>
          </div>

          {/* Update interval control */}
          <div className="flex items-center gap-2">
            <label htmlFor="update-interval" className="text-sm font-medium text-gray-700 dark:text-gray-300">
              Update every:
            </label>
            <select
              id="update-interval"
              value={updateInterval}
              onChange={(e) => setUpdateInterval(Number(e.target.value))}
              className="px-2 py-1 text-sm bg-white border border-gray-300 rounded-md dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            >
              <option value={500}>0.5s</option>
              <option value={1000}>1s</option>
              <option value={2000}>2s</option>
              <option value={5000}>5s</option>
            </select>
          </div>

          {/* Refresh button */}
          <motion.button
            onClick={onRefresh}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            className="flex items-center gap-2 px-4 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800"
          >
            <LucideRefreshCw className={`w-4 h-4 ${isRefreshing ? "animate-spin" : ""}`} />
            <span>Refresh All</span>
          </motion.button>
        </div>
      </div>
    </motion.div>
  )
}

export default memo(ControlPanel)

