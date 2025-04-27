// 初始化MongoDB脚本

db = db.getSiblingDB('aicreative');

// 创建集合
db.createCollection('creatives');
db.createCollection('scripts');
db.createCollection('users');

// 创建索引
db.creatives.createIndex({ "title": "text", "overview": "text" });
db.scripts.createIndex({ "creative_id": 1 });
db.users.createIndex({ "email": 1 }, { unique: true });

// 插入初始管理员用户
db.users.insertOne({
  email: "admin@example.com",
  password: "$2b$10$zG5KJJMQtdxPBOpZ9Py42OcgmJc8Eo2y3LZ.OzlUfvMgmyVmvTX9m", // admin123加密后的密码
  name: "系统管理员",
  role: "admin",
  created_at: new Date()
});

print('MongoDB初始化完成');
