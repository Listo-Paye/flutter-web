export interface User {
  id: string
  name: string
  email: string
  phone?: string
  address?: string
}

// Extended request type to include user information
declare global {
  namespace Express {
    interface Request {
      user?: {
        sub: string
        email?: string
        name?: string
        roles?: string[]
      }
    }
  }
}

