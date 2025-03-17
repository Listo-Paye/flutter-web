import { JSDOM } from "jsdom"
import createDOMPurify from "dompurify"

// Create DOMPurify instance
const window = new JSDOM("").window
const DOMPurify = createDOMPurify(window)

/**
 * Sanitizes user input to prevent XSS attacks
 */
export const sanitizeInput = (input: string): string => {
  if (!input) return ""

  return DOMPurify.sanitize(input, {
    ALLOWED_TAGS: [], // No HTML tags allowed
    ALLOWED_ATTR: [], // No attributes allowed
  })
}

/**
 * Escapes HTML to prevent XSS when displaying user content
 */
export const escapeHtml = (unsafe: string): string => {
  if (!unsafe) return ""

  return unsafe
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;")
}

