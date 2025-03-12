"use client"

import { useState } from "react"
import { useTaskContext, type TaskStatus } from "../context/TaskContext"
import TaskForm from "./TaskForm"

interface TaskModalProps {
  isOpen: boolean
  onClose: () => void
}

const TaskModal = ({ isOpen, onClose }: TaskModalProps) => {
  const { selectedTask, updateTask, deleteTask, setSelectedTask } = useTaskContext()
  const [isEditing, setIsEditing] = useState(false)
  const [confirmDelete, setConfirmDelete] = useState(false)

  if (!selectedTask || !isOpen) return null

  // Status color mapping
  const statusColors: Record<TaskStatus, string> = {
    "à faire": "bg-yellow-100 text-yellow-800",
    "en cours": "bg-blue-100 text-blue-800",
    terminé: "bg-green-100 text-green-800",
  }

  const handleStatusChange = (newStatus: TaskStatus) => {
    updateTask(selectedTask.id, { status: newStatus })
  }

  const handleDelete = () => {
    deleteTask(selectedTask.id)
    onClose()
  }

  // If in edit mode, show the form
  if (isEditing) {
    return <TaskForm isOpen={isEditing} onClose={() => setIsEditing(false)} taskId={selectedTask.id} />
  }

  return (
    <div
      className="fixed inset-0 z-50 overflow-y-auto"
      role="dialog"
      aria-modal="true"
      aria-labelledby="task-modal-title"
    >
      <div className="flex items-center justify-center min-h-screen p-4">
        <div className="fixed inset-0 bg-black bg-opacity-30" aria-hidden="true" onClick={onClose}></div>

        <div className="relative bg-white rounded-lg max-w-lg w-full mx-auto shadow-xl">
          <div className="flex justify-between items-start p-4 border-b">
            <h3 className="text-lg font-medium text-gray-900" id="task-modal-title">
              {selectedTask.title}
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

          <div className="p-4">
            <div className="space-y-4">
              <div>
                <span
                  className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium ${statusColors[selectedTask.status]}`}
                >
                  {selectedTask.status}
                </span>
              </div>

              <div>
                <h4 className="text-sm font-medium text-gray-500">Description</h4>
                <p className="mt-1 text-sm text-gray-900 whitespace-pre-line">
                  {selectedTask.description || "Aucune description"}
                </p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h4 className="text-sm font-medium text-gray-500">Assigné à</h4>
                  <p className="mt-1 text-sm text-gray-900">{selectedTask.assignee}</p>
                </div>

                <div>
                  <h4 className="text-sm font-medium text-gray-500">Date d'échéance</h4>
                  <p className="mt-1 text-sm text-gray-900">{new Date(selectedTask.dueDate).toLocaleDateString()}</p>
                </div>
              </div>

              <div>
                <h4 className="text-sm font-medium text-gray-500">Créée le</h4>
                <p className="mt-1 text-sm text-gray-900">{new Date(selectedTask.createdAt).toLocaleDateString()}</p>
              </div>
            </div>

            <div className="mt-6 border-t pt-4">
              <h4 className="text-sm font-medium text-gray-500 mb-2">Changer le statut</h4>
              <div className="flex flex-wrap gap-2">
                <button
                  type="button"
                  className={`px-3 py-1.5 text-xs font-medium rounded-md ${
                    selectedTask.status === "à faire"
                      ? "bg-yellow-100 text-yellow-800 border-2 border-yellow-400"
                      : "bg-gray-100 text-gray-800 hover:bg-yellow-50"
                  }`}
                  onClick={() => handleStatusChange("à faire")}
                  aria-pressed={selectedTask.status === "à faire"}
                >
                  À faire
                </button>
                <button
                  type="button"
                  className={`px-3 py-1.5 text-xs font-medium rounded-md ${
                    selectedTask.status === "en cours"
                      ? "bg-blue-100 text-blue-800 border-2 border-blue-400"
                      : "bg-gray-100 text-gray-800 hover:bg-blue-50"
                  }`}
                  onClick={() => handleStatusChange("en cours")}
                  aria-pressed={selectedTask.status === "en cours"}
                >
                  En cours
                </button>
                <button
                  type="button"
                  className={`px-3 py-1.5 text-xs font-medium rounded-md ${
                    selectedTask.status === "terminé"
                      ? "bg-green-100 text-green-800 border-2 border-green-400"
                      : "bg-gray-100 text-gray-800 hover:bg-green-50"
                  }`}
                  onClick={() => handleStatusChange("terminé")}
                  aria-pressed={selectedTask.status === "terminé"}
                >
                  Terminé
                </button>
              </div>
            </div>

            <div className="mt-6 flex justify-between">
              <div>
                {confirmDelete ? (
                  <div className="flex items-center space-x-2">
                    <span className="text-sm text-red-600">Confirmer la suppression ?</span>
                    <button
                      type="button"
                      className="px-3 py-1.5 text-xs font-medium rounded-md bg-red-100 text-red-800 hover:bg-red-200 focus:outline-none focus:ring-2 focus:ring-red-500"
                      onClick={handleDelete}
                      aria-label="Confirmer la suppression"
                    >
                      Oui
                    </button>
                    <button
                      type="button"
                      className="px-3 py-1.5 text-xs font-medium rounded-md bg-gray-100 text-gray-800 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-500"
                      onClick={() => setConfirmDelete(false)}
                      aria-label="Annuler la suppression"
                    >
                      Non
                    </button>
                  </div>
                ) : (
                  <button
                    type="button"
                    className="px-3 py-1.5 text-xs font-medium rounded-md bg-red-50 text-red-700 hover:bg-red-100 focus:outline-none focus:ring-2 focus:ring-red-500"
                    onClick={() => setConfirmDelete(true)}
                    aria-label="Supprimer la tâche"
                  >
                    <svg
                      className="h-4 w-4"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        strokeLinecap="round"
                        strokeLinejoin="round"
                        strokeWidth={2}
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      />
                    </svg>
                  </button>
                )}
              </div>

              <div className="flex space-x-2">
                <button
                  type="button"
                  className="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                  onClick={onClose}
                >
                  Fermer
                </button>
                <button
                  type="button"
                  className="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
                  onClick={() => setIsEditing(true)}
                >
                  Modifier
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default TaskModal

