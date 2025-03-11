"use client"

import type React from "react"

import { useState, memo } from "react"
import { motion } from "framer-motion"
import { useData } from "../context/DataContext"
import { useTheme } from "../context/ThemeContext"

const Settings = () => {
  const { updateInterval, setUpdateInterval } = useData()
  const { theme, toggleTheme } = useTheme()
  const [showSuccessMessage, setShowSuccessMessage] = useState(false)

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    setShowSuccessMessage(true)

    setTimeout(() => {
      setShowSuccessMessage(false)
    }, 3000)
  }

  return (
    <div className="container px-4 mx-auto">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
        className="max-w-2xl mx-auto"
      >
        <h1 className="mb-6 text-2xl font-bold text-gray-800 dark:text-white">Dashboard Settings</h1>

        {showSuccessMessage && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="p-4 mb-6 text-green-700 bg-green-100 rounded-md dark:bg-green-800/30 dark:text-green-300"
          >
            Settings saved successfully!
          </motion.div>
        )}

        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="p-6 bg-white rounded-lg shadow-md dark:bg-gray-800">
            <h2 className="mb-4 text-xl font-semibold text-gray-800 dark:text-white">General Settings</h2>

            <div className="space-y-4">
              <div>
                <label className="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">Theme</label>
                <div className="flex items-center space-x-4">
                  <button
                    type="button"
                    onClick={toggleTheme}
                    className={`px-4 py-2 text-sm font-medium rounded-md ${
                      theme === "light"
                        ? "bg-blue-600 text-white"
                        : "bg-gray-200 text-gray-800 dark:bg-gray-700 dark:text-gray-300"
                    }`}
                  >
                    Light
                  </button>
                  <button
                    type="button"
                    onClick={toggleTheme}
                    className={`px-4 py-2 text-sm font-medium rounded-md ${
                      theme === "dark"
                        ? "bg-blue-600 text-white"
                        : "bg-gray-200 text-gray-800 dark:bg-gray-700 dark:text-gray-300"
                    }`}
                  >
                    Dark
                  </button>
                </div>
              </div>

              <div>
                <label
                  htmlFor="update-interval"
                  className="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300"
                >
                  Data Update Interval
                </label>
                <select
                  id="update-interval"
                  value={updateInterval}
                  onChange={(e) => setUpdateInterval(Number(e.target.value))}
                  className="block w-full px-3 py-2 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                >
                  <option value={500}>0.5 seconds (High CPU usage)</option>
                  <option value={1000}>1 second</option>
                  <option value={2000}>2 seconds</option>
                  <option value={5000}>5 seconds</option>
                </select>
                <p className="mt-1 text-sm text-gray-500 dark:text-gray-400">
                  Faster updates will increase CPU usage and may affect performance.
                </p>
              </div>
            </div>
          </div>

          <div className="p-6 bg-white rounded-lg shadow-md dark:bg-gray-800">
            <h2 className="mb-4 text-xl font-semibold text-gray-800 dark:text-white">Chart Settings</h2>

            <div className="space-y-4">
              <div>
                <label className="block mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">
                  Animation Speed
                </label>
                <div className="flex items-center">
                  <input
                    type="range"
                    min="100"
                    max="1000"
                    step="100"
                    defaultValue="500"
                    className="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer dark:bg-gray-700"
                  />
                </div>
                <div className="flex justify-between mt-1">
                  <span className="text-xs text-gray-500 dark:text-gray-400">Fast</span>
                  <span className="text-xs text-gray-500 dark:text-gray-400">Slow</span>
                </div>
              </div>

              <div className="flex items-center">
                <input
                  id="smooth-transitions"
                  type="checkbox"
                  defaultChecked
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700"
                />
                <label htmlFor="smooth-transitions" className="block ml-2 text-sm text-gray-700 dark:text-gray-300">
                  Enable smooth transitions
                </label>
              </div>

              <div className="flex items-center">
                <input
                  id="show-tooltips"
                  type="checkbox"
                  defaultChecked
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700"
                />
                <label htmlFor="show-tooltips" className="block ml-2 text-sm text-gray-700 dark:text-gray-300">
                  Show tooltips on hover
                </label>
              </div>
            </div>
          </div>

          <div className="p-6 bg-white rounded-lg shadow-md dark:bg-gray-800">
            <h2 className="mb-4 text-xl font-semibold text-gray-800 dark:text-white">Performance Settings</h2>

            <div className="space-y-4">
              <div className="flex items-center">
                <input
                  id="enable-fps-counter"
                  type="checkbox"
                  defaultChecked
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700"
                />
                <label htmlFor="enable-fps-counter" className="block ml-2 text-sm text-gray-700 dark:text-gray-300">
                  Show FPS counter
                </label>
              </div>

              <div className="flex items-center">
                <input
                  id="enable-performance-mode"
                  type="checkbox"
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700"
                />
                <label
                  htmlFor="enable-performance-mode"
                  className="block ml-2 text-sm text-gray-700 dark:text-gray-300"
                >
                  Enable high performance mode (reduces animations)
                </label>
              </div>

              <div className="flex items-center">
                <input
                  id="lazy-loading"
                  type="checkbox"
                  defaultChecked
                  className="w-4 h-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500 dark:border-gray-600 dark:bg-gray-700"
                />
                <label htmlFor="lazy-loading" className="block ml-2 text-sm text-gray-700 dark:text-gray-300">
                  Enable lazy loading for charts
                </label>
              </div>
            </div>
          </div>

          <div className="flex justify-end">
            <motion.button
              type="submit"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
              className="px-6 py-2 text-white bg-blue-600 rounded-md hover:bg-blue-700 dark:bg-blue-700 dark:hover:bg-blue-800"
            >
              Save Settings
            </motion.button>
          </div>
        </form>
      </motion.div>
    </div>
  )
}

export default memo(Settings)

