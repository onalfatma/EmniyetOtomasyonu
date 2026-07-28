using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EmniyetOtomasyonu
{
    public partial class Login : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Eğer kullanıcı zaten giriş yapmışsa, tekrar Login görmesin
            if (Session["Kullanici"] != null)
            {
                Response.Redirect("Anasayfa.aspx"); // DÜZELTİLDİ: Anasayfa'ya yönlendir
            }
        }

        protected void btnGiris_Click(object sender, EventArgs e)
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                try
                {
                    baglan.Open();

                    // 1. KULLANICI KONTROLÜ
                    // Veritabanındaki kolonlar: KullaniciAdi, Sifre
                    string sql = "SELECT * FROM Personel WHERE KullaniciAdi=@kadi AND Sifre=@sifre";
                    SqlCommand cmd = new SqlCommand(sql, baglan);

                    // TextBox ID'leri: txtKullanici, txtSifre
                    cmd.Parameters.AddWithValue("@kadi", txtKullanici.Text.Trim());
                    cmd.Parameters.AddWithValue("@sifre", txtSifre.Text.Trim());

                    SqlDataReader dr = cmd.ExecuteReader();

                    if (dr.Read())
                    {
                        // --- GİRİŞ BAŞARILI ---

                        // a. Kullanıcı Bilgilerini Hafızaya Al (Session)
                        Session["Kullanici"] = "Aktif"; // Kilit anahtarı
                        Session["KullaniciID"] = dr["PersonelID"].ToString();

                        // Ad ve Soyad veritabanında ayrı, burada birleştiriyoruz
                        string tamAd = dr["Ad"].ToString() + " " + dr["Soyad"].ToString();
                        Session["AdSoyad"] = tamAd;

                        Session["Rutbe"] = dr["Rutbe"].ToString();

                        // b. Log Tut (SistemLoglari tablosuna)
                        LogTut(tamAd);

                        // c. Yönlendir (Anasayfa.aspx)
                        Response.Redirect("Anasayfa.aspx");
                    }
                    else
                    {
                        // --- HATALI GİRİŞ ---
                        Response.Write("<script>alert('Hatalı Kullanıcı Adı veya Şifre! Lütfen tekrar deneyiniz.');</script>");
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Sistem Hatası: " + ex.Message + "');</script>");
                }
            }
        }

        // --- Log Kayıt Fonksiyonu ---
        void LogTut(string isim)
        {
            try
            {
                using (SqlConnection baglan2 = new SqlConnection(baglantiCumlesi))
                {
                    baglan2.Open();
                    // Log tablosuna başarılı giriş işlemini kaydet
                    string sqlLog = "INSERT INTO SistemLoglari (Kullanici, IslemTuru, Detay, IPAdresi) VALUES (@k, 'Sistem Girişi', 'Başarılı oturum açma işlemi.', '192.168.1.10')";
                    SqlCommand cmdLog = new SqlCommand(sqlLog, baglan2);
                    cmdLog.Parameters.AddWithValue("@k", isim);
                    cmdLog.ExecuteNonQuery();
                }
            }
            catch { /* Log hatası olursa sistemi durdurma */ }
        }
    }
}