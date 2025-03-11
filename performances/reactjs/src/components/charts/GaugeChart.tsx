"use client"

import { memo, useRef, useEffect } from "react"
import { Chart, registerables } from "chart.js"
import type { DataPoint } from "../../utils/dataGenerator"
import { useTheme } from "../../context/ThemeContext"

// Register Chart.js components
Chart.register(...registerables)

interface GaugeChartProps {
  data: DataPoint[]
  options?: Record<string, any>
}

const GaugeChart = ({ data, options = {} }: GaugeChartProps) => {
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

    // Get the value from the first data point
    const value = data[0]?.value || 0
    const min = options.min || 0
    const max = options.max || 100

    // Calculate percentage for coloring
    const percentage = (value - min) / (max - min)

    // Determine color based on percentage
    let color
    if (percentage < 0.3) {
      color = "#10b981" // Green
    } else if (percentage < 0.7) {
      color = "#f59e0b" // Yellow
    } else {
      color = "#ef4444" // Red
    }

    // Calculate the angle for the gauge
    const angle = percentage * Math.PI

    // Create new chart
    chartInstance.current = new Chart(ctx, {
      type: "doughnut",
      data: {
        datasets: [
          {
            data: [value, max - value],
            backgroundColor: [color, theme === "dark" ? "#374151" : "#e5e7eb"],
            borderWidth: 0,
            circumference: 180,
            rotation: 270,
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: "75%",
        animation: {
          duration: 500,
          easing: "easeOutQuart",
        },
        plugins: {
          legend: {
            display: false,
          },
          tooltip: {
            enabled: false,
          },
        },
        ...options,
      },
    })

    // Add center text
    const originalDraw = chartInstance.current.draw
    chartInstance.current.draw = function () {
      originalDraw.apply(this, arguments)

      if (ctx) {
        const width = this.width
        const height = this.height

        ctx.restore()
        ctx.font = "bold 24px Inter, sans-serif"
        ctx.textBaseline = "middle"
        ctx.textAlign = "center"

        const textColor = theme === "dark" ? "#ffffff" : "#111827"
        ctx.fillStyle = textColor
        ctx.fillText(`${Math.round(value)}%`, width / 2, height - 30)

        ctx.font = "14px Inter, sans-serif"
        ctx.fillStyle = theme === "dark" ? "#9ca3af" : "#6b7280"
        ctx.fillText(data[0]?.label || "Value", width / 2, height - 10)

        ctx.save()
      }
    }

    return () => {
      if (chartInstance.current) {
        chartInstance.current.destroy()
      }
    }
  }, [data, options, theme])

  // Update chart when data changes
  useEffect(() => {
    if (!chartInstance.current) return

    const value = data[0]?.value || 0
    const max = options.max || 100

    chartInstance.current.data.datasets[0].data = [value, max - value]
    chartInstance.current.update("none") // Use 'none' for performance
  }, [data, options])

  return <canvas ref={chartRef} className="w-full h-full" />
}

export default memo(GaugeChart)

