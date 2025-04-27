// AI创意大脑 - 创意模型

const mongoose = require('mongoose');

const creativeSchema = new mongoose.Schema({
  title: { type: String, required: true },
  overview: { type: String, required: true },
  quadrant: { type: String, enum: ['已知已知', '已知未知', '未知已知', '未知未知'], default: '已知未知' },
  created_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Creative', creativeSchema);