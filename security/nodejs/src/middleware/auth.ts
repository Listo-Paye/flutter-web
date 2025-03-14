import type { Request, Response, NextFunction } from "express"
import jwt from "jsonwebtoken"
import { config } from "../config"

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
  try {
    // Get the token from the Authorization header
    const authHeader = req.headers.authorization

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ message: "Unauthorized: No token provided" })
    }

    const token = authHeader.split(" ")[1]

    // Verify the token
    const decoded = jwt.verify(token, config.jwtSecret)

    // Add user info to request
    req.user = decoded as any

    next()
  } catch (error) {
    console.error("Authentication error:", error)
    return res.status(401).json({ message: "Unauthorized: Invalid token" })
  }
}

