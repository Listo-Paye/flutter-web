"use client"

import { memo, useRef, useEffect } from "react"
import { Chart, registerables } from "chart.js"
import type { DataPoint } from "../../utils/dataGenerator"
import { useTheme } from "../../context/ThemeContext"

// Register Chart.js components
Chart.register(...registerables)

interface ScatterChartProps {
  data: DataPoint[]
  options?: Record<string, any>
}

const ScatterChart = ({ data, options = {} }: ScatterChartProps) => {
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

    // Prepare data for Chart.js
    const chartData = {
      datasets: [
        {
          label: "Data Points",
          data: data.map((point) => ({
            x: point.value,
            y: (point as any).secondaryValue || Math.random() * 100,
          })),
          backgroundColor: theme === "dark" ? "rgba(59, 130, 246, 0.7)" : "rgba(37, 99, 235, 0.7)",
          borderColor: theme === "dark" ? "#1e3a8a" : "#1e40af",
          borderWidth: 1,
          pointRadius: 6,
          pointHoverRadius: 8,
        },
      ],
    }

    // Create new chart
    chartInstance.current = new Chart(ctx, {
      type: "scatter",
      data: chartData,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: {
          duration: 500,
          easing: "easeOutQuart",
        },
        plugins: {
          legend: {
            display: false,
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
              label: (context) => `X: ${context.parsed.x.toFixed(1)}, Y: ${context.parsed.y.toFixed(1)}`,
            },
          },
        },
        scales: {
          x: {
            grid: {
              color: theme === "dark" ? "rgba(255, 255, 255, 0.1)" : "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: theme === "dark" ? "#9ca3af" : "#6b7280",
            },
          },
          y: {
            grid: {
              color: theme === "dark" ? "rgba(255, 255, 255, 0.1)" : "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: theme === "dark" ? "#9ca3af" : "#6b7280",
            },
          },
        },
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

    chartInstance.current.data.datasets[0].data = data.map((point) => ({
      x: point.value,
      y: (point as any).secondaryValue || Math.random() * 100,
    }))
    chartInstance.current.update("none") // Use 'none' for performance
  }, [data])

  return <canvas ref={chartRef} className="w-full h-full" />
}

export default memo(ScatterChart)

