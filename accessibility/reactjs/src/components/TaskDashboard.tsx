"use client"

import { useState } from "react"
import { useTaskContext, type TaskStatus } from "../context/TaskContext"
import TaskList from "./TaskList"
import TaskForm from "./TaskForm"

const TaskDashboard = () => {
  const { tasks, filter, setFilter } = useTaskContext()
  const [isFormOpen, setIsFormOpen] = useState(false)

  // Get unique assignees for filter dropdown
  const assignees = Array.from(new Set(tasks.map((task) => task.assignee))).filter(Boolean)

  // Filter tasks based on current filter
  const filteredTasks = tasks.filter((task) => {
    if (filter.status !== "toutes" && task.status !== filter.status) {
      return false
    }
    if (filter.assignee && task.assignee !== filter.assignee) {
      return false
    }
    return true
  })

  // Group tasks by status
  const tasksByStatus: Record<TaskStatus, typeof tasks> = {
    "à faire": filteredTasks.filter((task) => task.status === "à faire"),
    "en cours": filteredTasks.filter((task) => task.status === "en cours"),
    terminé: filteredTasks.filter((task) => task.status === "terminé"),
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
        <h2 className="text-2xl font-bold text-gray-800">Tableau de bord des tâches</h2>

        <button
          type="button"
          className="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
          onClick={() => setIsFormOpen(true)}
          aria-label="Créer une nouvelle tâche"
        >
          <svg
            className="-ml-1 mr-2 h-5 w-5"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
          </svg>
          Nouvelle tâche
        </button>
      </div>

      <div className="bg-white rounded-lg shadow p-4 sm:p-6">
        <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-6">
          <h3 className="text-lg font-medium text-gray-700">
            {filteredTasks.length} tâche{filteredTasks.length !== 1 ? "s" : ""}
          </h3>

          <div className="flex flex-col sm:flex-row gap-3">
            <div>
              <label htmlFor="status-filter" className="sr-only">
                Filtrer par statut
              </label>
              <select
                id="status-filter"
                className="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md"
                value={filter.status}
                onChange={(e) => setFilter({ status: e.target.value as TaskStatus | "toutes" })}
                aria-label="Filtrer par statut"
              >
                <option value="toutes">Tous les statuts</option>
                <option value="à faire">À faire</option>
                <option value="en cours">En cours</option>
                <option value="terminé">Terminé</option>
              </select>
            </div>

            <div>
              <label htmlFor="assignee-filter" className="sr-only">
                Filtrer par assigné
              </label>
              <select
                id="assignee-filter"
                className="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md"
                value={filter.assignee}
                onChange={(e) => setFilter({ assignee: e.target.value })}
                aria-label="Filtrer par assigné"
              >
                <option value="">Tous les assignés</option>
                {assignees.map((assignee) => (
                  <option key={assignee} value={assignee}>
                    {assignee}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div className="bg-gray-50 rounded-lg p-4">
            <h4 className="font-medium text-gray-700 mb-3 flex items-center">
              <span className="w-3 h-3 rounded-full bg-yellow-400 mr-2" aria-hidden="true"></span>À faire (
              {tasksByStatus["à faire"].length})
            </h4>
            <TaskList tasks={tasksByStatus["à faire"]} />
          </div>

          <div className="bg-gray-50 rounded-lg p-4">
            <h4 className="font-medium text-gray-700 mb-3 flex items-center">
              <span className="w-3 h-3 rounded-full bg-blue-400 mr-2" aria-hidden="true"></span>
              En cours ({tasksByStatus["en cours"].length})
            </h4>
            <TaskList tasks={tasksByStatus["en cours"]} />
          </div>

          <div className="bg-gray-50 rounded-lg p-4">
            <h4 className="font-medium text-gray-700 mb-3 flex items-center">
              <span className="w-3 h-3 rounded-full bg-green-400 mr-2" aria-hidden="true"></span>
              Terminé ({tasksByStatus["terminé"].length})
            </h4>
            <TaskList tasks={tasksByStatus["terminé"]} />
          </div>
        </div>
      </div>

      {isFormOpen && <TaskForm isOpen={isFormOpen} onClose={() => setIsFormOpen(false)} />}
    </div>
  )
}

export default TaskDashboard

