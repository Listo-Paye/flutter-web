"use client"

import { createContext, useContext, useState, type ReactNode, useEffect } from "react"

export type TaskStatus = "à faire" | "en cours" | "terminé"

export interface Task {
  id: string
  title: string
  description: string
  status: TaskStatus
  assignee: string
  dueDate: string
  createdAt: string
}

interface TaskContextType {
  tasks: Task[]
  addTask: (task: Omit<Task, "id" | "createdAt">) => void
  updateTask: (id: string, task: Partial<Task>) => void
  deleteTask: (id: string) => void
  selectedTask: Task | null
  setSelectedTask: (task: Task | null) => void
  filter: {
    status: TaskStatus | "toutes"
    assignee: string
  }
  setFilter: (filter: Partial<TaskContextType["filter"]>) => void
}

const TaskContext = createContext<TaskContextType | undefined>(undefined)

export const useTaskContext = () => {
  const context = useContext(TaskContext)
  if (!context) {
    throw new Error("useTaskContext must be used within a TaskProvider")
  }
  return context
}

export const TaskProvider = ({ children }: { children: ReactNode }) => {
  const [tasks, setTasks] = useState<Task[]>(() => {
    const savedTasks = localStorage.getItem("tasks")
    return savedTasks ? JSON.parse(savedTasks) : []
  })

  const [selectedTask, setSelectedTask] = useState<Task | null>(null)

  const [filter, setFilter] = useState<TaskContextType["filter"]>({
    status: "toutes",
    assignee: "",
  })

  // Save tasks to localStorage whenever they change
  useEffect(() => {
    localStorage.setItem("tasks", JSON.stringify(tasks))
  }, [tasks])

  const addTask = (task: Omit<Task, "id" | "createdAt">) => {
    const newTask: Task = {
      ...task,
      id: Date.now().toString(),
      createdAt: new Date().toISOString(),
    }
    setTasks([...tasks, newTask])
  }

  const updateTask = (id: string, updatedFields: Partial<Task>) => {
    setTasks(tasks.map((task) => (task.id === id ? { ...task, ...updatedFields } : task)))
  }

  const deleteTask = (id: string) => {
    setTasks(tasks.filter((task) => task.id !== id))
  }

  return (
    <TaskContext.Provider
      value={{
        tasks,
        addTask,
        updateTask,
        deleteTask,
        selectedTask,
        setSelectedTask,
        filter,
        setFilter,
      }}
    >
      {children}
    </TaskContext.Provider>
  )
}

