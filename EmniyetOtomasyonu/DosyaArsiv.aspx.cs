using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EmniyetOtomasyonu
{
    public partial class DosyaArsiv : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Varsayılan tarih: Bu yılın başı
                txtTarihBas.Text = DateTime.Now.ToString("yyyy-01-01");

                // Evrak No ve Tarihi Hazırla
                EvrakBilgisiGuncelle();

                // İlk açılışta Genel Raporu getir
                RaporuGetir();
            }
        }

        protected void btnOlustur_Click(object sender, EventArgs e)
        {
            EvrakBilgisiGuncelle();
            RaporuGetir();
        }

        void EvrakBilgisiGuncelle()
        {
            lblTarih.Text = DateTime.Now.ToString("dd.MM.yyyy HH:mm");
            // Rastgele bir resmi evrak numarası üret (Örn: EGM-2026-45892)
            lblEvrakNo.Text = "EGM-" + DateTime.Now.Year + "-" + new Random().Next(10000, 99999);
        }

        void RaporuGetir()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                string sql = "";
                string secim = ddlRaporTuru.SelectedValue;

                // Tarih Filtresi Parametresi
                string tarihSarti = " AND O.OlayTarihi >= @tarih";

                
                string olaySorgusu = @"SELECT O.DosyaNo AS [DOSYA NO], 
                                              FORMAT(O.OlayTarihi, 'dd.MM.yyyy') AS [TARİH], 
                                              ISNULL(T.SucAdi, 'Belirsiz') AS [SUÇ TÜRÜ], 
                                              ISNULL(S.SehirAdi, '-') AS [BÖLGE], 
                                              O.SonDurum AS [DURUM], 
                                              O.Oncelik AS [ÖNCELİK]
                                       FROM OlayKaydi O
                                       LEFT JOIN SucTurleri T ON O.OlayTurID = T.SucTurID
                                       LEFT JOIN Sehirler S ON O.SehirID = S.SehirID
                                       WHERE 1=1 " + tarihSarti;

                if (secim == "Genel")
                {
                    lblRaporBaslik.Text = "GENEL ASAYİŞ DURUM ÖZETİ";
                    sql = olaySorgusu + " ORDER BY O.OlayTarihi DESC";
                }
                else if (secim == "Arsiv")
                {
                    lblRaporBaslik.Text = "KAPANMIŞ DOSYA ARŞİV LİSTESİ";
                    // Sadece Sonuçlandı veya Kapalı olanlar
                    sql = olaySorgusu + " AND (O.SonDurum = 'Sonuçlandı' OR O.SonDurum = 'Kapalı' OR O.SonDurum = 'Çözüldü') ORDER BY O.OlayTarihi DESC";
                }
                else if (secim == "Kritik")
                {
                    lblRaporBaslik.Text = "ACİL MÜDAHALE VE KRİTİK DOSYALAR";
                    // Sadece 'Kritik' öncelikli olanlar
                    sql = olaySorgusu + " AND O.Oncelik = 'Kritik' ORDER BY O.OlayTarihi DESC";
                }
                else if (secim == "Personel")
                {
                    // Personel Raporu Sorgusu
                    lblRaporBaslik.Text = "PERSONEL GÖREV DAĞILIM ÇİZELGESİ";

                    sql = @"SELECT P.Ad + ' ' + P.Soyad AS [PERSONEL], 
                                   P.Rutbe AS [RÜTBE], 
                                   COUNT(OP.OlayID) AS [ATANDIĞI DOSYA SAYISI]
                            FROM Personel P
                            LEFT JOIN OlayPersonel OP ON P.PersonelID = OP.PersonelID
                            GROUP BY P.Ad, P.Soyad, P.Rutbe
                            ORDER BY [ATANDIĞI DOSYA SAYISI] DESC";
                }

                SqlDataAdapter da = new SqlDataAdapter(sql, baglan);

                // Tarih parametresini sadece Olay sorgularında ekliyoruz
                if (secim != "Personel")
                {
                    da.SelectCommand.Parameters.AddWithValue("@tarih", txtTarihBas.Text);
                }

                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gvRapor.DataSource = dt;
                    gvRapor.DataBind();
                    lblKayitSayisi.Text = dt.Rows.Count.ToString();
                }
                catch { }
            }
        }
    }
}