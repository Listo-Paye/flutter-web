import express from "express"
import helmet from "helmet"
import cors from "cors"
import rateLimit from "express-rate-limit"
import { userRouter } from "./routes/user"
import { errorHandler } from "./middleware/errorHandler"
import { logger } from "./middleware/logger"
import { config } from "./config"

const app = express()
const PORT = config.port || 3001

// Security middleware
app.use(helmet()) // Sets various HTTP headers for security
app.use(
  cors({
    origin: config.clientOrigins, // Only allow specific origins
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
    credentials: true,
    maxAge: 86400, // 24 hours
  }),
)

// Rate limiting to prevent brute force attacks
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  standardHeaders: true,
  legacyHeaders: false,
  message: "Too many requests from this IP, please try again after 15 minutes",
})
app.use(limiter)

// Body parsing middleware
app.use(express.json({ limit: "10kb" })) // Limit request body size
app.use(express.urlencoded({ extended: true, limit: "10kb" }))

// Logging middleware
app.use(logger)

// Routes
app.use("/api/users", userRouter)

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" })
})

// Error handling middleware
app.use(errorHandler)

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})

export default app

