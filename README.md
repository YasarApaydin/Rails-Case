# README

1. Depoyu klonlayın

git clone <repo-url>
cd rails-case


2. Docker ile uygulamayı ayağa kaldırın

docker compose build --no-cache
docker compose up -d


Not: Eğer docker compose down -v çalıştırırsanız, tüm volume’lar silinir. Bu durumda web container’ı yeniden build etmeniz gerekir.



3. Veritabanını oluşturun ve migrate edin

docker compose exec web bin/rails db:create
docker compose exec web bin/rails db:migrate


4. Rails sunucusunu çalıştırın
docker compose up
docker compose up -d /dteç modda calıştırmak için 

Uygulamaya http://localhost:3000 adresinden erişebilirsiniz.

5. docker-compose.yml içinde tanımlı olmayan eski veya terk edilmiş container’ları siler.Yapmak mecburi değil.
docker compose down --remove-orphans


Google Sheet Tablosu A2(A3,A4,A5....) den L colonuna kadar bilgileri getirir listeler.
Aynı Şekilde B2 den E2 ye kadar yani (name,price,stock,category) bilgileri yazarsanız ve google sheet -> Db butonuna 
basarsanız ekler veritabanına. tabi bunun altına ekleyerek listeli bir halde yani coklu bir şekilde alt altına veri girerek ekleyebilirsiniz.
id	name	price	stock	category	created_by	updated_by	deleted_at	is_deleted	created_at	updated_at	errors
A1 den L1 e kadar bunları yazıp bu şekilde listeletiyorum.
Veri eklerkende sadece name,price,stock,category kolonlarına örnek veri yazıp butonla ekliyorum. Tabi yazarken bilerek yanlış yazarsam errors kolonuna hatası yazıyor. 

