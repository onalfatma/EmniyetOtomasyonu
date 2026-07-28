# 🚔 Emniyet Otomasyon Sistemi

ASP.NET Web Forms teknolojisi kullanılarak geliştirilen, emniyet birimlerindeki temel operasyonel süreçleri dijital ortamda yönetmeyi amaçlayan web tabanlı otomasyon sistemidir.

## 📌 Proje Hakkında

Bu proje; personel yönetimi, suçlu kayıt ve sorgulama, olay kayıtları, raporlama ve yönetim paneli gibi temel emniyet operasyonlarının tek bir sistem üzerinden takip edilmesini sağlamak amacıyla geliştirilmiştir.

Sistem, kullanıcıların kayıt oluşturabilmesini, mevcut kayıtları sorgulayabilmesini ve yönetebilmesini sağlayan modüler bir yapıya sahiptir.

---

# 🚀 Özellikler

## 👮 Personel Yönetimi

- Personel kayıt oluşturma
- Personel listeleme
- Personel bilgilerini güncelleme
- Personel silme
- Birim ve görev yeri yönetimi

## 🔍 Suçlu / GBT Yönetimi

- Şüpheli ve sanık kayıt işlemleri
- Kimlik bilgileri yönetimi
- Suç türü ve olay bilgisi ekleme
- GBT sorgulama ekranı
- Kayıt güncelleme ve silme işlemleri

## 📁 Olay Yönetimi

- Yeni olay/vaka kaydı oluşturma
- Olay listeleme
- Durum ve öncelik takibi
- Arama ve filtreleme işlemleri

## 📊 Yönetim Paneli

- Genel istatistik görüntüleme
- Olay verileri analizi
- Grafiksel veri gösterimleri
- Son kayıtların takibi

---

# 🛠️ Kullanılan Teknolojiler

- ASP.NET Web Forms
- C#
- SQL Server
- ADO.NET
- HTML5
- CSS3
- Bootstrap
- JavaScript
- Visual Studio 2022

---

# 🗄️ Veritabanı

Projede SQL Server veritabanı kullanılmıştır.

Temel tablolar:

- Personel
- Birimler
- Suclular
- Suclar
- OlayKaydi
- Sehirler
- Ilceler
- SucTurleri

Veritabanı oluşturma scripti proje içerisinde ayrıca paylaşılmıştır.

---

# ⚙️ Kurulum

Projeyi çalıştırmak için:

### 1. Repository'i klonlayın

```bash
git clone https://github.com/onalfatma/EmniyetOtomasyonu.git
```

### 2. Visual Studio ile projeyi açın

Solution dosyasını açın:

```
EmniyetOtomasyonu.sln
```

### 3. Veritabanını oluşturun

SQL Server üzerinde proje içerisinde bulunan veritabanı scriptini çalıştırarak gerekli tabloları oluşturun.

### 4. Bağlantı ayarlarını düzenleyin

`Web.config` dosyası içerisindeki bağlantı cümlesini kendi SQL Server ayarlarınıza göre güncelleyin.

Örnek:

```xml
<connectionStrings>
<add name="EmniyetBaglanti"
connectionString="Data Source=SERVER_ADI;Initial Catalog=EmniyetVeriTabani;Integrated Security=True"
providerName="System.Data.SqlClient" />
</connectionStrings>
```

### 5. Projeyi çalıştırın

Visual Studio üzerinden projeyi başlatabilirsiniz.

---

# 📂 Proje Yapısı

```
EmniyetOtomasyonu

│── Anasayfa.aspx
│── PersonelListesi.aspx
│── PersonelEkle.aspx
│── SucluListesi.aspx
│── SucluEkle.aspx
│── OlayKayitlari.aspx
│── OlayEkle.aspx
│── Site.Master
│── Web.config
│── Database
│
└── EmniyetOtomasyonu.sln
```

---

# 👩‍💻 Geliştirici

**onalfatma**

GitHub:
https://github.com/onalfatma
