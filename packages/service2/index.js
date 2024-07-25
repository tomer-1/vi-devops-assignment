const {MongoClient} = require("mongodb");
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");

const app = express();
const port = process.env.PORT || 3001;
const url = process.env.MONGODB_URL;
const dbName = "DevOpsAssignment";

const client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true }); // Use new URL parser and unified topology for MongoClient

app.use(cors());
app.use(bodyParser.json());

async function connectToDatabase() {
    await client.connect();
    console.log("Connected to MongoDB");

    const db = client.db(dbName);
    return {
        counterCollection: db.collection("counters"),
        orderCollection: db.collection("orders"),
    };
}

async function main() {
    const {counterCollection, orderCollection} = await connectToDatabase();
    // add health check to the application
    app.get('/health-check',(req,res)=> {
        res.send ("Health check passed");
    });
    app.get("/orders", async (req, res) => {
        const orders = await orderCollection.find({}).toArray();
        res.json(orders);
    });

    app.listen(port, () => {
        console.log(`DevOps assignment service2 app listening on port ${port}`);
    });
}

main().catch(err => console.error("Failed to start the server:", err));
