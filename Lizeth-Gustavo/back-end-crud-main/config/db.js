// config/db.js
const mongoose = require('mongoose');

const conectarDB = async () => {
  try {
    await mongoose.connect('mongodb://localhost:27017/crud', {
      //useNewUrlParser: true,
      //useUnifiedTopology: true
    });
    console.log('Conexión exitosa a MongoDB');
  } catch (error) {
    console.error('Error al conectar a MongoDB:', error);
    process.exit(1); // Detener el proceso si no se puede conectar
  }
};

module.exports = conectarDB;
