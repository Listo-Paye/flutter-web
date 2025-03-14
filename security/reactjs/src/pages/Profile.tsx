"use client"

import { useState } from "react"
import { useAuth } from "../contexts/AuthContext"
import { ProfileForm } from "../components/ProfileForm"
import { sanitizeInput } from "../utils/security"

interface ProfileData {
  name: string
  email: string
  phone: string
  address: string
}

const Profile = () => {
  const { user } = useAuth()
  const [isEditing, setIsEditing] = useState(false)
  const [profileData, setProfileData] = useState<ProfileData>({
    name: user?.profile.name || "",
    email: user?.profile.email || "",
    phone: user?.profile.phone_number || "",
    address: user?.profile.address?.formatted || "",
  })

  const [successMessage, setSuccessMessage] = useState("")
  const [errorMessage, setErrorMessage] = useState("")

  const handleSubmit = async (data: ProfileData) => {
    try {
      // Sanitize all inputs before sending to server
      const sanitizedData = {
        name: sanitizeInput(data.name),
        email: sanitizeInput(data.email),
        phone: sanitizeInput(data.phone),
        address: sanitizeInput(data.address),
      }

      // API call would go here
      console.log("Submitting sanitized data:", sanitizedData)

      // Simulate API call
      await new Promise((resolve) => setTimeout(resolve, 1000))

      setProfileData(sanitizedData)
      setIsEditing(false)
      setSuccessMessage("Profile updated successfully")
      setErrorMessage("")

      // Clear success message after 3 seconds
      setTimeout(() => setSuccessMessage(""), 3000)
    } catch (error) {
      setErrorMessage("Failed to update profile. Please try again.")
      setSuccessMessage("")
    }
  }

  return (
    <div className="profile-container">
      <h1>Profile Information</h1>

      {successMessage && <div className="alert alert-success">{successMessage}</div>}

      {errorMessage && <div className="alert alert-error">{errorMessage}</div>}

      {isEditing ? (
        <ProfileForm initialData={profileData} onSubmit={handleSubmit} onCancel={() => setIsEditing(false)} />
      ) : (
        <div className="profile-info">
          <div className="profile-field">
            <label>Name:</label>
            <p>{profileData.name}</p>
          </div>
          <div className="profile-field">
            <label>Email:</label>
            <p>{profileData.email}</p>
          </div>
          <div className="profile-field">
            <label>Phone:</label>
            <p>{profileData.phone}</p>
          </div>
          <div className="profile-field">
            <label>Address:</label>
            <p>{profileData.address}</p>
          </div>

          <button className="edit-button" onClick={() => setIsEditing(true)}>
            Edit Profile
          </button>
        </div>
      )}
    </div>
  )
}

export default Profile

