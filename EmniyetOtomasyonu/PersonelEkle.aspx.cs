using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{
    public partial class PersonelEkle : System.Web.UI.Page
    {
        // Bağlantı cümlesi (Web.config dosyanı okur)
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Sayfa ilk açıldığında listeleri doldur
                BirimleriGetir();
                SehirleriGetir();

                // Eğer "Düzenle" diyerek geldiyse (adres çubuğunda ?id=5 varsa)
                if (Request.QueryString["id"] != null)
                {
                    int id = Convert.ToInt32(Request.QueryString["id"]);
                    BilgileriGetir(id);
                    btnKaydet.Text = "✏️ GÜNCELLE"; // Buton yazısını değiştir
                }
            }
        }

        // 1. ŞEHİRLERİ DOLDUR (Dropdown)
        void SehirleriGetir()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                // Resimdeki tablo adına göre: SehirID, SehirAdi
                SqlDataAdapter da = new SqlDataAdapter("SELECT SehirID, SehirAdi FROM Sehirler ORDER BY SehirAdi ASC", baglanti);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlSehir.DataSource = dt;
                ddlSehir.DataTextField = "SehirAdi";
                ddlSehir.DataValueField = "SehirID";
                ddlSehir.DataBind();

                ddlSehir.Items.Insert(0, new ListItem("Şehir Seçiniz...", "0"));
            }
        }

        // 2. İLÇELERİ DOLDUR (Şehir seçilince çalışır) 
        protected void ddlSehir_SelectedIndexChanged(object sender, EventArgs e)
        {
            int secilenSehirID = Convert.ToInt32(ddlSehir.SelectedValue);

            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                // Resimdeki tabloya göre: SehirID sütununa göre filtreliyoruz
                string sql = "SELECT IlceID, IlceAdi FROM Ilceler WHERE SehirID = @SehirID ORDER BY IlceAdi ASC";
                SqlCommand komut = new SqlCommand(sql, baglanti);
                komut.Parameters.AddWithValue("@SehirID", secilenSehirID);

                SqlDataAdapter da = new SqlDataAdapter(komut);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlIlce.DataSource = dt;
                ddlIlce.DataTextField = "IlceAdi";
                ddlIlce.DataValueField = "IlceID";
                ddlIlce.DataBind();

                ddlIlce.Items.Insert(0, new ListItem("İlçe Seçiniz...", "0"));
            }
        }

        // 3. BİRİMLERİ DOLDUR
        void BirimleriGetir()
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT BirimID, BirimAdi FROM Birimler", baglanti);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlBirim.DataSource = dt;
                ddlBirim.DataTextField = "BirimAdi";
                ddlBirim.DataValueField = "BirimID";
                ddlBirim.DataBind();
            }
        }

        // 4. KAYDET BUTONU (Hem Ekleme Hem Güncelleme Yapar)
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                string sql = "";

                // İki dropdown'ı birleştirip tek bir metin yaptım
                
                string gorevYeriTam = "";
                if (ddlSehir.SelectedValue != "0" && ddlIlce.SelectedValue != "0")
                {
                    gorevYeriTam = ddlSehir.SelectedItem.Text + " - " + ddlIlce.SelectedItem.Text;
                }
                else
                {
                    // Eğer seçmediyse boş geçmesin
                    gorevYeriTam = "Merkez Atama";
                }

                if (Request.QueryString["id"] == null)
                {
                    // YENİ KAYIT (INSERT)
                    sql = @"INSERT INTO Personel (TCKimlikNo, Ad, Soyad, DogumTarihi, Cinsiyet, Rutbe, GorevYeri, Maas, BirimID) 
                            VALUES (@TC, @Ad, @Soyad, @Dogum, @Cinsiyet, @Rutbe, @GorevYeri, @Maas, @BirimID)";
                }
                else
                {
                    // GÜNCELLEME (UPDATE)
                    sql = @"UPDATE Personel SET 
                            TCKimlikNo=@TC, Ad=@Ad, Soyad=@Soyad, DogumTarihi=@Dogum, 
                            Cinsiyet=@Cinsiyet, Rutbe=@Rutbe, GorevYeri=@GorevYeri, Maas=@Maas, BirimID=@BirimID 
                            WHERE PersonelID=@ID";
                }

                SqlCommand komut = new SqlCommand(sql, baglanti);
                komut.Parameters.AddWithValue("@TC", txtTC.Text);
                komut.Parameters.AddWithValue("@Ad", txtAd.Text);
                komut.Parameters.AddWithValue("@Soyad", txtSoyad.Text);
                komut.Parameters.AddWithValue("@Dogum", txtDogumTarihi.Text); // Tarih formatı düzgün girilmeli
                komut.Parameters.AddWithValue("@Cinsiyet", ddlCinsiyet.SelectedValue);
                komut.Parameters.AddWithValue("@Rutbe", ddlRutbe.SelectedValue);
                komut.Parameters.AddWithValue("@GorevYeri", gorevYeriTam); // Birleştirilmiş metni kaydediyoruz

                // Maaş boş girilirse hata vermesin, 0 yapalım
                decimal maas = 0;
                decimal.TryParse(txtMaas.Text, out maas);
                komut.Parameters.AddWithValue("@Maas", maas);

                komut.Parameters.AddWithValue("@BirimID", ddlBirim.SelectedValue);

                if (Request.QueryString["id"] != null)
                {
                    komut.Parameters.AddWithValue("@ID", Request.QueryString["id"]);
                }

                try
                {
                    baglanti.Open();
                    komut.ExecuteNonQuery();
                    baglanti.Close();

                    // Başarılı olursa listeye geri dön
                    Response.Redirect("PersonelListesi.aspx");
                }
                catch (Exception ex)
                {
                    lblMesaj.Text = "Hata oluştu: " + ex.Message;
                    lblMesaj.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        // 5. BİLGİLERİ GETİR (DÜZENLEME MODU İÇİN)
        void BilgileriGetir(int id)
        {
            using (SqlConnection baglanti = new SqlConnection(baglantiCumlesi))
            {
                string sql = "SELECT * FROM Personel WHERE PersonelID = @ID";
                SqlCommand komut = new SqlCommand(sql, baglanti);
                komut.Parameters.AddWithValue("@ID", id);

                baglanti.Open();
                SqlDataReader dr = komut.ExecuteReader();
                if (dr.Read())
                {
                    txtTC.Text = dr["TCKimlikNo"].ToString();
                    txtAd.Text = dr["Ad"].ToString();
                    txtSoyad.Text = dr["Soyad"].ToString();

                    // Tarih formatını input type="date" için ayarlamamız lazım (yyyy-MM-dd)
                    if (dr["DogumTarihi"] != DBNull.Value)
                    {
                        txtDogumTarihi.Text = Convert.ToDateTime(dr["DogumTarihi"]).ToString("yyyy-MM-dd");
                    }

                    ddlCinsiyet.SelectedValue = dr["Cinsiyet"].ToString();
                    ddlRutbe.SelectedValue = dr["Rutbe"].ToString();
                    txtMaas.Text = dr["Maas"].ToString();
                    ddlBirim.SelectedValue = dr["BirimID"].ToString();
                }
                baglanti.Close();
            }
        }
    }
}