using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{
    public partial class Ihbarlar : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                IhbarlariGetir();
                SayaclariGuncelle();
            }
        }

        protected void btnYenile_Click(object sender, EventArgs e)
        {
            IhbarlariGetir();
            SayaclariGuncelle();
        }

        protected void ddlFiltre_SelectedIndexChanged(object sender, EventArgs e)
        {
            IhbarlariGetir();
        }

        void IhbarlariGetir()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                // SQL Sorgusu: Tüm alanları çekiyoruz
           
                string sql = "SELECT * FROM Ihbarlar WHERE 1=1 ";

                // Filtreleme Mantığı
                if (ddlFiltre.SelectedValue == "Yeni")
                {
                    sql += " AND Durum = 'Yeni'";
                }
                else if (ddlFiltre.SelectedValue == "Acil")
                {
                    sql += " AND Oncelik = 'Acil'";
                }
                else if (ddlFiltre.SelectedValue == "Sonuc")
                {
                    sql += " AND (Durum = 'Sonuçlandı' OR Durum = 'Asılsız')";
                }

                // En yeni ihbar en üstte
                sql += " ORDER BY IhbarTarihi DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, baglan);
                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gridIhbarlar.DataSource = dt;
                    gridIhbarlar.DataBind();
                }
                catch { }
            }
        }

        void SayaclariGuncelle()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                baglan.Open();

                // Bekleyen Acil İhbar Sayısı
                SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM Ihbarlar WHERE Oncelik='Acil' AND Durum='Yeni'", baglan);
                lblAcilSayi.Text = cmd1.ExecuteScalar().ToString();

                // Bugün Gelen İhbar Sayısı
                SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM Ihbarlar WHERE CAST(IhbarTarihi AS DATE) = CAST(GETDATE() AS DATE)", baglan);
                lblBugunSayi.Text = cmd2.ExecuteScalar().ToString();
            }
        }

        // Tablodaki "Asılsız" butonuna basılınca çalışan kısım
        protected void gridIhbarlar_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Asilsiz")
            {
                int id = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
                {
                    baglan.Open();
                    // İhbarı 'Asılsız' olarak işaretle
                    SqlCommand cmd = new SqlCommand("UPDATE Ihbarlar SET Durum='Asılsız' WHERE IhbarID=@id", baglan);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.ExecuteNonQuery();
                }

                // Listeyi yenile ki değişiklik görünsün
                IhbarlariGetir();
                SayaclariGuncelle();
            }
        }
    }
}