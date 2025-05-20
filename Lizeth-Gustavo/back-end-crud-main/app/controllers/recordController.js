const Record = require('../models/recordModel');
const PDFDocument = require('pdfkit');
const bcrypt = require('bcrypt');


//checar conexion

exports.check_back_end = async (req, res) => {
    try {
        res.status(200).json({
            status: true,
            message: "Conexion al BackEnd de forma exitosa",
        });
    } catch (error) {
        res.status(500).json({ status: true, message: "Error en la conexion con el BackEnd", error: error });
    }
}

//crear
exports.create_record = async (req, res) => {
    try {
        const { name, lastname, mail, phone, pass, age } = req.body;

        //tiene obligatorio
        if (!name || !lastname || !mail || !phone || !pass) {
            return res.status(400).json({ status: false, message: "Todos los campos son obligatorios." });
        }

        //no repite correo
        const existing_email = await Record.findOne({ mail });
        if (existing_email) {
            return res.status(400).json({ status: false, message: "El correo ya está registrado." });
        }

        const saltRounds = 10;
        const password = await bcrypt.hash(pass, saltRounds);


        const new_record = new Record({ name, lastname, mail, phone, password, age });
        await new_record.save();

        res.status(200).json({
            status: true,
            message: "Registro creado exitosamente",
            record: new_record
        });
    } catch (error) {
        res.status(500).json({ status: false, message: "Error al crear el registro", error: error.message });
    }
};

//obtengo los usuarios
exports.get_record = async (req, res) => {
    try {
        const records = await Record.find();
        res.status(200).json({
            status: true,
            message: "Se obtuvieron los registros de forma exitosa",
            records: records
        });
    } catch (error) {
        res.status(500).json({ status: true, message: "Error al obtener los registros", error: error });
    }
};

exports.get_record_by_name = async (req, res) => {
    try {
        const { name } = req.body;
        const records = await Record.find({
            name: { $regex: new RegExp(name, "i") }
        });
        res.status(200).json({
            status: true,
            message: "Se obtuvieron los registros de forma exitosa",
            records: records
        });
    } catch (error) {
        res.status(500).json({ status: true, message: "Error al obtener los registros", error: error });
    }
};


//obtengo por ID
exports.get_record_by_id = async (req, res) => {
    try {
        const record = await Record.findById(req.params.id);
        if (!record) return res.status(404).json({ status: false, message: "Registro no encontrado" });
        res.json(registro);
    } catch (error) {
        res.status(500).json({ message: "Error al obtener el registro", error });
    }
};

//actualizo
exports.update_record = async (req, res) => {
    try {
        const record_updated = await Record.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!record_updated) return res.status(404).json({ status: false, message: "Registro no encontrado" });

        res.json({ status: true, message: "Registro actualizado correctamente", registro: record_updated });
    } catch (error) {
        res.status(500).json({ status: false, message: "Error al actualizar el registro", error: error });
    }
};

//elimino
exports.delete_record = async (req, res) => {
    try {
        const record_deleted = await Record.findByIdAndDelete(req.params.id);
        if (!record_deleted) return res.status(404).json({ status: true, message: "Registro no encontrado" });

        res.json({ status: true, message: "Registro eliminado correctamente", record: record_deleted });
    } catch (error) {
        res.status(500).json({ status: false, message: "Error al eliminar el registro", error: error });
    }
};

//PDF
exports.download_PDF_ecords = async (req, res) => {
    try {
        const registros = await Registro.find();

        const doc = new PDFDocument();

        //encabezado
        res.setHeader('Content-Type', 'application/pdf');
        res.setHeader('Content-Disposition', 'attachment; filename=Registros.pdf');

        //envia PDF
        doc.pipe(res);

        //titulo
        doc.fontSize(18).text('Lista de Registros', { align: 'center' });
        doc.moveDown();

        //contenido
        registros.forEach((registro, i) => {
            doc
                .fontSize(12)
                .text(
                    `${i + 1}. Nombre: ${registro.nombre} ${registro.apellido} | Correo: ${registro.correo} | Teléfono: ${registro.telefono}`
                );
            doc.moveDown(0.5);
        });

        doc.end();
    } catch (error) {
        res.status(500).json({ message: 'Error al generar el PDF', error });
    }
};