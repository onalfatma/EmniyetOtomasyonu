using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{

    public partial class SucluEkle : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SehirleriGetir();
                SucTurleriniGetir();
                txtSucTarihi.Text = DateTime.Now.ToString("yyyy-MM-dd");
            }
        }

        void SehirleriGetir()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT SehirID, SehirAdi FROM Sehirler ORDER BY SehirAdi ASC", baglanti);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlSehir.DataSource = dt;
                ddlSehir.DataTextField = "SehirAdi";
                ddlSehir.DataValueField = "SehirID";
                ddlSehir.DataBind();
                ddlSehir.Items.Insert(0, new ListItem("Seçiniz...", "0"));
            }
        }

        protected void ddlSehir_SelectedIndexChanged(object sender, EventArgs e)
        {
            int id = 0;
            if (int.TryParse(ddlSehir.SelectedValue, out id) && id > 0)
            {
                using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
                {
                    SqlDataAdapter da = new SqlDataAdapter("SELECT IlceID, IlceAdi FROM Ilceler WHERE SehirID=" + id, baglanti);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    ddlIlce.DataSource = dt;
                    ddlIlce.DataTextField = "IlceAdi";
                    ddlIlce.DataValueField = "IlceID";
                    ddlIlce.DataBind();
                }
            }
            ddlIlce.Items.Insert(0, new ListItem("Seçiniz...", "0"));
        }

        void SucTurleriniGetir()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT SucAdi FROM SucTurleri", baglanti);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlSucTuru.DataSource = dt;
                ddlSucTuru.DataTextField = "SucAdi";
                ddlSucTuru.DataValueField = "SucAdi";
                ddlSucTuru.DataBind();
                ddlSucTuru.Items.Insert(0, new ListItem("Seçiniz...", "0"));
            }
        }

        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            if (txtAd.Text == "" || txtTC.Text == "") return;

            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                baglanti.Open();
                string yer = ddlSehir.SelectedValue != "0" ? ddlSehir.SelectedItem.Text : "";
                if (ddlIlce.SelectedValue != "0") yer += " - " + ddlIlce.SelectedItem.Text;

                // Suç Ekle
                string sql1 = "INSERT INTO Suclar (SucTuru, Sehir, SucTarihi, Aciklama) VALUES (@S, @Y, @T, @A); SELECT SCOPE_IDENTITY();";
                SqlCommand cmd1 = new SqlCommand(sql1, baglanti);
                cmd1.Parameters.AddWithValue("@S", ddlSucTuru.SelectedValue);
                cmd1.Parameters.AddWithValue("@Y", yer);
                cmd1.Parameters.AddWithValue("@T", txtSucTarihi.Text);
                cmd1.Parameters.AddWithValue("@A", txtAciklama.Text);
                int sucID = Convert.ToInt32(cmd1.ExecuteScalar());

                // Suçlu Ekle
                string sql2 = "INSERT INTO Suclular (SucID, Ad, Soyad, KimlikNo, DogumTarihi, Cinsiyet) VALUES (@ID, @Ad, @Soy, @TC, @DT, @Cin)";
                SqlCommand cmd2 = new SqlCommand(sql2, baglanti);
                cmd2.Parameters.AddWithValue("@ID", sucID);
                cmd2.Parameters.AddWithValue("@Ad", txtAd.Text);
                cmd2.Parameters.AddWithValue("@Soy", txtSoyad.Text);
                cmd2.Parameters.AddWithValue("@TC", txtTC.Text);
                cmd2.Parameters.AddWithValue("@DT", txtDogumTarihi.Text);
                cmd2.Parameters.AddWithValue("@Cin", rblCinsiyet.SelectedValue);
                cmd2.ExecuteNonQuery();

                ClientScript.RegisterStartupScript(this.GetType(), "ok", "alert('Dosya Başarıyla Oluşturuldu.'); window.location='SucluListesi.aspx';", true);
            }
        }
    }
}