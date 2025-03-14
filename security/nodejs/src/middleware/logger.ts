import type { Request, Response, NextFunction } from "express"

export const logger = (req: Request, res: Response, next: NextFunction) => {
  const start = Date.now()

  res.on("finish", () => {
    const duration = Date.now() - start
    const log = {
      method: req.method,
      path: req.path,
      statusCode: res.statusCode,
      duration: `${duration}ms`,
      ip: req.ip,
      userAgent: req.get("User-Agent") || "unknown",
    }

    console.log(JSON.stringify(log))
  })

  next()
}

