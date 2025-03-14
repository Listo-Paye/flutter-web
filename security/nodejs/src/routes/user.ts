import express from "express"
import { body, param } from "express-validator"
import { validateRequest } from "../middleware/validateRequest"
import { authMiddleware } from "../middleware/auth"
import { UserController } from "../controllers/userController"

const router = express.Router()
const userController = new UserController()

// Get user profile
router.get("/profile", authMiddleware, userController.getProfile)

// Update user profile
router.put(
  "/profile",
  authMiddleware,
  [
    body("name").trim().isLength({ min: 2, max: 100 }).withMessage("Name must be between 2 and 100 characters"),
    body("email").isEmail().withMessage("Must be a valid email address").normalizeEmail(),
    body("phone")
      .optional()
      .matches(/^\+?[0-9]{10,15}$/)
      .withMessage("Must be a valid phone number"),
    body("address")
      .optional()
      .trim()
      .isLength({ min: 5, max: 200 })
      .withMessage("Address must be between 5 and 200 characters"),
  ],
  validateRequest,
  userController.updateProfile,
)

// Get user by ID (admin only)
router.get(
  "/:id",
  authMiddleware,
  [param("id").isUUID().withMessage("Invalid user ID")],
  validateRequest,
  userController.getUserById,
)

export { router as userRouter }

