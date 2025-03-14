import DOMPurify from "dompurify"
import { z } from "zod"

/**
 * Sanitizes user input to prevent XSS attacks
 */
export const sanitizeInput = (input: string): string => {
  return DOMPurify.sanitize(input, {
    ALLOWED_TAGS: [], // No HTML tags allowed
    ALLOWED_ATTR: [], // No attributes allowed
  })
}

/**
 * Validates input based on field type
 */
export const validateInput = (field: string, value: string) => {
  try {
    switch (field) {
      case "name":
        z.string().min(2).max(100).parse(value)
        break
      case "email":
        z.string().email().parse(value)
        break
      case "phone":
        z.string()
          .regex(/^\+?[0-9]{10,15}$/)
          .parse(value)
        break
      case "address":
        z.string().min(5).max(200).parse(value)
        break
      default:
        // For any other field, just ensure it's not empty and not too long
        z.string().min(1).max(500).parse(value)
    }
    return { isValid: true, error: "" }
  } catch (error) {
    if (error instanceof z.ZodError) {
      return { isValid: false, error: error.errors[0].message }
    }
    return { isValid: false, error: "Invalid input" }
  }
}

/**
 * Escapes HTML to prevent XSS when displaying user content
 */
export const escapeHtml = (unsafe: string): string => {
  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;")
}

/**
 * Validates and sanitizes form data
 */
export const validateAndSanitizeFormData = <T extends Record<string, string>>(
  data: T,
  schema: z.ZodSchema<any>,
): { isValid: boolean; sanitizedData?: T; errors?: Record<string, string> } => {
  try {
    // First validate with Zod
    schema.parse(data)

    // Then sanitize all string values
    const sanitizedData = Object.entries(data).reduce(
      (acc, [key, value]) => {
        if (typeof value === "string") {
          acc[key] = sanitizeInput(value)
        } else {
          acc[key] = value
        }
        return acc
      },
      {} as Record<string, any>,
    ) as T

    return { isValid: true, sanitizedData }
  } catch (error) {
    if (error instanceof z.ZodError) {
      const errors: Record<string, string> = {}
      error.errors.forEach((err) => {
        if (err.path[0]) {
          errors[err.path[0].toString()] = err.message
        }
      })
      return { isValid: false, errors }
    }
    return { isValid: false, errors: { form: "Invalid form data" } }
  }
}

