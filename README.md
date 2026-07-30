# TT Sport & Store — Flutter Mobil Uygulama

Bu klasör, planın Flutter tarafının **kaynak kodudur** (`lib/` klasörü ve `pubspec.yaml`).
Burada sadece uygulama kodu var — Android/iOS proje dosyaları (android/, ios/ klasörleri)
henüz yok, çünkü bunlar `flutter create` komutuyla senin bilgisayarında/GitHub Actions'ta
otomatik üretilecek.

---

## Neden burada bir APK yok?

APK üretmek için Flutter SDK + Android SDK + Gradle gerekiyor. Bunları bu ortamda
(internet erişimi kapalı) kuramıyorum. Ama sana **hiç kurulum yapmadan, tarayıcıdan**
APK almanın yolunu adım adım anlatıyorum aşağıda (Codemagic ile).

---

## ADIM 1 — Bu klasörü GitHub'a yükle

1. GitHub.com'da (zaten hesap açtın ✅) sağ üstten **"New repository"** tıkla.
2. İsim ver: örn. `tt-sport-app`. **Public** veya **Private** olabilir. "Create repository" tıkla.
3. Açılan sayfada **"uploading an existing file"** linkine tıkla.
4. Bu klasördeki **tüm dosyaları** (pubspec.yaml, lib/ klasörü, README.md, .env.example)
   sürükle-bırak ile yükle.
5. Altta "Commit changes" butonuna tıkla.

> Not: GitHub web arayüzünden klasör yükleme bazen tek tek dosya ister. Eğer zorlanırsan
> bana söyle, GitHub Desktop uygulamasıyla (tıkla-sürükle, kod bilmeden) nasıl
> yapacağını da anlatırım.

---

## ADIM 2 — Codemagic'e bağlan (APK'yı burada derleteceğiz)

1. **codemagic.io** adresine git.
2. **"Sign up with GitHub"** ile giriş yap (GitHub hesabınla, ayrı şifre gerekmez).
3. Codemagic sana repo listeni gösterecek — `tt-sport-app` reposunu seç.
4. Proje tipi sorulunca **Flutter App** seç.
5. Codemagic otomatik bir `codemagic.yaml` önerecek — **Flutter, Android, Debug/Release APK**
   seçeneğini işaretle (ilk deneme için "Debug APK" yeterli, imzalama gerektirmez).
6. **"Start new build"** butonuna bas.

Codemagic şimdi arka planda:
- `flutter create .` ile eksik android/ios klasörlerini kendi tamamlar
- Senin `lib/` kodunu içine yerleştirir
- `flutter build apk` çalıştırır

5-10 dakika içinde build biter, **"Artifacts"** sekmesinden `app-release.apk`
dosyasını indirirsin.

---

## ADIM 3 — APK'yı telefonuna kur

1. İndirdiğin `.apk` dosyasını telefonuna aktar (WhatsApp'a kendine gönder, Google Drive,
   veya USB kablo).
2. Telefonunda dosyaya dokun, "Bilinmeyen kaynaklardan yükleme" izni istenirse onayla.
3. Kurulum tamamlanınca uygulamayı aç.

---

## ÖNEMLİ: Backend olmadan uygulama açılır ama giriş yapamazsın

Bu kod, bir **backend API adresine** bağlanmayı bekliyor (`lib/core/network/api_client.dart`
içindeki `baseUrl`). Şu an orada örnek bir adres yazıyor:

```dart
static const String baseUrl = 'https://YOUR_BACKEND_URL/api';
```

Backend'i henüz kurmadık — bu, planımızın bir sonraki adımı. Backend hazır olduğunda
bu satırı gerçek adresle değiştirip GitHub'a tekrar yükleyeceğiz, Codemagic otomatik
yeni bir APK üretecek.

**Şimdilik bu APK'yı kurup giriş ekranını, dil değiştirme butonunu (TR/AR) ve genel
tasarımı görebilirsin** — login çalışmayacak çünkü bağlanacağı bir sunucu yok.

---

## Sırada Ne Var?

Backend (NestJS + PostgreSQL) kodunu da aynı şekilde hazırlayıp, ücretsiz bir sunucuya
(Railway.app) deploy etmeni adım adım anlatacağım. O tamamlanınca bu APK gerçekten
çalışır hale gelecek (giriş, ürünler, sporcu paneli — hepsi canlı veriyle).
