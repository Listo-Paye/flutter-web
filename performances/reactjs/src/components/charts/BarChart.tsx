"use client"

import { memo, useRef, useEffect } from "react"
import { Chart, registerables } from "chart.js"
import type { DataPoint } from "../../utils/dataGenerator"
import { useTheme } from "../../context/ThemeContext"

// Register Chart.js components
Chart.register(...registerables)

interface BarChartProps {
  data: DataPoint[]
  options?: Record<string, any>
}

const BarChart = ({ data, options = {} }: BarChartProps) => {
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

    // Prepare colors
    const colors =
      theme === "dark"
        ? ["#3b82f6", "#60a5fa", "#93c5fd", "#bfdbfe", "#dbeafe", "#eff6ff"]
        : ["#2563eb", "#3b82f6", "#60a5fa", "#93c5fd", "#bfdbfe", "#dbeafe"]

    // Prepare data for Chart.js
    const chartData = {
      labels: data.map((point) => point.label),
      datasets: [
        {
          label: "Value",
          data: data.map((point) => point.value),
          backgroundColor: data.map((_, index) => colors[index % colors.length]),
          borderColor: theme === "dark" ? "#1e3a8a" : "#1e40af",
          borderWidth: 1,
          borderRadius: 4,
          hoverOffset: 4,
        },
      ],
    }

    // Create new chart
    chartInstance.current = new Chart(ctx, {
      type: "bar",
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
            mode: "index",
            intersect: false,
            backgroundColor: theme === "dark" ? "#374151" : "#ffffff",
            titleColor: theme === "dark" ? "#ffffff" : "#111827",
            bodyColor: theme === "dark" ? "#d1d5db" : "#4b5563",
            borderColor: theme === "dark" ? "#4b5563" : "#e5e7eb",
            borderWidth: 1,
            padding: 10,
            boxPadding: 5,
            usePointStyle: true,
            callbacks: {
              label: (context) => `Value: ${context.parsed.y.toFixed(1)}`,
            },
          },
        },
        scales: {
          x: {
            grid: {
              display: false,
              color: theme === "dark" ? "rgba(255, 255, 255, 0.1)" : "rgba(0, 0, 0, 0.1)",
            },
            ticks: {
              color: theme === "dark" ? "#9ca3af" : "#6b7280",
              maxRotation: 0,
              autoSkip: true,
              maxTicksLimit: 10,
            },
          },
          y: {
            beginAtZero: true,
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

    chartInstance.current.data.labels = data.map((point) => point.label)
    chartInstance.current.data.datasets[0].data = data.map((point) => point.value)
    chartInstance.current.update("none") // Use 'none' for performance
  }, [data])

  return <canvas ref={chartRef} className="w-full h-full" />
}

export default memo(BarChart)

