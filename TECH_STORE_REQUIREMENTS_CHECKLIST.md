# Tech Store - Requirements Checklist

Ky dokument tregon se cilat kërkesa janë realizuar në projekt.

## 1. User Authentication

- Login me email ose username.
- Signup me username, email dhe password.
- Email verification me kod demo: `123456`.
- Forgot/Reset password me email dhe password të ri.

## 2. Core Feature Set

Projekti ka më shumë se 3 module funksionale:

1. Product Catalog - shfaq produktet nga REST API.
2. Cart & Checkout - shtim/heqje produktesh dhe krijim porosie.
3. Orders - histori e porosive.
4. Booking System - rezervim për servis teknik.
5. Warranty/Service Tasks - menaxhim detyrash.
6. Analytics Dashboard - statistika dhe grafik i thjeshtë.
7. Notifications - qendër njoftimesh brenda aplikacionit.

## 3. API Integration

- Përdoret REST API: `https://fakestoreapi.com/products`.
- Nëse API nuk hapet, aplikacioni përdor fallback products që të mos bllokohet demo.

## 4. Responsive UI/UX

- Dizajn mobile-friendly.
- Bottom navigation në ekran të vogël.
- NavigationRail në ekran të gjerë/tablet/web.
- Layout i pastër dhe konsistent me ngjyrë dominuese të gjelbër.

## 5. Notifications

- In-app local notification center.
- SnackBar alerts për add to cart, booking, order dhe task.

## Technical Requirements

- Platform: Flutter cross-platform.
- Tools: Visual Studio Code / Android Studio.
- Version Control: projekti ka `.gitignore` dhe është gati për Git/GitHub.
- Architecture: MVVM, me ndarje `models`, `viewmodels`, `views`, `services`.
- Testing: `test/auth_view_model_test.dart` teston signup, verification dhe login error.
