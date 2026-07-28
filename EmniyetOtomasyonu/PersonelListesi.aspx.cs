using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace EmniyetOtomasyonu
{
    public partial class PersonelListesi : System.Web.UI.Page
    {
        // Web.config bağlantı cümlesi
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BirimleriGetir();
                PersonelleriListele();
            }
        }

        // --- 1. LİSTELEME ---
        void PersonelleriListele()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                // Personel + Birim Adı birleştirme sorgusu
                string sql = @"
                    SELECT 
                        P.PersonelID, 
                        P.TCKimlikNo, 
                        P.Ad, 
                        P.Soyad, 
                        P.Rutbe, 
                        B.BirimAdi 
                    FROM Personel P
                    INNER JOIN Birimler B ON P.BirimID = B.BirimID
                    WHERE 1=1 ";

                // Arama kutuları doluysa filtre ekle
                if (!string.IsNullOrEmpty(txtAraTC.Text))
                    sql += " AND P.TCKimlikNo LIKE @TC";

                if (!string.IsNullOrEmpty(txtAraAd.Text))
                    sql += " AND (P.Ad LIKE @Ad OR P.Soyad LIKE @Ad)";

                if (ddlAraBirim.SelectedValue != "0" && ddlAraBirim.SelectedValue != "")
                    sql += " AND P.BirimID = @BirimID";

                SqlCommand komut = new SqlCommand(sql, baglanti);

                // Parametreleri ata
                komut.Parameters.AddWithValue("@TC", "%" + txtAraTC.Text + "%");
                komut.Parameters.AddWithValue("@Ad", "%" + txtAraAd.Text + "%");
                if (ddlAraBirim.SelectedValue != "")
                    komut.Parameters.AddWithValue("@BirimID", ddlAraBirim.SelectedValue);

                SqlDataAdapter da = new SqlDataAdapter(komut);
                DataTable dt = new DataTable();

                try
                {
                    da.Fill(dt);
                    gridPersonel.DataSource = dt;
                    gridPersonel.DataBind();
                }
                catch (Exception ex)
                {
                    // AlertBox yerine JS uyarısı kullandım (Tasarım bozulmasın diye)
                    ClientScript.RegisterStartupScript(this.GetType(), "Hata", $"alert('Hata: {ex.Message}');", true);
                }
            }
        }

        // --- 2. DROPDOWN DOLDURMA ---
        void BirimleriGetir()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                try
                {
                    string sql = "SELECT BirimID, BirimAdi FROM Birimler ORDER BY BirimAdi ASC";
                    SqlDataAdapter da = new SqlDataAdapter(sql, baglanti);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlAraBirim.DataSource = dt;
                    ddlAraBirim.DataTextField = "BirimAdi";
                    ddlAraBirim.DataValueField = "BirimID";
                    ddlAraBirim.DataBind();

                    // En başa "Tüm Birimler" seçeneği ekle
                    ddlAraBirim.Items.Insert(0, new ListItem("Tüm Birimler", "0"));
                }
                catch
                {
                    // Hata olursa dropdown boş kalsın
                }
            }
        }

        // --- 3. SORGULA BUTONU ---
        protected void btnAra_Click(object sender, EventArgs e)
        {
            PersonelleriListele();
        }

        // --- 4. SİL / DÜZENLE BUTONLARI ---
        protected void gridPersonel_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Sil")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                PersonelSil(id);
            }
            else if (e.CommandName == "Duzenle")
            {
                Response.Redirect("PersonelEkle.aspx?id=" + e.CommandArgument);
            }
        }

        // --- 5. SİLME METODU ---
        void PersonelSil(int id)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                string sql = "DELETE FROM Personel WHERE PersonelID = @ID";
                SqlCommand komut = new SqlCommand(sql, baglanti);
                komut.Parameters.AddWithValue("@ID", id);

                try
                {
                    baglanti.Open();
                    komut.ExecuteNonQuery();
                    baglanti.Close();

                    // Listeyi yenile
                    PersonelleriListele();

                    // Başarılı uyarısı
                    ClientScript.RegisterStartupScript(this.GetType(), "Sil", "alert('Personel kaydı silindi.');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "SilHata", $"alert('Silme Hatası: {ex.Message}');", true);
                }
            }
        }
    }
}