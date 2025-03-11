"use client"

import { memo } from "react"
import { motion } from "framer-motion"
import { LucideMenu, LucideBell, LucideUser, LucideMoon, LucideSun } from "lucide-react"
import { useTheme } from "../../context/ThemeContext"

interface NavbarProps {
  toggleSidebar: () => void
}

const Navbar = ({ toggleSidebar }: NavbarProps) => {
  const { theme, toggleTheme } = useTheme()

  return (
    <nav className="sticky top-0 z-10 flex items-center justify-between h-16 px-4 bg-white shadow-sm dark:bg-gray-800">
      <div className="flex items-center">
        <motion.button
          onClick={toggleSidebar}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          className="p-2 mr-4 text-gray-500 rounded-md lg:hidden hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700"
          aria-label="Toggle sidebar"
        >
          <LucideMenu className="w-6 h-6" />
        </motion.button>

        <h1 className="text-xl font-bold text-gray-800 dark:text-white">React Performance Dashboard</h1>
      </div>

      <div className="flex items-center space-x-4">
        <motion.button
          onClick={toggleTheme}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          className="p-2 text-gray-500 rounded-full hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700"
          aria-label={theme === "dark" ? "Switch to light mode" : "Switch to dark mode"}
        >
          {theme === "dark" ? <LucideSun className="w-5 h-5" /> : <LucideMoon className="w-5 h-5" />}
        </motion.button>

        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          className="relative p-2 text-gray-500 rounded-full hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700"
          aria-label="View notifications"
        >
          <LucideBell className="w-5 h-5" />
          <span className="absolute top-0 right-0 flex items-center justify-center w-4 h-4 text-xs text-white bg-red-500 rounded-full">
            3
          </span>
        </motion.button>

        <motion.div whileHover={{ scale: 1.05 }} className="flex items-center cursor-pointer">
          <div className="flex items-center justify-center w-8 h-8 mr-2 text-white bg-blue-600 rounded-full">
            <LucideUser className="w-4 h-4" />
          </div>
          <span className="hidden text-sm font-medium text-gray-700 md:block dark:text-gray-300">Admin User</span>
        </motion.div>
      </div>
    </nav>
  )
}

export default memo(Navbar)

