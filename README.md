# SideQuest 🗺️

> Društvena aplikacija za otkrivanje sadržaja i povezivanje korisnika prema zajedničkim hobijima.

---

## Opis projekta

SideQuest je mobilna aplikacija izrađena u Flutteru s Firebase backendom, osmišljena kako bi povezala ljude koji dijele iste hobije/interese. Korisnici mogu izraditi osobne profile, objavljivati postove označene svojim interesima/hobijma, otkrivati i pregledavati tuđi sadržaj putem pretrage te upravljati vlastitim hobijima.

Aplikacija koristi slojevitu arhitekturu temeljenu na service/repository uzorku i pridržava se Flutterovih konvencija imenovanja i strukturiranja koda. Njezina glavna svrha je spojiti istomišljenike kako bi mogli razmjenjivati iskustva, vještine i materijale — ili jednostavno zajedno otkrivati nove strasti.

---

## Tehnički stack

| Sloj | Tehnologija |
|---|---|
| Frontend | Flutter (Dart) |
| Autentikacija | Firebase Authentication |
| Baza podataka | Cloud Firestore |
| Upravljanje stanjem | Flutter `setState` |
| Verzioniranje | Git / GitHub |

---

## Struktura projekta

```
lib/
├── screens/                          # UI sloj — ekrani aplikacije
│   ├── login_screen.dart             # Ekran za prijavu
│   ├── signup_screen.dart            # Ekran za registraciju
│   ├── reset_password_screen.dart    # Ekran za resetiranje zaporke 
│   ├── profile_screen.dart           # Profil korisnika, postovi, interesi
│   ├── home_screen.dart              # Početni zaslon nakon logina
│   └── search_screen.dart            # Pretraga i istraživanje postova
├── services/                         # Servisni sloj — poslovna logika i komunikacija s Firebaseom
│   ├── firebase_options.dart         # Automatski generirana datoteka prilikom spajanja sa bazom
│   ├── auth_service.dart             # Registracija, prijava, odjava
│   ├── db_read_service.dart          # Čitanje i pisanje podataka iz Firestorea
│   └── color_service.dart            # Centralizirane konstante boja (AppColors)
├── widget/                           # Dijeljene UI komponente
│   └── bottom.dart                   # Zajednička bottom navigation bar
└── main.dart                         # Pokretanje aplikacije
```

### Opis arhitekture

Projekt prati jasno odvajanje odgovornosti:
- **Screens** — isključivo UI logika i upravljanje stanjem ekrana
- **Services** — sva komunikacija s Firebaseom i poslovna logika
- **Widgets** — višekratno upotrebljive komponente

---

## Pokretanje projekta

### Preduvjeti

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.0.0)
- Dart SDK (uključen u Flutter)
- Android Studio / VS Code s Flutter pluginom
- Firebase projekt

### Instalacija - repository

1. Klonirajte repozitorij:
   ```bash
   git clone https://github.com/ManiTheG/SideQuest.git
   cd SideQuest
   ```

2. Instalirajte ovisnosti:
   ```bash
   flutter pub get
   ```

3. Pokrenite aplikaciju:
   ```bash
   flutter run
   ```

### Instalacija - firebase

1. Preuzeti aplikaciju preko poveznice:
    ```bash
    https://appdistribution.firebase.google.com/testerapps/1:778646113271:android:50b62f39bf0462a3eefcf2/releases/5ii3uqf3agll8?utm_source=firebase-console
    ```

---

## Firestore struktura

```
users/
  {uid}/
    username:  string
    bio:       string
    email:     string
    interests: array[string]
    created:   timestamp
    posts/
      {potId}
        title:       string
        description: string
        authorId:    string
        interests:   array[string]
        created:     timestamp
        postId:      string

posts/
  {postId}/
    title:       string
    description: string
    authorId:    string
    interests:   array[string]
    created:     timestamp

interests/
  {interestId}/
    name: array[string]
```

---

## Glavne funkcionalnosti

- 🔐 **Autentikacija** — registracija i prijava putem Firebase Auth
- 👤 **Profil** — prikaz korisničkih podataka, interesa/hobija i objavljenih postova
- ✏️ **Uređivanje interesa/hobija** — odabir i uklanjanje interesa/hobija s privremenim stanjem
- 📝 **Kreiranje postova** — naslov, opis i oznake interesa/hobija
- 🔍 **Pretraga** — pretraživanje postova po interesima s live prijedlozima i highlighted matchevima
- ♾️ **Infinite scroll** — postepeno učitavanje postova pri scrollanju
- 🔄 **Pull to refresh** — osvježavanje feeda povlačenjem

---
## Sigurnost

- Firestore Security Rules ograničavaju pristup podacima samo autentificiranim korisnicima
- Osjetljivi podaci nisu hardkodirani u kodu

---

## Moguća poboljšanja (roadmap)

- [ ] Brisanje postova
- [ ] Notifikacije
- [ ] Preporuke postova prema interesima
- [ ] Geo tag na postovima i interakcije sa  postovima
- [ ] Uređivanje profila
- [ ] Promjena strukture baze
- [ ] CI/CD pipeline (GitHub Actions)
- [ ] Deploy (Firebase Hosting / App Distribution)
