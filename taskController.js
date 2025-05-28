const taskModel = require('../models/taskModel');

// function to get all tasks
const getTasks = async (req, res) => {
  try {
    const tasks = await taskModel.getTasks();
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// function to get task by id
const getTasksById = async (req, res) => {
  try {
    const task = await taskModel.getTasksById(req.params.id);
    if (!task) {
      return res.status(404).json({ error: 'Task not found' });
    }
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// function to create a new task
const createTask = async (req, res) => {
  try {
    const newTask = await taskModel.createTask(req.body);
    res.status(201).json(newTask);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// function to update a task
const updateTask = async (req, res) => {
  try {
    const updatedTask = await taskModel.updateTask(req.params.id, req.body);
    if (!updatedTask) {
      return res.status(404).json({ error: 'Task not found' });
    }
    res.json(updatedTask);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// function to delete a task
const deleteTask = async (req, res) => {
  try {
    const task = await taskModel.deleteTask(req.params.id);
    if (!task) {
      return res.status(404).json({ error: 'Task not found' });
    }
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// export functions 
module.exports = {
  getTasks,
  getTasksById,
  createTask,
  updateTask,
  deleteTask,
};