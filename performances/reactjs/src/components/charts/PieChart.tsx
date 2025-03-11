"use client"

import { memo, useRef, useEffect } from "react"
import { Chart, registerables } from "chart.js"
import type { DataPoint } from "../../utils/dataGenerator"
import { useTheme } from "../../context/ThemeContext"

// Register Chart.js components
Chart.register(...registerables)

interface PieChartProps {
  data: DataPoint[]
  options?: Record<string, any>
}

const PieChart = ({ data, options = {} }: PieChartProps) => {
  const chartRef = useRef<HTMLCanvasElement>(null)
  const chartInstance = useRef<Chart | null>(null)
  const { theme } = useTheme()

  useEffect(() => {
    if (!chartRef.current) return

    const ctx = chartRef.current.getContext("2d")
    if (!ctx) return

    // Destroy existing chart
    if (chartInstance.current) {
      chartInstance.current.destroy()
    }

    // Default colors if not provided in data
    const defaultColors = [
      "#3b82f6",
      "#ef4444",
      "#10b981",
      "#f59e0b",
      "#8b5cf6",
      "#ec4899",
      "#6366f1",
      "#14b8a6",
      "#f97316",
      "#a855f7",
    ]

    // Prepare data for Chart.js
    const chartData = {
      labels: data.map((point) => point.label),
      datasets: [
        {
          data: data.map((point) => point.value),
          backgroundColor: data.map((point, index) => point.color || defaultColors[index % defaultColors.length]),
          borderColor: theme === "dark" ? "#1f2937" : "#ffffff",
          borderWidth: 2,
          hoverOffset: 15,
        },
      ],
    }

    // Create new chart
    chartInstance.current = new Chart(ctx, {
      type: "pie",
      data: chartData,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: {
          animateRotate: true,
          animateScale: true,
          duration: 500,
          easing: "easeOutQuart",
        },
        plugins: {
          legend: {
            position: "bottom",
            labels: {
              padding: 20,
              usePointStyle: true,
              pointStyle: "circle",
              color: theme === "dark" ? "#d1d5db" : "#4b5563",
            },
          },
          tooltip: {
            backgroundColor: theme === "dark" ? "#374151" : "#ffffff",
            titleColor: theme === "dark" ? "#ffffff" : "#111827",
            bodyColor: theme === "dark" ? "#d1d5db" : "#4b5563",
            borderColor: theme === "dark" ? "#4b5563" : "#e5e7eb",
            borderWidth: 1,
            padding: 10,
            boxPadding: 5,
            usePointStyle: true,
            callbacks: {
              label: (context) => {
                const total = context.dataset.data.reduce((sum: number, value: number) => sum + value, 0)
                const percentage = Math.round((context.parsed * 100) / total)
                return `${context.label}: ${context.parsed.toFixed(1)} (${percentage}%)`
              },
            },
          },
        },
        ...options,
      },
    })

    return () => {
      if (chartInstance.current) {
        chartInstance.current.destroy()
      }
    }
  }, [data, options, theme])

  // Update chart when data changes
  useEffect(() => {
    if (!chartInstance.current) return

    chartInstance.current.data.labels = data.map((point) => point.label)
    chartInstance.current.data.datasets[0].data = data.map((point) => point.value)
    chartInstance.current.update("none") // Use 'none' for performance
  }, [data])

  return <canvas ref={chartRef} className="w-full h-full" />
}

export default memo(PieChart)

