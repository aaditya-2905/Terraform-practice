const express = require("express");
const AWS = require("aws-sdk");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
app.use(cors());

app.use(bodyParser.json());

AWS.config.update({ region: "us-east-1" });

const sns = new AWS.SNS();

app.post("/register", async (req, res) => {
    try {
        const { name, email } = req.body;

        const message = `
New User Registered!

Name: ${name}
Email: ${email}
`;

        await sns.publish({
            TopicArn: "arn:aws:sns:us-east-1:397450412553:user-registration-topic",
            Message: message
        }).promise();

        res.json({ message: "User sent to SNS" });

    } catch (err) {
        console.error("ERROR:", err);
        res.status(500).json({ error: "SNS failed" });
    }
});

app.listen(3000, () => console.log("Server running on port 3000"));