import mongoose from 'mongoose';

export const connectDatabase = async (): Promise<void> => {
  const uri = process.env.MONGODB_URI;

  if (!uri) {
    console.warn('[database]: MONGODB_URI is not defined in environment variables.');
    return;
  }

  try {
    mongoose.set('strictQuery', true);
    await mongoose.connect(uri, {
      serverSelectionTimeoutMS: 5000,
      autoIndex: true,
    });
    console.log('[database]: Successfully connected to MongoDB Atlas.');
  } catch (error) {
    console.error('[database]: Error connecting to MongoDB Atlas:', error);
  }
};

mongoose.connection.on('disconnected', () => {
  console.warn('[database]: MongoDB disconnected. Attempting reconnect...');
});

mongoose.connection.on('error', (err) => {
  console.error('[database]: MongoDB connection error:', err);
});

export const closeDatabase = async (): Promise<void> => {
  await mongoose.connection.close();
  console.log('[database]: MongoDB connection closed.');
};
