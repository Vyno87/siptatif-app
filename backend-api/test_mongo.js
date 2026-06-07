const mongoose = require('mongoose');
const fs = require('fs');

const uri = "mongodb+srv://vynothea7_db_user:Nyorean9@cluster0.nr0mnpe.mongodb.net/siptatif_db?retryWrites=true&w=majority";
const dbFile = '../db.json';

const User = mongoose.model('User', new mongoose.Schema({}, { strict: false }));
const Mahasiswa = mongoose.model('Mahasiswa', new mongoose.Schema({}, { strict: false }));
const Pembimbing = mongoose.model('Pembimbing', new mongoose.Schema({}, { strict: false }));
const Penguji = mongoose.model('Penguji', new mongoose.Schema({}, { strict: false }));
const Notifikasi = mongoose.model('Notifikasi', new mongoose.Schema({}, { strict: false }));
const Logbook = mongoose.model('Logbook', new mongoose.Schema({}, { strict: false }));
const Sidang = mongoose.model('Sidang', new mongoose.Schema({}, { strict: false }));
const Yudisium = mongoose.model('Yudisium', new mongoose.Schema({}, { strict: false }));

const models = {
  users: User,
  mahasiswa: Mahasiswa,
  pembimbing: Pembimbing,
  penguji: Penguji,
  notifikasi: Notifikasi,
  logbooks: Logbook,
  sidang: Sidang,
  yudisium: Yudisium
};

const seedDirect = async () => {
  try {
    console.log('Menyambungkan ke MongoDB Atlas...');
    await mongoose.connect(uri);
    console.log('Berhasil tersambung!');

    const db = JSON.parse(fs.readFileSync(dbFile, 'utf8'));
    
    for (const [collectionName, model] of Object.entries(models)) {
      if (!db[collectionName] || db[collectionName].length === 0) continue;
      
      console.log(`Membersihkan dan mentransfer ${collectionName}...`);
      await model.deleteMany({}); // Bersihkan data lama jika ada
      
      const items = db[collectionName].map(item => {
        const doc = { ...item };
        delete doc.id; // biarkan mongo yang buatkan _id
        return doc;
      });
      
      await model.insertMany(items);
      console.log(`Berhasil mentransfer ${items.length} item ke ${collectionName}.`);
    }

    console.log('✅ Semua data berhasil dipindahkan ke MongoDB!');
    process.exit(0);
  } catch (e) {
    console.error('❌ Gagal:', e.message);
    process.exit(1);
  }
};

seedDirect();
