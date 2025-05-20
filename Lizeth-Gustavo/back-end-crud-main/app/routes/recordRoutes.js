const express = require('express');
const router = express.Router();
const recordController = require('../controllers/recordController');

//registra
router.post('/record', recordController.create_record);
//obtengo todos
router.get('/record', recordController.get_record);
//obtener ID
router.get('/record/:id', recordController.get_record_by_id);
//actualizar
router.put('/record/:id', recordController.update_record);
//eliminar
router.delete('/record/:id', recordController.delete_record);
//Buscar por nombre
router.post('/record/search', recordController.get_record_by_name);
//PDF
router.get('/record/dowload/pdf', recordController.download_PDF_ecords);
//checar conexion
router.get('', recordController.check_back_end);


module.exports = router;