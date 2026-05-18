📱 Wasla Mobile App — Smart Community Platform

🔗 Project Demo & Resources:
[Google Drive Folder](https://drive.google.com/drive/folders/1ZkU4SY8poGlgf8811RzBZmJfW2tURuBl?utm_source=chatgpt.com)

🚀 Mobile Application for the Wasla Smart Community Management System

Wasla Mobile is the Flutter-based mobile application designed to provide residents, drivers, doctors, and service providers with a smooth and modern mobile experience for managing daily compound services and smart community interactions.


---

🧠 Overview

Wasla Mobile connects users with multiple smart services inside one unified platform.

Users can:

Request and manage services

Track rides and orders

Communicate in real-time

Receive instant notifications

Access dashboards based on their role

Manage bookings, profiles, and activities easily


The application focuses on scalability, clean architecture, performance, and responsive UI/UX across Android and iOS devices.


---

🛠️ Tech Stack

💙 Flutter

⚡ Dart

🧩 Cubit / BLoC State Management

🔥 Firebase Services

🌐 REST APIs

🔔 Firebase Cloud Messaging (FCM)

💬 SignalR (Real-Time Communication)

🗺️ Google Maps Integration

🗄️ Hive Local Database

🌍 Localization Support

🚀 Responsive Mobile UI



---

📁 Project Structure

lib/
├── core/              # Core utilities, services, themes & constants
├── features/          # App features/modules
├── cubits/            # State management
├── models/            # Data models
├── services/          # API & local services
├── widgets/           # Reusable widgets
├── localization/      # Multi-language support
├── routes/            # App routing
└── main.dart          # App entry point


---

⚙️ Features

🔐 Authentication System

Login / Register

JWT Authentication

Role-based access control

Secure API integration



---

🚖 Smart Services

Ride booking system

Driver tracking

Service request management

Order status tracking



---

💬 Real-Time Features

Real-time chat system

Live updates using SignalR

Instant synchronization across users



---

🔔 Notifications

Push notifications using Firebase Cloud Messaging

Real-time alerts and reminders



---

🗺️ Maps & Location

Google Maps integration

Live location tracking

Pickup & destination management



---

🌍 Localization

Multi-language support

Dynamic localization using GetX



---

📱 Responsive UI

Optimized for different mobile screen sizes

Smooth animations and transitions

Modern Flutter UI design



---

🚀 Getting Started

📥 Clone the Repository

git clone https://github.com/your-repo/wasla-mobile.git

cd wasla-mobile


---

📦 Install Dependencies

flutter pub get


---

⚙️ Environment Setup

Create a .env file in the root directory:

API_BASE_URL=your_backend_api_url
GOOGLE_MAPS_API_KEY=your_google_maps_api_key


---

▶️ Run the Project

flutter run


---

🏗️ Build APK

flutter build apk


---

🧩 Architecture

The application follows a scalable and clean architecture approach:

Feature-based structure

Separation of concerns

Repository pattern

Cubit/BLoC state management

Reusable UI components

API abstraction layer

Local caching using Hive



---

👨‍💻 Team

Developed as part of the Wasla Graduation Project.

Mobile Team

Flutter Development


Backend Team

.NET Development


Frontend Team

React Development



---

📌 Notes

Ensure backend APIs are running before starting the application

Configure Firebase correctly

Add Google Maps API key before running location features

Use production environment variables for release builds



---

⭐ Final Thoughts

Wasla Mobile is a scalable and modern Flutter application built to simplify smart community management through a seamless mobile experience.

The project combines real-time systems, clean architecture, responsive UI, and powerful integrations to deliver a complete smart services platform for modern residential communities.