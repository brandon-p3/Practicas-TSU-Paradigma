const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

//registra
router.post('/login', authController.login);


module.exports = router;