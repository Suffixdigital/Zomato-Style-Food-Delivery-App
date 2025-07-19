<p align="center">
  <img src="assets/icons/app_icons.png" width="120" alt="App Icon" />
</p>

<h1 align="center">Zomato Style Food Delivery App 🍔 (Flutter + Supabase)</h1>


![GitHub stars](https://img.shields.io/github/stars/Suffixdigital/Smart-Food-Delivery?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/Suffixdigital/Smart-Food-Delivery?style=flat-square)
![GitHub issues](https://img.shields.io/github/issues/Suffixdigital/Smart-Food-Delivery?style=flat-square)
![GitHub license](https://img.shields.io/github/license/Suffixdigital/Smart-Food-Delivery?style=flat-square)
![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter&style=flat-square)


A full-featured Flutter app inspired by Zomato, designed for food ordering and delivery. Built using **Flutter**, **Supabase**, **Riverpod**, and **Retrofit**, the app now supports complete authentication, profile management, and dynamic content loading.

---

## ✨ What's New

- ✅ **Supabase Email Link Authentication (Magic Link)**
- ✅ **Supabase Social Auth (Google, Facebook, Twitter)**
- ✅ **Forgot & Reset Password** with email or social user verification
- ✅ **Load Categories** from Supabase table (with icon + label)
- ✅ **View & Update User Profile** from Supabase `users` table

---

## Features

- Onboarding & Walkthrough
- Login via email + password or magic link
- Login with Google, Facebook, or Twitter (OAuth)
- Forgot password and reset password flows with verification
- Display food categories dynamically from Supabase
- Update user profile: name, phone number, date of birth
- Home & Exploration
- Product Listing & Details
- Cart Management
- Checkout (UI Only)
- Chat & Support (Design Only)
- Offer Banner Section for Discounts and Deals
- Settings & Preferences
- Cross-Platform Compatibility (Android & iOS)
- Clean architecture with Riverpod & Retrofit

---

## 📸 Screenshots

| Home                                 | Product Details                            | Cart                                 | Profile                                    |
|--------------------------------------|--------------------------------------------|--------------------------------------|--------------------------------------------|
| ![Home](assets/screenshots/home.png) | ![Details](assets/screenshots/details.png) | ![Cart](assets/screenshots/cart.png) | ![Profile](assets/screenshots/profile.png) |

---

## 🔥 App Preview

> Live mobile preview (UI mockup)

![App Preview](assets/screenshots/app_preview_banner.png)

---

## 🧠 Architecture

- **Flutter** – UI Framework
- **Supabase** – Auth, Database, Storage
- **Retrofit & Dio** – Networking
- **Freezed + JsonSerializable** – Models
- **State Management**: [Riverpod](https://riverpod.dev/)
- **Pattern**: MVVM (Model-View-ViewModel)
- **GoRouter** – Navigation
- **Responsiveness**: `flutter_screenutil`

---

## 🗂️ Folder Structure

```

lib/
├── core/             # Constants, helpers, themes
├── features/
│   ├── auth/         # Login, signup, reset password
│   ├── home/         # Home screen with categories
│   └── profile/      # View and update user profile
├── model/            # Data models
├── services/         # API, Supabase, deep link services
└── main.dart         # Entry point

```

---

## 📦 Dependencies

```yaml
flutter_riverpod: ^2.6.1
persistent_bottom_nav_bar_v2: ^6.0.1
flutter_screenutil: ^5.8.4
```

> You can install them with:
> `flutter pub get`

---

## 🔧 Project Setup

### 1. Clone the Repo

```bash
git clone https://github.com/Suffixdigital/Zomato-Style-Food-Delivery-App.git
cd Zomato-Style-Food-Delivery-App
flutter pub get
```

### 2. Supabase Configuration

- Create a [Supabase](https://supabase.com) project.
- Enable the following **Auth Providers**:
  - Email (Magic Link)
  - Google, Facebook, Twitter
- Create the following **tables** in Supabase:

#### 🧾 Table: `users`

| Column        | Type      | Description                 |
|---------------|-----------|-----------------------------|
| id            | UUID      | Supabase Auth User ID (PK)  |
| full_name     | Text      | Full name                   |
| date_of_birth | Date      | Date of birth               |
| phone         | Text      | Phone number                |
| updated_at    | Timestamp | Last updated time           |

#### 🍕 Table: `category`

| Column    | Type | Description                      |
|-----------|------|----------------------------------|
| id        | UUID | Primary key                      |
| name      | Text | Category name (e.g., Pizza)      |
| icon_url  | Text | Supabase storage public image URL|

- Add your Supabase credentials in `lib/core/constants/app_keys.dart`:

```dart
const String supabaseUrl = 'https://your-project.supabase.co';
const String supabaseAnonKey = 'your-anon-key';
```

---

## 📁 Assets & Configuration

Make sure your `pubspec.yaml` includes:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

To customize launcher icon/splash:

```bash
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
```

---

## 🔑 Authentication Flow

- `/login` – Email/password, magic link, social login
- `/callback` – Handles Supabase deep links
- `/forgot-password` → `/reset-password`
- Detects email vs social user and shows proper error

---

## 📱 Home Screen

- Loads categories from Supabase `category` table
- Displays icon + name
- Fully dynamic with graceful fallback if no icon found

---

## 👤 Profile Screen

- Fetches user data from `users` table
- Editable fields: full name, phone, date of birth
- Saved to Supabase with validation

---

## 🛠 Run the App

```bash
flutter run
```

---

## ⏳ Upcoming Features

- Cart & Order Placement
- Restaurant & Food Detail Screens
- Payment Integration
- Order History

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to open an issue or submit a PR.

---

## 🙌 Maintainer

Developed by **[Suffix Digital](https://github.com/Suffixdigital)**  
📫 Feel free to connect for collaboration or feedback.
