const express = require('express');
const router = express.Router();
const taskController = require('../controllers/taskController');

router.get('/', taskController.getTasks); // get all tasks
router.get('/:id', taskController.getTasksById); // get task by id
router.post('/', taskController.createTask); // create a new task
router.put('/:id', taskController.updateTask); // update a task
router.delete('/:id', taskController.deleteTask); // delete a task

module.exports = router;