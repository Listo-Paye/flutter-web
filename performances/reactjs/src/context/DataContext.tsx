"use client"

import { createContext, useContext, useState, useEffect, useCallback, type ReactNode } from "react"
import { generateRandomData, type DataPoint, type ChartData } from "../utils/dataGenerator"

interface DataContextType {
  chartData: Record<string, ChartData>
  isLoading: boolean
  updateInterval: number
  setUpdateInterval: (interval: number) => void
  refreshData: () => void
}

const DataContext = createContext<DataContextType | undefined>(undefined)

export const useData = () => {
  const context = useContext(DataContext)
  if (!context) {
    throw new Error("useData must be used within a DataProvider")
  }
  return context
}

interface DataProviderProps {
  children: ReactNode
}

export const DataProvider = ({ children }: DataProviderProps) => {
  const [chartData, setChartData] = useState<Record<string, ChartData>>({})
  const [isLoading, setIsLoading] = useState(true)
  const [updateInterval, setUpdateInterval] = useState(500) // 2 seconds default
  const [updateTimer, setUpdateTimer] = useState<number | null>(null)

  // Generate initial data
  const initializeData = useCallback(() => {
    setIsLoading(true)
    const initialData = {
      "line-chart": generateRandomData("line", 20),
      "bar-chart": generateRandomData("bar", 12),
      "pie-chart": generateRandomData("pie", 6),
      "gauge-chart": generateRandomData("gauge", 1),
      "area-chart": generateRandomData("area", 15),
      "scatter-chart": generateRandomData("scatter", 30),
    }
    setChartData(initialData)
    setIsLoading(false)
  }, [])

  // Function to refresh all data
  const refreshData = useCallback(() => {
    // Create a copy of the current data
    const newData = { ...chartData }

    // Update each chart with new data points
    Object.keys(newData).forEach((chartId) => {
      const currentData = newData[chartId]

      // Different update logic based on chart type
      switch (currentData.type) {
        case "line":
        case "area":
          // Add a new point and remove the oldest one
          const newPoint: DataPoint = {
            label: `T${currentData.data.length + 1}`,
            value: Math.random() * 100,
          }
          newData[chartId] = {
            ...currentData,
            data: [...currentData.data.slice(1), newPoint],
          }
          break

        case "bar":
          // Update existing bar values
          newData[chartId] = {
            ...currentData,
            data: currentData.data.map((point) => ({
              ...point,
              value: point.value + (Math.random() * 10 - 5), // Add or subtract up to 5
            })),
          }
          break

        case "pie":
          // Update pie chart segments
          newData[chartId] = {
            ...currentData,
            data: currentData.data.map((point) => ({
              ...point,
              value: Math.max(5, point.value + (Math.random() * 10 - 5)),
            })),
          }
          break

        case "gauge":
          // Update gauge value
          newData[chartId] = {
            ...currentData,
            data: [
              {
                ...currentData.data[0],
                value: Math.min(100, Math.max(0, currentData.data[0].value + (Math.random() * 10 - 5))),
              },
            ],
          }
          break

        case "scatter":
          // Update scatter plot points
          newData[chartId] = {
            ...currentData,
            data: currentData.data.map((point) => ({
              ...point,
              value: point.value + (Math.random() * 6 - 3),
              secondaryValue: (point as any).secondaryValue + (Math.random() * 6 - 3),
            })),
          }
          break
      }
    })

    setChartData(newData)
  }, [chartData])

  // Initialize data on first load
  useEffect(() => {
    initializeData()
  }, [initializeData])

  // Set up the interval for real-time updates
  useEffect(() => {
    if (updateTimer) {
      window.clearInterval(updateTimer)
    }

    const timer = window.setInterval(() => {
      refreshData()
    }, updateInterval)

    setUpdateTimer(timer)

    return () => {
      if (timer) window.clearInterval(timer)
    }
  }, [updateInterval, refreshData])

  const value = {
    chartData,
    isLoading,
    updateInterval,
    setUpdateInterval,
    refreshData,
  }

  return <DataContext.Provider value={value}>{children}</DataContext.Provider>
}

