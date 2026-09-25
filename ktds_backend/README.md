
## Backend and MongoDB Atlas

The REST API in `ktds_backend` uses Prisma with MongoDB Atlas. Copy `ktds_backend/.env.example` to `ktds_backend/.env`, provide the Atlas connection string and a strong JWT secret, then run `npm run db:push`, `npm run build`, and `npm start` from that directory. Atlas must allow the API host IP address; its cluster replica set supports the API's transactional registration and approval flows.
