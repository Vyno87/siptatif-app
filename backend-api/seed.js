const fs = require('fs');
const https = require('https');

const baseUrl = 'siptatif-app-iota.vercel.app';
const dbFile = '../db.json';

const postData = (path, data) => {
  return new Promise((resolve, reject) => {
    const payload = JSON.stringify(data);
    const options = {
      hostname: baseUrl,
      path: `/${path}`,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': Buffer.byteLength(payload)
      }
    };

    const req = https.request(options, res => {
      let responseBody = '';
      res.on('data', chunk => responseBody += chunk);
      res.on('end', () => resolve(responseBody));
    });

    req.on('error', e => reject(e));
    req.write(payload);
    req.end();
  });
};

const seed = async () => {
  try {
    const db = JSON.parse(fs.readFileSync(dbFile, 'utf8'));
    const collections = ['users', 'mahasiswa', 'pembimbing', 'penguji', 'notifikasi', 'logbooks', 'sidang', 'yudisium'];

    console.log('🚀 Memulai migrasi data ke Vercel/MongoDB Atlas...');
    for (const collection of collections) {
      if (!db[collection]) continue;
      console.log(`\n📦 Memindahkan koleksi: ${collection} (${db[collection].length} item)`);
      for (const item of db[collection]) {
        try {
          await postData(collection, item);
          process.stdout.write('.');
        } catch (err) {
          console.error(`\nGagal mentransfer item di ${collection}:`, err.message);
        }
      }
    }
    console.log('\n\n✅ MIGRASI DATA SELESAI!');
  } catch (e) {
    console.error('Error membaca file db.json:', e);
  }
};

seed();
