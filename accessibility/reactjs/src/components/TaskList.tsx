"use client"

import { useTaskContext, type Task } from "../context/TaskContext"

interface TaskListProps {
  tasks: Task[]
}

const TaskList = ({ tasks }: TaskListProps) => {
  const { setSelectedTask } = useTaskContext()

  if (tasks.length === 0) {
    return <div className="text-center py-4 text-gray-500">Aucune tâche</div>
  }

  return (
    <ul className="space-y-3" role="list" aria-label="Liste des tâches">
      {tasks.map((task) => (
        <li key={task.id}>
          <button
            className="w-full text-left bg-white p-3 rounded-md shadow-sm border border-gray-200 hover:border-blue-300 focus:outline-none focus:ring-2 focus:ring-blue-500 transition-colors"
            onClick={() => setSelectedTask(task)}
            aria-label={`Tâche: ${task.title}, Assignée à: ${task.assignee}, Échéance: ${new Date(task.dueDate).toLocaleDateString()}`}
          >
            <h5 className="font-medium text-gray-800 mb-1 truncate">{task.title}</h5>
            <p className="text-sm text-gray-500 mb-2 line-clamp-2">{task.description}</p>

            <div className="flex items-center justify-between text-xs">
              <span className="text-gray-600">{task.assignee}</span>
              <span className="text-gray-600">{new Date(task.dueDate).toLocaleDateString()}</span>
            </div>
          </button>
        </li>
      ))}
    </ul>
  )
}

export default TaskList

