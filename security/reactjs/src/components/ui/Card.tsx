import { Link } from "react-router-dom"

interface CardProps {
  title: string
  description: string
  link: string
}

export const Card = ({ title, description, link }: CardProps) => {
  return (
    <div className="card">
      <div className="card-content">
        <h3 className="card-title">{title}</h3>
        <p className="card-description">{description}</p>
      </div>
      <div className="card-actions">
        <Link to={link} className="card-link">
          Manage
        </Link>
      </div>
    </div>
  )
}

