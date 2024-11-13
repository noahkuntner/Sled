const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true },
  password: String,
  phoneNumber: String,
  userType: { type: String, enum: ['guide', 'seeker', 'both'] },
});

module.exports = mongoose.model('User', userSchema);
