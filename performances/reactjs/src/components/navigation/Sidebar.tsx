"use client"

import { memo } from "react"
import { NavLink } from "react-router-dom"
import { motion, AnimatePresence } from "framer-motion"
import {
  LucideLayoutDashboard,
  LucideBarChart,
  LucideSettings,
  LucideUsers,
  LucideActivity,
  LucideX,
} from "lucide-react"

interface SidebarProps {
  isOpen: boolean
  toggleSidebar: () => void
}

const Sidebar = ({ isOpen, toggleSidebar }: SidebarProps) => {
  const sidebarVariants = {
    open: {
      x: 0,
      transition: {
        type: "spring",
        stiffness: 300,
        damping: 30,
      },
    },
    closed: {
      x: "-100%",
      transition: {
        type: "spring",
        stiffness: 300,
        damping: 30,
      },
    },
  }

  const navItems = [
    { path: "/dashboard", icon: <LucideLayoutDashboard />, label: "Dashboard" },
    { path: "/settings", icon: <LucideSettings />, label: "Settings" },
  ]

  return (
    <>
      {/* Mobile sidebar */}
      <AnimatePresence>
        {isOpen && (
          <>
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 0.5 }}
              exit={{ opacity: 0 }}
              className="fixed inset-0 z-20 bg-black lg:hidden"
              onClick={toggleSidebar}
            />

            <motion.aside
              className="fixed top-0 bottom-0 left-0 z-30 w-64 bg-gray-800 lg:hidden"
              variants={sidebarVariants}
              initial="closed"
              animate="open"
              exit="closed"
            >
              <div className="flex items-center justify-between p-4 border-b border-gray-700">
                <h2 className="text-xl font-bold text-white">Dashboard</h2>
                <button
                  onClick={toggleSidebar}
                  className="p-2 text-gray-400 rounded-md hover:text-white hover:bg-gray-700"
                  aria-label="Close sidebar"
                >
                  <LucideX className="w-5 h-5" />
                </button>
              </div>

              <nav className="px-2 py-4">
                <ul className="space-y-2">
                  {navItems.map((item) => (
                    <li key={item.path}>
                      <NavLink
                        to={item.path}
                        className={({ isActive }) =>
                          `flex items-center px-4 py-2 text-gray-300 rounded-md transition-colors ${
                            isActive ? "bg-gray-700 text-white" : "hover:bg-gray-700 hover:text-white"
                          }`
                        }
                        onClick={() => toggleSidebar()}
                      >
                        <span className="mr-3">{item.icon}</span>
                        <span>{item.label}</span>
                      </NavLink>
                    </li>
                  ))}
                </ul>
              </nav>
            </motion.aside>
          </>
        )}
      </AnimatePresence>

      {/* Desktop sidebar */}
      <aside className="hidden w-64 bg-gray-800 lg:block">
        <div className="flex items-center justify-center h-16 px-4 border-b border-gray-700">
          <h2 className="text-xl font-bold text-white">Dashboard</h2>
        </div>

        <nav className="px-2 py-4">
          <ul className="space-y-2">
            {navItems.map((item) => (
              <li key={item.path}>
                <NavLink
                  to={item.path}
                  className={({ isActive }) =>
                    `flex items-center px-4 py-2 text-gray-300 rounded-md transition-colors ${
                      isActive ? "bg-gray-700 text-white" : "hover:bg-gray-700 hover:text-white"
                    }`
                  }
                >
                  <span className="mr-3">{item.icon}</span>
                  <span>{item.label}</span>
                </NavLink>
              </li>
            ))}
          </ul>
        </nav>
      </aside>
    </>
  )
}

export default memo(Sidebar)

