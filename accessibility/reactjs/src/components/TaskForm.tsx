"use client"

import type React from "react"

import { useState, useEffect, useRef } from "react"
import { useTaskContext, type TaskStatus } from "../context/TaskContext"

interface TaskFormProps {
  isOpen: boolean
  onClose: () => void
  taskId?: string
}

const TaskForm = ({ isOpen, onClose, taskId }: TaskFormProps) => {
  const { tasks, addTask, updateTask } = useTaskContext()
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    status: "à faire" as TaskStatus,
    assignee: "",
    dueDate: new Date().toISOString().split("T")[0],
  })

  const [errors, setErrors] = useState<Record<string, string>>({})
  const firstInputRef = useRef<HTMLInputElement>(null)

  // If taskId is provided, load task data
  useEffect(() => {
    if (taskId) {
      const task = tasks.find((t) => t.id === taskId)
      if (task) {
        setFormData({
          title: task.title,
          description: task.description,
          status: task.status,
          assignee: task.assignee,
          dueDate: new Date(task.dueDate).toISOString().split("T")[0],
        })
      }
    }
  }, [taskId, tasks])

  // Focus first input when modal opens
  useEffect(() => {
    if (isOpen && firstInputRef.current) {
      firstInputRef.current.focus()
    }
  }, [isOpen])

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement | HTMLSelectElement>) => {
    const { name, value } = e.target
    setFormData((prev) => ({ ...prev, [name]: value }))

    // Clear error when field is edited
    if (errors[name]) {
      setErrors((prev) => ({ ...prev, [name]: "" }))
    }
  }

  const validate = () => {
    const newErrors: Record<string, string> = {}

    if (!formData.title.trim()) {
      newErrors.title = "Le titre est requis"
    }

    if (!formData.assignee.trim()) {
      newErrors.assignee = "L'assigné est requis"
    }

    if (!formData.dueDate) {
      newErrors.dueDate = "La date d'échéance est requise"
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()

    if (!validate()) {
      return
    }

    if (taskId) {
      updateTask(taskId, formData)
    } else {
      addTask(formData)
    }

    onClose()
  }

  if (!isOpen) return null

  return (
    <div
      className="fixed inset-0 z-50 overflow-y-auto"
      role="dialog"
      aria-modal="true"
      aria-labelledby="task-form-title"
    >
      <div className="flex items-center justify-center min-h-screen p-4">
        <div className="fixed inset-0 bg-black bg-opacity-30" aria-hidden="true" onClick={onClose}></div>

        <div className="relative bg-white rounded-lg max-w-md w-full mx-auto shadow-xl">
          <div className="flex justify-between items-center p-4 border-b">
            <h3 className="text-lg font-medium text-gray-900" id="task-form-title">
              {taskId ? "Modifier la tâche" : "Nouvelle tâche"}
            </h3>
            <button
              type="button"
              className="text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 rounded-full p-1"
              onClick={onClose}
              aria-label="Fermer"
            >
              <svg
                className="h-5 w-5"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>

          <form onSubmit={handleSubmit} className="p-4">
            <div className="space-y-4">
              <div>
                <label htmlFor="title" className="block text-sm font-medium text-gray-700">
                  Titre <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  id="title"
                  name="title"
                  ref={firstInputRef}
                  className={`mt-1 block w-full rounded-md shadow-sm ${
                    errors.title
                      ? "border-red-300 focus:border-red-500 focus:ring-red-500"
                      : "border-gray-300 focus:border-blue-500 focus:ring-blue-500"
                  }`}
                  value={formData.title}
                  onChange={handleChange}
                  aria-invalid={errors.title ? "true" : "false"}
                  aria-describedby={errors.title ? "title-error" : undefined}
                />
                {errors.title && (
                  <p className="mt-1 text-sm text-red-600" id="title-error">
                    {errors.title}
                  </p>
                )}
              </div>

              <div>
                <label htmlFor="description" className="block text-sm font-medium text-gray-700">
                  Description
                </label>
                <textarea
                  id="description"
                  name="description"
                  rows={3}
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  value={formData.description}
                  onChange={handleChange}
                />
              </div>

              <div>
                <label htmlFor="status" className="block text-sm font-medium text-gray-700">
                  Statut
                </label>
                <select
                  id="status"
                  name="status"
                  className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                  value={formData.status}
                  onChange={handleChange}
                >
                  <option value="à faire">À faire</option>
                  <option value="en cours">En cours</option>
                  <option value="terminé">Terminé</option>
                </select>
              </div>

              <div>
                <label htmlFor="assignee" className="block text-sm font-medium text-gray-700">
                  Assigné à <span className="text-red-500">*</span>
                </label>
                <input
                  type="text"
                  id="assignee"
                  name="assignee"
                  className={`mt-1 block w-full rounded-md shadow-sm ${
                    errors.assignee
                      ? "border-red-300 focus:border-red-500 focus:ring-red-500"
                      : "border-gray-300 focus:border-blue-500 focus:ring-blue-500"
                  }`}
                  value={formData.assignee}
                  onChange={handleChange}
                  aria-invalid={errors.assignee ? "true" : "false"}
                  aria-describedby={errors.assignee ? "assignee-error" : undefined}
                />
                {errors.assignee && (
                  <p className="mt-1 text-sm text-red-600" id="assignee-error">
                    {errors.assignee}
                  </p>
                )}
              </div>

              <div>
                <label htmlFor="dueDate" className="block text-sm font-medium text-gray-700">
                  Date d'échéance <span className="text-red-500">*</span>
                </label>
                <input
                  type="date"
                  id="dueDate"
                  name="dueDate"
                  className={`mt-1 block w-full rounded-md shadow-sm ${
                    errors.dueDate
                      ? "border-red-300 focus:border-red-500 focus:ring-red-500"
                      : "border-gray-300 focus:border-blue-500 focus:ring-blue-500"
                  }`}
                  value={formData.dueDate}
                  onChange={handleChange}
                  aria-invalid={errors.dueDate ? "true" : "false"}
                  aria-describedby={errors.dueDate ? "dueDate-error" : undefined}
                />
                {errors.dueDate && (
                  <p className="mt-1 text-sm text-red-600" id="dueDate-error">
                    {errors.dueDate}
                  </p>
                )}
              </div>
            </div>

            <div className="mt-6 flex justify-end space-x-3">
              <button
                type="button"
                className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                onClick={onClose}
              >
                Annuler
              </button>
              <button
                type="submit"
                className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
              >
                {taskId ? "Mettre à jour" : "Créer"}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  )
}

export default TaskForm

