"use client"

import type { ReactNode } from "react"
import { useAuth } from "../contexts/AuthContext"
import { Link, useLocation } from "react-router-dom"

interface LayoutProps {
  children: ReactNode
}

const Layout = ({ children }: LayoutProps) => {
  const { logout, user } = useAuth()
  const location = useLocation()

  return (
    <div className="app-layout">
      <header className="app-header">
        <div className="logo">
          <Link to="/">User Management</Link>
        </div>
        <nav className="main-nav">
          <ul>
            <li className={location.pathname === "/" ? "active" : ""}>
              <Link to="/">Dashboard</Link>
            </li>
            <li className={location.pathname === "/profile" ? "active" : ""}>
              <Link to="/profile">Profile</Link>
            </li>
          </ul>
        </nav>
        <div className="user-menu">
          <span className="user-name">{user?.profile.name}</span>
          <button onClick={logout} className="logout-button">
            Logout
          </button>
        </div>
      </header>

      <main className="app-main">{children}</main>

      <footer className="app-footer">
        <p>&copy; {new Date().getFullYear()} Secure User Management</p>
      </footer>
    </div>
  )
}

export default Layout

