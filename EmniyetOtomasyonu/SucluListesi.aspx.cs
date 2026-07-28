using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{
    public partial class SucluListesi : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSorgula_Click(object sender, EventArgs e)
        {
            GBT_Sorgula(txtGBTArama.Text.Trim());
        }

        protected void gridSuclular_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Sil")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                KayitSil(id);
            }
            else if (e.CommandName == "Duzenle")
            {
                Response.Redirect("SucluEkle.aspx?id=" + e.CommandArgument);
            }
        }

        void KayitSil(int id)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                // İlişkili kayıtları sil 
             
                string sql = @"
                    DECLARE @SucID int;
                    SELECT @SucID = SucID FROM Suclular WHERE SucluID = @ID;
                    DELETE FROM Suclular WHERE SucluID = @ID;
                    DELETE FROM Suclar WHERE SucID = @SucID;";

                SqlCommand komut = new SqlCommand(sql, baglanti);
                komut.Parameters.AddWithValue("@ID", id);

                try
                {
                    baglanti.Open();
                    komut.ExecuteNonQuery();
                    baglanti.Close();
                    GBT_Sorgula(txtGBTArama.Text.Trim()); // Listeyi yenile
                    ClientScript.RegisterStartupScript(this.GetType(), "Sil", "alert('Kayıt Silindi.');", true);
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Silme Hatası: " + ex.Message + "');</script>");
                }
            }
        }

        void GBT_Sorgula(string kelime)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                string sql = @"
                    SELECT S.SucluID, S.KimlikNo, S.Ad, S.Soyad, S.DogumTarihi, S.Cinsiyet, C.SucTuru, C.Sehir
                    FROM Suclular S
                    INNER JOIN Suclar C ON S.SucID = C.SucID
                    WHERE S.Ad LIKE @K OR S.Soyad LIKE @K OR S.KimlikNo LIKE @K";

                SqlCommand komut = new SqlCommand(sql, baglanti);
                komut.Parameters.AddWithValue("@K", "%" + kelime + "%");

                SqlDataAdapter da = new SqlDataAdapter(komut);
                DataTable dt = new DataTable();

                try
                {
                    da.Fill(dt);
                    gridSuclular.DataSource = dt;
                    gridSuclular.DataBind();

                    lblDurum.Visible = true;
                    if (dt.Rows.Count > 0)
                    {
                        lblDurum.Text = dt.Rows.Count + " ADET SABIKA KAYDI BULUNDU!";
                        lblDurum.CssClass = "d-block mt-4 p-3 bg-danger text-white fw-bold rounded shadow text-uppercase";
                    }
                    else
                    {
                        lblDurum.Text = "KAYIT TEMİZ - SABIKA YOK";
                        lblDurum.CssClass = "d-block mt-4 p-3 bg-success text-white fw-bold rounded shadow text-uppercase";
                    }
                }
                catch { }
            }
        }

        protected void gridSuclular_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.CssClass = "red-border-left";

                object c = DataBinder.Eval(e.Row.DataItem, "Cinsiyet");
                string cinsiyet = (c != null) ? c.ToString() : "E";

                Image img = (Image)e.Row.FindControl("imgProfil");
                if (cinsiyet == "K") img.ImageUrl = "https://bootdey.com/img/Content/avatar/avatar3.png";
                else img.ImageUrl = "https://bootdey.com/img/Content/avatar/avatar7.png";
            }
        }
    }
}