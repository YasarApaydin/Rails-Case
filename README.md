# Rails-Case Uygulaması — Kurulum ve Çalıştırma



---

## 1️⃣ Depoyu klonlayın

```bash

git clone <repo-url>
cd rails-case



2️⃣ Ortam değişkenlerini ayarlayın

Proje kök dizininde .env dosyası oluşturun ve Google Sheet ID’nizi ekleyin:

GOOGLE_SHEET_ID=<google-sheet-id>



3️⃣ Google Sheets API için Service Account oluşturun

Google Cloud Console’a gir: https://console.cloud.google.com/

Eğer yoksa bir proje oluşturun (New Project).

Proje seçili iken APIs & Services → Credentials bölümüne gidin.

3.1 Service Account oluşturun

“Create Credentials → Service Account” seçin

İsim verin, örn: google_sheets_service

Role olarak Editor veya sadece Sheets API erişimi verebilirsiniz

“Create” ve “Done” ile hesabı oluşturun

3.2 JSON key indirin

Oluşturduğunuz Service Account’a tıklayın

Keys → Add Key → Create new key → JSON

JSON dosyası bilgisayarınıza inecek

3.3 JSON dosyasını projeye ekleyin

JSON dosyasını kopyalayın:

rails-case/config/google/service_account.json


.gitignore içinde bu dosyanın ekli olduğundan emin olun:

/config/google/service_account.json

4️⃣ Docker ile uygulamayı ayağa kaldırın

Projeyi Docker ile çalıştırmak için:

docker compose build --no-cache
docker compose up -d


Not: Eğer docker compose down -v çalıştırırsanız, tüm volume’lar silinir. Bu durumda web container’ı yeniden build etmeniz gerekir:

docker compose build --no-cache
docker compose up -d

5️⃣ Veritabanını oluşturun ve migrate edin
docker compose exec web bin/rails db:create
docker compose exec web bin/rails db:migrate

6️⃣ Rails sunucusunu çalıştırın
docker compose up
# veya arka planda çalıştırmak için:
docker compose up -d


Uygulamaya tarayıcıdan erişin: http://localhost:3000

7️⃣ Eski veya terk edilmiş container’ları silmek (opsiyonel)
docker compose down --remove-orphans

8️⃣ Google Sheet kullanımı

Sheet tablosu A2’den L kolonuna kadar veri alır ve listeler.

Veri eklerken name, price, stock, category kolonlarına veri yazın ve Google Sheet → DB butonuna basın.

Birden fazla veri eklemek için, alt alta veri yazabilirsiniz.

Eğer yanlış veri girerseniz, errors kolonuna hata mesajı düşer.

Sheet kolonları:

| A  | B    | C     | D     | E        | F          | G          | H          | I          | J          | K          | L      |
| -- | ---- | ----- | ----- | -------- | ---------- | ---------- | ---------- | ---------- | ---------- | ---------- | ------ |
| id | name | price | stock | category | created_by | updated_by | deleted_at | is_deleted | created_at | updated_at | errors |


Not: Eklerken sadece name, price, stock, category kolonlarını doldurmanız yeterlidir. Hatalı veri girildiğinde errors kolonuna yazılır.
Not: .env ve config altındaki google klasörü içindeki service_account.json klasörünü githuba pushlarken ekleyemedim. Github izin vermedi. Şifre ve bazı bilgiler içerdiği için.
