"use client"

import { useAuth } from "../contexts/AuthContext"
import { Card } from "../components/ui/Card"

const Dashboard = () => {
  const { user } = useAuth()

  return (
    <div className="dashboard-container">
      <h1>Dashboard</h1>
      <p>Welcome, {user?.profile.name || "User"}</p>

      <div className="dashboard-cards">
        <Card title="Personal Information" description="View and manage your personal information" link="/profile" />
        <Card title="Security Settings" description="Manage your security preferences and password" link="/security" />
        <Card title="Notifications" description="Configure your notification preferences" link="/notifications" />
      </div>
    </div>
  )
}

export default Dashboard

