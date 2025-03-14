import type { User } from "../models/user"

export class UserService {
  // In a real application, this would interact with a database
  // For this example, we'll use an in-memory store
  private users: Map<string, User> = new Map()

  constructor() {
    // Add some sample users
    this.users.set("1", {
      id: "1",
      name: "John Doe",
      email: "john@example.com",
      phone: "+1234567890",
      address: "123 Main St, City, Country",
    })
  }

  async getUserById(id: string): Promise<User | null> {
    const user = this.users.get(id)
    return user || null
  }

  async getUserByEmail(email: string): Promise<User | null> {
    for (const user of this.users.values()) {
      if (user.email === email) {
        return user
      }
    }
    return null
  }

  async updateUser(id: string, userData: Partial<User>): Promise<User> {
    const existingUser = this.users.get(id)

    if (!existingUser) {
      throw new Error("User not found")
    }

    const updatedUser = {
      ...existingUser,
      ...userData,
    }

    this.users.set(id, updatedUser)
    return updatedUser
  }
}

