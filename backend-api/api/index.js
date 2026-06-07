const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/siptatif')
  .then(() => console.log('Connected to MongoDB Atlas'))
  .catch(err => console.error('MongoDB connection error:', err));

// Global schema transform: automatically replace _id with id for Flutter compatibility
mongoose.plugin((schema) => {
  schema.set('toJSON', {
    virtuals: true,
    transform: (doc, ret) => {
      ret.id = ret._id.toString();
      delete ret._id;
      delete ret.__v;
    }
  });
});

// Dynamic Models (Strict: false allows any JSON structure similar to json-server)
const User = mongoose.model('User', new mongoose.Schema({}, { strict: false }));
const Mahasiswa = mongoose.model('Mahasiswa', new mongoose.Schema({}, { strict: false }));
const Pembimbing = mongoose.model('Pembimbing', new mongoose.Schema({}, { strict: false }));
const Penguji = mongoose.model('Penguji', new mongoose.Schema({}, { strict: false }));
const Notifikasi = mongoose.model('Notifikasi', new mongoose.Schema({}, { strict: false }));
const Logbook = mongoose.model('Logbook', new mongoose.Schema({}, { strict: false }));
const Sidang = mongoose.model('Sidang', new mongoose.Schema({}, { strict: false }));
const Yudisium = mongoose.model('Yudisium', new mongoose.Schema({}, { strict: false }));

// Helper to auto-generate standard REST API Routes (CRUD)
const createCrudRoutes = (model, path) => {
  // GET all or by query
  app.get(`/${path}`, async (req, res) => {
    try {
      const data = await model.find(req.query);
      res.json(data);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  // GET by ID
  app.get(`/${path}/:id`, async (req, res) => {
    try {
      const data = await model.findById(req.params.id);
      if (data) res.json(data);
      else res.status(404).json({ error: 'Not found' });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  // POST create new
  app.post(`/${path}`, async (req, res) => {
    try {
      // In json-server, the client sometimes forces an integer 'id', we remove it so MongoDB generates _id
      const body = { ...req.body };
      delete body.id; 

      const newItem = new model(body);
      const saved = await newItem.save();
      res.status(201).json(saved);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  // PUT update existing
  app.put(`/${path}/:id`, async (req, res) => {
    try {
      const body = { ...req.body };
      delete body.id; // Prevent updating _id

      const updated = await model.findByIdAndUpdate(req.params.id, body, { new: true });
      if (updated) res.json(updated);
      else res.status(404).json({ error: 'Not found' });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });

  // DELETE
  app.delete(`/${path}/:id`, async (req, res) => {
    try {
      await model.findByIdAndDelete(req.params.id);
      res.json({ message: 'Deleted' });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });
};

// Generate all routes
createCrudRoutes(User, 'users');
createCrudRoutes(Mahasiswa, 'mahasiswa');
createCrudRoutes(Pembimbing, 'pembimbing');
createCrudRoutes(Penguji, 'penguji');
createCrudRoutes(Notifikasi, 'notifikasi');
createCrudRoutes(Logbook, 'logbooks');
createCrudRoutes(Sidang, 'sidang');
createCrudRoutes(Yudisium, 'yudisium');

app.get('/', (req, res) => {
  res.send('SIPTATIF Backend API is Running on Vercel!');
});

// For local testing
if (process.env.NODE_ENV !== 'production') {
  const PORT = process.env.PORT || 3001;
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
}

module.exports = app;
