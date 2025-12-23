# HR Connect

Aplikasi manajemen sumber daya manusia (HRM) berbasis Flutter dengan Firebase sebagai backend. Aplikasi ini dirancang untuk memudahkan pengelolaan karyawan, absensi, cuti, dan reimbursement dalam suatu organisasi.

## ✨ Fitur Utama

### 🔐 Autentikasi
- Login dengan email dan password
- Manajemen sesi pengguna
- Role-based access control

### 👥 Manajemen Pengguna
- CRUD data karyawan (Admin/HRD)
- Profil karyawan dengan informasi lengkap
- Status aktif/non-aktif karyawan

### ⏰ Absensi (Attendance)
- Check-in dan Check-out harian
- Riwayat absensi
- Statistik kehadiran (hadir, terlambat, absen, cuti)
- Quick Actions di semua dashboard

### 🏖️ Manajemen Cuti (Leave)
- Pengajuan cuti (Annual, Sick, Personal)
- Persetujuan cuti oleh Supervisor/HRD
- Saldo cuti per kategori
- Riwayat pengajuan cuti

### 💰 Reimbursement
- Pengajuan reimbursement dengan berbagai kategori
- Alur persetujuan bertingkat
- Status tracking (Pending → Approved → Paid)
- Riwayat dan laporan reimbursement

### 📊 Dashboard & Reports
- Dashboard khusus per role (Admin, HRD, Supervisor, Finance, Employee)
- Statistik real-time dari Firebase
- Laporan PDF untuk attendance dan reimbursement
- Budget tracking untuk Finance

### ⚙️ Pengaturan
- Edit profil pengguna
- Ganti password
- Dark/Light mode

## 👤 Role Pengguna

| Role | Akses |
|------|-------|
| **Admin** | Full access, User management, Dashboard overview |
| **HRD** | Employee management, Leave approval, Reports, Attendance |
| **Supervisor** | Team overview, Leave approval, Attendance monitoring |
| **Finance** | Budget overview, Reimbursement management, Financial reports |
| **Employee** | Personal attendance, Leave request, Reimbursement request |

## 🛠️ Tech Stack

- **Framework**: Flutter 3.9+
- **State Management**: Provider
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
- **PDF Generation**: pdf, printing
- **UI**: Material Design 3, flutter_screenutil

## 📦 Dependencies

```yaml
dependencies:
  firebase_core: ^4.3.0
  firebase_auth: ^6.1.3
  cloud_firestore: ^6.1.1
  flutter_screenutil: ^5.9.3
  provider: ^6.1.5+1
  intl: ^0.20.2
  shared_preferences: ^2.5.4
  uuid: ^4.5.2
  dropdown_button2: ^2.3.9
  pdf: ^3.11.1
  printing: ^5.13.3
  path_provider: ^2.1.5
  open_file: ^3.5.9
  url_launcher: ^6.2.0
  connectivity_plus: ^6.0.3
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.2 atau lebih baru
- Dart SDK ^3.9.2
- Firebase project yang sudah dikonfigurasi
- Android Studio / VS Code

### Installation

1. **Clone repository**
   ```bash
   git clone https://github.com/Fizryan/HRD_Mobile.git
   cd HRD_Mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup Firebase**
   - Buat project di [Firebase Console](https://console.firebase.google.com)
   - Aktifkan Authentication (Email/Password)
   - Aktifkan Cloud Firestore
   - Download `google-services.json` dan letakkan di `android/app/`
   - Jalankan `flutterfire configure` untuk generate `firebase_options.dart`

4. **Deploy Firestore Rules**
   ```bash
   firebase deploy --only firestore:rules
   ```

5. **Deploy Firestore Indexes**
   ```bash
   firebase deploy --only firestore:indexes
   ```

6. **Run aplikasi**
   ```bash
   flutter run
   ```

## 📁 Struktur Project

```
lib/
├── main.dart                 # Entry point
├── core/                     # Core utilities
│   ├── config/              # App configuration
│   ├── controllers/         # Base controller
│   ├── services/            # Cache & connectivity
│   ├── theme/               # App colors & theme
│   ├── utils/               # Responsive utilities
│   └── widgets/             # Common widgets
├── features/                 # Feature modules
│   ├── attendance/          # Attendance feature
│   ├── auth/                # Authentication
│   ├── dashboard/           # Dashboard panels
│   ├── leave/               # Leave management
│   ├── navigation/          # Menu navigation
│   ├── reimbursement/       # Reimbursement
│   ├── reports/             # Reports & PDF
│   ├── settings/            # User settings
│   └── user_management/     # User CRUD
└── firebase/                 # Firebase config
```

## 🔥 Firestore Collections

| Collection | Deskripsi |
|------------|-----------|
| `employees` | Data karyawan dan profil |
| `attendance` | Record absensi harian |
| `leaves` | Pengajuan dan status cuti |
| `reimbursements` | Pengajuan reimbursement |
| `leave_balances` | Saldo cuti per karyawan |

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

**HR Connect** - Simplifying Human Resource Management