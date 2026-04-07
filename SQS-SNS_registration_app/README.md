# 🚀 SQS + SNS User Registration System

## 📌 Overview

This project demonstrates a **real-world event-driven architecture** using AWS services.

When a user registers through a simple frontend form:
- The backend sends the data to **Amazon SNS**
- SNS broadcasts the message to:
  - 📩 Email (admin notification)
  - 📦 Amazon SQS (for async processing)
- SQS triggers **AWS Lambda** for background processing

---

## 🏗️ Architecture

```

Frontend (HTML/CSS/JS)
↓
Node.js Backend (Express API)
↓
Amazon SNS Topic
↙       ↘
Email        SQS Queue
↓
AWS Lambda

```

---

## 🛠️ Tech Stack

- Frontend: HTML, CSS, JavaScript
- Backend: Node.js (Express)
- AWS Services:
  - Amazon SNS
  - Amazon SQS
  - AWS Lambda
  - IAM (for permissions)

---

## 📂 Project Structure

```

project/
│── index.html        # Frontend registration form
│── server.js         # Backend API (Node.js)
│── package.json      # Dependencies

````

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository

```bash
git clone <your-repo-url>
cd project
````

---

### 2️⃣ Install Dependencies

```bash
npm install
```

---

### 3️⃣ Configure AWS Credentials

```bash
aws configure
```

Enter:

* Access Key
* Secret Key
* Region (e.g., us-east-1)

---

### 4️⃣ Create SNS Topic

* Name: `user-registration-topic`
* Copy the **Topic ARN**

---

### 5️⃣ Create SQS Queue

* Name: `user-registration-queue`

---

### 6️⃣ Subscribe SQS to SNS

* Go to SNS → Topic → Create Subscription
* Protocol: `SQS`
* Select your queue

---

### 7️⃣ Add Email Subscription

* Protocol: `Email`
* Enter your email
* Confirm via email link

---

### 8️⃣ Update Backend Code

Replace Topic ARN in `server.js`:

```js
TopicArn: "YOUR_SNS_TOPIC_ARN"
```

---

### 9️⃣ Run the Server

```bash
node server.js
```

---

### 🔟 Open Frontend

Open `index.html` in browser

---

## 🧪 How It Works

1. User fills registration form
2. Frontend sends request to backend
3. Backend publishes message to SNS
4. SNS:

   * Sends email notification 📩
   * Pushes message to SQS
5. SQS triggers Lambda
6. Lambda processes message (logs)

---

## 📸 Example Message

```
New User Registered!

Name: Aaditya
Email: example@gmail.com
```

---

## ⚠️ Common Issues & Fixes

### ❌ CORS Error

Fix:

```js
app.use(cors());
```

---

### ❌ Region Mismatch

Ensure:

* SNS region == Backend region

---

### ❌ Lambda Not Triggering

Fix:

* Add SQS permissions to Lambda role:

  * `sqs:ReceiveMessage`
  * `sqs:DeleteMessage`
  * `sqs:GetQueueAttributes`

---

### ❌ Email Not Receiving

* Confirm subscription
* Do not recreate SNS topic

---

## 💡 Key Concepts Learned

* Event-driven architecture
* Pub/Sub model (SNS)
* Message queuing (SQS)
* Asynchronous processing
* Decoupled system design

---

## 👨‍💻 Author

Aadityasinh Zala

---

## ⭐ If you like this project

Give it a star ⭐ and feel free to contribute!

