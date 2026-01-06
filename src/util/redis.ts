import { createClient } from "redis";

const redis = createClient({
  url: "redis://localhost:6379",
});

redis.on("connect", () => {
  console.log("REDIS Connected.");
});

redis.on("error", (err) => {
  console.error("Error connecting REDIS: ", err);
});

export const initRedis = async () =>{
    if(!redis.isOpen){
        await redis.connect();
    }
};

export default redis;