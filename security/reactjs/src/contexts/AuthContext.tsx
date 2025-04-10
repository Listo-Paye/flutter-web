"use client"

import { createContext, useContext, useState, useEffect, type ReactNode } from "react"
import { UserManager, type User } from "oidc-client-ts"

interface AuthContextType {
  isAuthenticated: boolean
  isLoading: boolean
  user: User | null
  login: () => void
  logout: () => void
}

const AuthContext = createContext<AuthContextType | undefined>(undefined)

// Configure OIDC client
const userManager = new UserManager({
  authority: import.meta.env.VITE_KEYCLOAK_URL,
  client_id: import.meta.env.VITE_CLIENT_ID,
  redirect_uri: `${window.location.origin}/login`,
  response_type: "code",
  scope: "openid profile email",
  post_logout_redirect_uri: window.location.origin,
})

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Check if user is returning from authentication
    const handleSignInCallback = async () => {
      try {
        if (window.location.pathname === "/login" && window.location.search.includes("code=")) {
          const user = await userManager.signinRedirectCallback()
          setUser(user)
          window.history.replaceState({}, document.title, "/")
        } else {
          const currentUser = await userManager.getUser()
          setUser(currentUser)
        }
      } catch (error) {
        console.error("Authentication error:", error)
      } finally {
        setIsLoading(false)
      }
    }

    handleSignInCallback()

    // Event listeners for user session changes
    const handleUserLoaded = (user: User) => setUser(user)
    const handleUserUnloaded = () => setUser(null)
    const handleSilentRenewError = () => {
      console.error("Silent token renewal failed")
      logout()
    }

    userManager.events.addUserLoaded(handleUserLoaded)
    userManager.events.addUserUnloaded(handleUserUnloaded)
    userManager.events.addSilentRenewError(handleSilentRenewError)

    return () => {
      userManager.events.removeUserLoaded(handleUserLoaded)
      userManager.events.removeUserUnloaded(handleUserUnloaded)
      userManager.events.removeSilentRenewError(handleSilentRenewError)
    }
  }, [])

  const login = () => {
    userManager.signinRedirect()
  }

  const logout = () => {
    userManager.signoutRedirect()
  }

  return (
    <AuthContext.Provider
      value={{
        isAuthenticated: !!user && !user.expired,
        isLoading,
        user,
        login,
        logout,
      }}
    >
      {children}
    </AuthContext.Provider>
  )
}

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider")
  }
  return context
}

