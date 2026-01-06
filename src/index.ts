import dotenv from "dotenv";
import app from "./app";
// import { prisma } from "./util/prisma";

dotenv.config();

const PORT = process.env.PORT || 8980;

const start = async () => {
  try {
    // await prisma.$connect();

    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Database connection failed!:", error);
    process.exit(1);
  }
};

start();
