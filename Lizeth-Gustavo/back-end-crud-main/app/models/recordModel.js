const mongoose = require('mongoose');

const RecordSchema = new mongoose.Schema({
    name: { type: String, required: true },
    lastname: { type: String, required: true },
    mail: { type: String, required: true, unique: true },
    phone: { type: String, required: true },
    password: {type: String, require: true},
    age: {type: String, require: true},
    another: { type: String }
});

module.exports = mongoose.model('recordModel', RecordSchema);