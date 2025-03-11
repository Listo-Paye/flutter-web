export interface DataPoint {
  label: string
  value: number
  secondaryValue?: number
  color?: string
}

export interface ChartData {
  type: "line" | "bar" | "pie" | "gauge" | "area" | "scatter"
  title: string
  data: DataPoint[]
  options?: Record<string, any>
}

const COLORS = [
  "#FF6384",
  "#36A2EB",
  "#FFCE56",
  "#4BC0C0",
  "#9966FF",
  "#FF9F40",
  "#8AC926",
  "#1982C4",
  "#6A4C93",
  "#F94144",
]

export function generateRandomData(type: ChartData["type"], count: number): ChartData {
  const data: DataPoint[] = []

  for (let i = 0; i < count; i++) {
    const point: DataPoint = {
      label: type === "line" || type === "area" ? `T${i}` : `Category ${i + 1}`,
      value: Math.floor(Math.random() * 100),
    }

    // Add secondary value for scatter plots
    if (type === "scatter") {
      point.secondaryValue = Math.floor(Math.random() * 100)
    }

    // Add colors for pie charts
    if (type === "pie") {
      point.color = COLORS[i % COLORS.length]
    }

    data.push(point)
  }

  return {
    type,
    title: `${type.charAt(0).toUpperCase() + type.slice(1)} Chart`,
    data,
    options: getDefaultOptions(type),
  }
}

function getDefaultOptions(type: ChartData["type"]) {
  switch (type) {
    case "line":
      return {
        tension: 0.4,
        fill: false,
        pointRadius: 3,
      }
    case "area":
      return {
        tension: 0.4,
        fill: true,
        pointRadius: 2,
      }
    case "gauge":
      return {
        min: 0,
        max: 100,
        arcWidth: 0.2,
      }
    default:
      return {}
  }
}

