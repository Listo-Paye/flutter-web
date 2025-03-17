"use client"

import { useEffect } from "react"
import { useNavigate } from "react-router-dom"
import { useAuth } from "../contexts/AuthContext"

const Login = () => {
  const { isAuthenticated, isLoading, login } = useAuth()
  const navigate = useNavigate()

  useEffect(() => {
    if (isAuthenticated && !isLoading) {
      navigate("/")
    }
  }, [isAuthenticated, isLoading, navigate])

  return (
    <div className="login-container">
      <div className="login-card">
        <h1>User Account Management</h1>
        <p>Secure authentication and profile management</p>
        <button onClick={login} className="login-button" disabled={isLoading}>
          {isLoading ? "Loading..." : "Login with Keycloak"}
        </button>
      </div>
    </div>
  )
}

export default Login

