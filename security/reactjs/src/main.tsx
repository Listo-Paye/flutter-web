import React from "react"
import ReactDOM from "react-dom/client"
import App from "./App"
import "./index.css"

// Set security headers via meta tags
const metaCSP = document.createElement("meta")
metaCSP.httpEquiv = "Content-Security-Policy"
metaCSP.content =
  "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self' https://api.example.com"
document.head.appendChild(metaCSP)

const metaXContentType = document.createElement("meta")
metaXContentType.httpEquiv = "X-Content-Type-Options"
metaXContentType.content = "nosniff"
document.head.appendChild(metaXContentType)

const metaXFrame = document.createElement("meta")
metaXFrame.httpEquiv = "X-Frame-Options"
metaXFrame.content = "DENY"
document.head.appendChild(metaXFrame)

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)

