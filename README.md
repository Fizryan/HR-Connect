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

## � Firebase API Documentation

### Authentication

Aplikasi menggunakan **Firebase Authentication** dengan metode Email/Password.

```dart
// Login
FirebaseAuth.instance.signInWithEmailAndPassword(
  email: email,
  password: password,
);

// Logout
FirebaseAuth.instance.signOut();

// Get current user
FirebaseAuth.instance.currentUser;
```

---

### 📁 Collection: `employees`

Menyimpan data profil semua karyawan.

#### Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `uid` | `string` | ✅ | User ID dari Firebase Auth |
| `email` | `string` | ✅ | Email karyawan |
| `fullname` | `string` | ✅ | Nama lengkap |
| `role` | `string` | ✅ | Role: `admin`, `hrd`, `supervisor`, `finance`, `employee` |
| `isActive` | `boolean` | ✅ | Status aktif karyawan |
| `createdAt` | `timestamp` | ✅ | Tanggal dibuat |
| `updatedAt` | `timestamp` | ✅ | Tanggal diupdate |

#### Sample Document

```json
{
  "uid": "abc123xyz",
  "email": "john.doe@company.com",
  "fullname": "John Doe",
  "role": "employee",
  "isActive": true,
  "createdAt": "2024-01-15T08:00:00Z",
  "updatedAt": "2024-01-15T08:00:00Z"
}
```

#### Security Rules

| Operation | Condition |
|-----------|-----------|
| **Read** | Authenticated users |
| **Create** | Admin/HRD atau user membuat document sendiri |
| **Update** | Admin/HRD (semua), User sendiri (kecuali `role` & `isActive`) |
| **Delete** | Admin/HRD (tidak bisa hapus akun sendiri) |

---

### 📁 Collection: `attendance`

Menyimpan record absensi harian karyawan.

#### Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Unique attendance ID |
| `uid` | `string` | ✅ | User ID karyawan |
| `employeeName` | `string` | ✅ | Nama karyawan |
| `date` | `timestamp` | ✅ | Tanggal absensi |
| `checkIn` | `timestamp` | ❌ | Waktu check-in |
| `checkOut` | `timestamp` | ❌ | Waktu check-out |
| `status` | `string` | ✅ | Status: `present`, `late`, `absent`, `leave` |
| `notes` | `string` | ❌ | Catatan tambahan |

#### Sample Document

```json
{
  "id": "att_20241230_abc123",
  "uid": "abc123xyz",
  "employeeName": "John Doe",
  "date": "2024-12-30T00:00:00Z",
  "checkIn": "2024-12-30T08:15:00Z",
  "checkOut": "2024-12-30T17:30:00Z",
  "status": "present",
  "notes": ""
}
```

#### Security Rules

| Operation | Condition |
|-----------|-----------|
| **Read** | Authenticated users |
| **Create** | Admin/HRD atau user membuat attendance sendiri |
| **Update** | Admin/HRD atau user mengupdate attendance sendiri |
| **Delete** | Admin/HRD only |

#### Firestore Index

```json
{
  "collectionGroup": "attendance",
  "fields": [
    { "fieldPath": "uid", "order": "ASCENDING" },
    { "fieldPath": "date", "order": "ASCENDING" }
  ]
}
```

---

### 📁 Collection: `leaves`

Menyimpan pengajuan cuti karyawan.

#### Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Unique leave ID |
| `uid` | `string` | ✅ | User ID pemohon |
| `employeeName` | `string` | ✅ | Nama karyawan |
| `requesterRole` | `string` | ✅ | Role pemohon |
| `type` | `string` | ✅ | Tipe: `annual`, `sick`, `personal`, `maternity`, `paternity`, `unpaid` |
| `startDate` | `timestamp` | ✅ | Tanggal mulai cuti |
| `endDate` | `timestamp` | ✅ | Tanggal akhir cuti |
| `reason` | `string` | ✅ | Alasan cuti |
| `status` | `string` | ✅ | Status: `pending`, `approved`, `rejected`, `cancelled` |
| `approvedBy` | `string` | ❌ | Nama approver |
| `approvedAt` | `timestamp` | ❌ | Tanggal diapprove |
| `rejectionReason` | `string` | ❌ | Alasan penolakan |
| `createdAt` | `timestamp` | ✅ | Tanggal dibuat |

#### Sample Document

```json
{
  "id": "leave_abc123",
  "uid": "abc123xyz",
  "employeeName": "John Doe",
  "requesterRole": "employee",
  "type": "annual",
  "startDate": "2024-12-25T00:00:00Z",
  "endDate": "2024-12-27T00:00:00Z",
  "reason": "Family vacation",
  "status": "approved",
  "approvedBy": "Jane Smith (HRD)",
  "approvedAt": "2024-12-20T10:30:00Z",
  "rejectionReason": null,
  "createdAt": "2024-12-18T09:00:00Z"
}
```

#### Leave Approval Hierarchy

| Pemohon | Dapat Diapprove Oleh |
|---------|----------------------|
| Employee | Supervisor, HRD, Admin |
| Supervisor | HRD |
| Finance | HRD |
| Admin | HRD |
| HRD | Admin |

#### Security Rules

| Operation | Condition |
|-----------|-----------|
| **Read** | Authenticated users |
| **Create** | User membuat leave dengan `uid` sendiri dan status `pending` |
| **Update** | Admin/HRD/Supervisor (approve/reject), User sendiri (pending only) |
| **Delete** | Admin/HRD atau user hapus leave pending sendiri |

