import { memo } from "react"

interface LoadingSpinnerProps {
  fullScreen?: boolean
}

const LoadingSpinner = ({ fullScreen = false }: LoadingSpinnerProps) => {
  if (fullScreen) {
    return (
      <div className="fixed inset-0 z-50 flex items-center justify-center bg-white dark:bg-gray-900">
        <div className="flex flex-col items-center">
          <div className="w-16 h-16 border-4 border-t-blue-500 border-b-blue-700 rounded-full animate-spin"></div>
          <p className="mt-4 text-lg font-medium text-gray-700 dark:text-gray-300">Loading...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="flex items-center justify-center p-8">
      <div className="w-10 h-10 border-4 border-t-blue-500 border-b-blue-700 rounded-full animate-spin"></div>
    </div>
  )
}

export default memo(LoadingSpinner)

