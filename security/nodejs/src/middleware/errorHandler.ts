import type { Request, Response, NextFunction } from "express"

export const errorHandler = (err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error("Error:", err)

  // Don't expose error details in production
  const isProduction = process.env.NODE_ENV === "production"

  return res.status(500).json({
    message: "Internal server error",
    ...(isProduction ? {} : { error: err.message, stack: err.stack }),
  })
}

