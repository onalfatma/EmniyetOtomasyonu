using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{
    public partial class Ayarlar : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                KullanicilariGetir();
                LoglariGetir();
            }
        }

        // 1. Sekme İçin: Personel Listesi
        void KullanicilariGetir()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                // Personel tablosundan veri çektim
               
                string sql = "SELECT TOP 10 Ad, Soyad, Rutbe, GorevYeri FROM Personel ORDER BY Rutbe DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, baglan);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gridKullanicilar.DataSource = dt;
                    gridKullanicilar.DataBind();
                }
                catch { }
            }
        }

        // 3. Sekme İçin: Log Kayıtları
        void LoglariGetir()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                // SistemLoglari tablosundan veri çektim
                string sql = "SELECT TOP 20 * FROM SistemLoglari ORDER BY Tarih DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, baglan);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gridLoglar.DataSource = dt;
                    gridLoglar.DataBind();
                }
                catch { }
            }
        }
    }
}