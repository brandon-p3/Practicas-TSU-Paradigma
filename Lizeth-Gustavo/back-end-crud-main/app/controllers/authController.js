const Record = require('../models/recordModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');


exports.login = async (req, res) => {
    try {
        const { mail, password } = req.body;

        const user = await Record.findOne({ mail });
        if (!user) {
            return res.status(404).json({ status: false, message: 'Usuario no encontrado' });
        }

        const match = await bcrypt.compare(password, user.password);
        if (!match) {
            return res.status(401).json({ status: false, message: 'Contraseña incorrecta' });
        }

        const token = jwt.sign(
            { mail: user.mail, name: user.name },
            process.env.SECRET_KEY,
            { expiresIn: '1h' }
        );

        res.json({ status: true, message: 'Inicio de sesión exitoso', token: token });
    } catch (error) {
        res.status(500).json({ error: 'Error al iniciar sesión', detalle: error });
    }
};