#### Firestore Indexes

```json
[
  {
    "collectionGroup": "leaves",
    "fields": [
      { "fieldPath": "uid", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" }
    ]
  },
  {
    "collectionGroup": "leaves",
    "fields": [
      { "fieldPath": "requesterRole", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" }
    ]
  }
]
```

---

### 📁 Collection: `reimbursements`

Menyimpan pengajuan reimbursement karyawan.

#### Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | `string` | ✅ | Unique reimbursement ID |
| `uid` | `string` | ✅ | User ID pemohon |
| `employeeName` | `string` | ✅ | Nama karyawan |
| `requesterRole` | `string` | ✅ | Role pemohon |
| `type` | `string` | ✅ | Tipe: `transport`, `meals`, `medical`, `office_supplies`, `training`, `other` |
| `description` | `string` | ✅ | Deskripsi pengeluaran |
| `amount` | `number` | ✅ | Jumlah (dalam Rupiah) |
| `expenseDate` | `timestamp` | ✅ | Tanggal pengeluaran |
| `status` | `string` | ✅ | Status: `pending`, `approved`, `rejected`, `paid` |
| `approvedBy` | `string` | ❌ | Nama approver |
| `approvedAt` | `timestamp` | ❌ | Tanggal diapprove |
| `paidAt` | `timestamp` | ❌ | Tanggal dibayar |
| `rejectionReason` | `string` | ❌ | Alasan penolakan |
| `createdAt` | `timestamp` | ✅ | Tanggal dibuat |

#### Sample Document

```json
{
  "id": "reimb_xyz789",
  "uid": "abc123xyz",
  "employeeName": "John Doe",
  "requesterRole": "employee",
  "type": "transport",
  "description": "Taxi for client meeting",
  "amount": 150000,
  "expenseDate": "2024-12-28T00:00:00Z",
  "status": "approved",
  "approvedBy": "Finance Team",
  "approvedAt": "2024-12-29T14:00:00Z",
  "paidAt": null,
  "rejectionReason": null,
  "createdAt": "2024-12-28T16:30:00Z"
}
```

#### Reimbursement Status Flow

```
pending → approved → paid
    ↘ rejected
```

#### Security Rules

| Operation | Condition |
|-----------|-----------|
| **Read** | Authenticated users |
| **Create** | User membuat dengan `uid` sendiri dan status `pending` |
| **Update** | Admin/Finance (approve/reject/paid), User sendiri (pending only) |
| **Delete** | Admin/Finance atau user hapus reimbursement pending sendiri |

> ⚠️ **Note**: Finance tidak dapat approve reimbursement milik sendiri (validasi di aplikasi)

#### Firestore Indexes

```json
[
  {
    "collectionGroup": "reimbursements",
    "fields": [
      { "fieldPath": "uid", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" }
    ]
  },
  {
    "collectionGroup": "reimbursements",
    "fields": [
      { "fieldPath": "status", "order": "ASCENDING" },
      { "fieldPath": "createdAt", "order": "DESCENDING" }
    ]
  }
]
```

---

### 📁 Collection: `leave_balances`

Menyimpan saldo cuti per karyawan per tahun.

#### Schema

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `userId` | `string` | ✅ | User ID karyawan |
| `year` | `number` | ✅ | Tahun saldo |
| `annual` | `object` | ✅ | `{ total: number, used: number, remaining: number }` |
| `sick` | `object` | ✅ | `{ total: number, used: number, remaining: number }` |
| `personal` | `object` | ✅ | `{ total: number, used: number, remaining: number }` |

#### Sample Document

```json
{
  "userId": "abc123xyz",
  "year": 2024,
  "annual": { "total": 12, "used": 5, "remaining": 7 },
  "sick": { "total": 12, "used": 2, "remaining": 10 },
  "personal": { "total": 6, "used": 1, "remaining": 5 }
}
```

#### Security Rules

| Operation | Condition |
|-----------|-----------|
| **Read** | User sendiri atau Admin/HRD |
| **Write** | Admin/HRD only |

---

### 🔐 Security Rules Summary

```javascript
// Helper Functions
isSignedIn()    // User authenticated
isAdmin()       // User role == 'admin'
isHRD()         // User role == 'hrd'
isFinance()     // User role == 'finance'
isSupervisor()  // User role == 'supervisor'
isAdminOrHRD()  // Admin OR HRD
```

### 📊 Composite Indexes Required

Deploy indexes dengan command:
```bash
firebase deploy --only firestore:indexes
```

File `firestore.indexes.json`:
```json
{
  "indexes": [
    {
      "collectionGroup": "leaves",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "uid", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "leaves",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "requesterRole", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "attendance",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "uid", "order": "ASCENDING" },
        { "fieldPath": "date", "order": "ASCENDING" }
      ]
    },
    {
      "collectionGroup": "reimbursements",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "uid", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    },
    {
      "collectionGroup": "reimbursements",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

## �📱 Supported Platforms

- ✅ Android
- ⚠️ iOS       (currently not supported)
- ⚠️ Web       (currently not supported)
- ⚠️ Windows   (currently not supported)
- ⚠️ macOS     (currently not supported)
- ⚠️ Linux     (currently not supported)

**HR Connect** - Simplifying Human Resource Management