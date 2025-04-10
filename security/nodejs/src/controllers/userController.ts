import type { Request, Response } from "express"
import { sanitizeInput } from "../utils/security"
import { UserService } from "../services/userService"

export class UserController {
  private userService: UserService

  constructor() {
    this.userService = new UserService()
  }

  // Get user profile
  getProfile = async (req: Request, res: Response) => {
    try {
      const userId = req.user?.sub

      if (!userId) {
        return res.status(401).json({ message: "Unauthorized" })
      }

      const user = await this.userService.getUserById(userId)

      if (!user) {
        return res.status(404).json({ message: "User not found" })
      }

      // Return user data without sensitive information
      return res.status(200).json({
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone || "",
        address: user.address || "",
      })
    } catch (error) {
      console.error("Error getting user profile:", error)
      return res.status(500).json({ message: "Internal server error" })
    }
  }

  // Update user profile
  updateProfile = async (req: Request, res: Response) => {
    try {
      const userId = req.user?.sub

      if (!userId) {
        return res.status(401).json({ message: "Unauthorized" })
      }

      // Sanitize all inputs
      const sanitizedData = {
        name: sanitizeInput(req.body.name),
        email: sanitizeInput(req.body.email),
        phone: req.body.phone ? sanitizeInput(req.body.phone) : undefined,
        address: req.body.address ? sanitizeInput(req.body.address) : undefined,
      }

      const updatedUser = await this.userService.updateUser(userId, sanitizedData)

      return res.status(200).json({
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
        phone: updatedUser.phone || "",
        address: updatedUser.address || "",
      })
    } catch (error) {
      console.error("Error updating user profile:", error)
      return res.status(500).json({ message: "Internal server error" })
    }
  }

  // Get user by ID (admin only)
  getUserById = async (req: Request, res: Response) => {
    try {
      // Check if user has admin role
      const isAdmin = req.user?.roles?.includes("admin")

      if (!isAdmin) {
        return res.status(403).json({ message: "Forbidden" })
      }

      const userId = req.params.id
      const user = await this.userService.getUserById(userId)

      if (!user) {
        return res.status(404).json({ message: "User not found" })
      }

      return res.status(200).json({
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone || "",
        address: user.address || "",
      })
    } catch (error) {
      console.error("Error getting user by ID:", error)
      return res.status(500).json({ message: "Internal server error" })
    }
  }
}

