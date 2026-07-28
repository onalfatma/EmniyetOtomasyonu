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
    public partial class OlayKayitlari : System.Web.UI.Page
    {
        // Web.config dosyanızdaki bağlantı adını buraya alıyoruz
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Sayfa ilk açıldığında listeyi getir
                Listele();
            }
        }

        void Listele()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                // SQL JOIN SORGUSU (Düzeltildi: T.SucTurID kullanıldı)
                string sql = @"
                    SELECT 
                        O.OlayID, 
                        O.DosyaNo, 
                        O.OlayTarihi, 
                        O.SonDurum,
                        ISNULL(S.SehirAdi, 'Belirsiz') as SehirAdi, 
                        ISNULL(I.IlceAdi, '-') as IlceAdi,
                        ISNULL(T.SucAdi, 'Diğer') as SucAdi
                    FROM OlayKaydi O
                    LEFT JOIN Sehirler S ON O.SehirID = S.SehirID
                    LEFT JOIN Ilceler I ON O.IlceID = I.IlceID
                    LEFT JOIN SucTurleri T ON O.OlayTurID = T.SucTurID 
                    WHERE 1=1 ";

                // 1. Arama Filtresi (Eğer arama kutusu doluysa)
                if (!string.IsNullOrEmpty(txtAra.Text))
                {
                    sql += " AND (O.DosyaNo LIKE @ara OR S.SehirAdi LIKE @ara OR T.SucAdi LIKE @ara)";
                }

                // 2. Durum Filtresi (Eğer dropdown seçiliyse)
                if (!string.IsNullOrEmpty(ddlDurum.SelectedValue))
                {
                    sql += " AND O.SonDurum = @durum";
                }

                // Tarihe göre en yeniden eskiye sırala
                sql += " ORDER BY O.OlayTarihi DESC";

                SqlDataAdapter da = new SqlDataAdapter(sql, baglan);
                // Parametreleri ekle
                da.SelectCommand.Parameters.AddWithValue("@ara", "%" + txtAra.Text + "%");
                da.SelectCommand.Parameters.AddWithValue("@durum", ddlDurum.SelectedValue);

                DataTable dt = new DataTable();
                try
                {
                    da.Fill(dt);
                    gvOlaylar.DataSource = dt;
                    gvOlaylar.DataBind();
                }
                catch (Exception ex)
                {
                    // Hata olursa kullanıcıya bildir (Kırmızı şerit yerine şık bir uyarı)
                    Response.Write("<script>alert('Liste çekilirken hata oluştu: " + ex.Message.Replace("'", "") + "');</script>");
                }
            }
        }

        // Arama butonuna basınca
        protected void btnAra_Click(object sender, EventArgs e)
        {
            Listele();
        }

        // Filtrele butonuna basınca
        protected void btnFiltrele_Click(object sender, EventArgs e)
        {
            Listele();
        }

        // Tablo satırları oluşurken çalışan Renklendirme Kodu (Badge)
        protected void gvOlaylar_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Label lbl = (Label)e.Row.FindControl("lblDurum");
                if (lbl != null)
                {
                    string durum = lbl.Text;
                    // Duruma göre CSS sınıfı ekle
                    if (durum == "Açık") lbl.CssClass += " durum-acik";
                    else if (durum == "İncelemede") lbl.CssClass += " durum-inceleme";
                    else if (durum == "Sonuçlandı" || durum == "Kapalı") lbl.CssClass += " durum-kapali";
                }
            }
        }

        // Silme Butonu İşlemi
        protected void btnSil_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int id = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                baglan.Open();
                SqlCommand cmd = new SqlCommand("DELETE FROM OlayKaydi WHERE OlayID=@id", baglan);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
            // Sildikten sonra listeyi yenile
            Listele();
        }
    }
}