using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace EmniyetOtomasyonu
{
    public partial class OlayEkle : System.Web.UI.Page
    {
        string baglantiCumlesi = ConfigurationManager.ConnectionStrings["EmniyetBaglanti"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Tarih ve Saati Varsayılan Ayarla
                txtTarih.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtSaat.Text = DateTime.Now.ToString("HH:mm");

                DropdownlariDoldur();

                // --- 112 İHBAR HATTI ENTEGRASYONU ---
                // Eğer sayfaya İhbar Hattı'ndan gelindiyse verileri otomatik doldur
                if (Request.QueryString["IhbarID"] != null)
                {
                    IhbarVerileriniIsle();
                }
            }
        }

        void DropdownlariDoldur()
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                baglan.Open();

                // 1. Şehirleri Doldur
                SqlDataAdapter daSehir = new SqlDataAdapter("SELECT SehirID, SehirAdi FROM Sehirler ORDER BY SehirAdi", baglan);
                DataTable dtSehir = new DataTable();
                daSehir.Fill(dtSehir);
                ddlSehir.DataSource = dtSehir;
                ddlSehir.DataTextField = "SehirAdi";
                ddlSehir.DataValueField = "SehirID";
                ddlSehir.DataBind();
                ddlSehir.Items.Insert(0, new ListItem("Seçiniz...", "0"));

                // 2. Suç Türlerini Doldur
                SqlDataAdapter daSuc = new SqlDataAdapter("SELECT SucTurID, SucAdi FROM SucTurleri ORDER BY SucAdi", baglan);
                DataTable dtSuc = new DataTable();
                daSuc.Fill(dtSuc);
                ddlSucTuru.DataSource = dtSuc;
                ddlSucTuru.DataTextField = "SucAdi";
                ddlSucTuru.DataValueField = "SucTurID";
                ddlSucTuru.DataBind();
                ddlSucTuru.Items.Insert(0, new ListItem("Seçiniz...", "0"));

                // 3. Personel Listesini Doldur (CheckboxList)
                // Personel tablosundan Ad, Soyad ve Rütbe çekiyoruz
                SqlDataAdapter daPersonel = new SqlDataAdapter("SELECT PersonelID, (Ad + ' ' + Soyad + ' - ' + Rutbe) as TamAd FROM Personel ORDER BY Ad", baglan);
                DataTable dtPersonel = new DataTable();

                try
                {
                    daPersonel.Fill(dtPersonel);
                    cblPersonel.DataSource = dtPersonel;
                    cblPersonel.DataTextField = "TamAd";
                    cblPersonel.DataValueField = "PersonelID";
                    cblPersonel.DataBind();
                }
                catch { /* Hata olursa personel listesi boş gelir, sistemi bozmaz */ }
            }
        }

        // Şehir seçilince İlçeleri Getir
        protected void ddlSehir_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlSehir.SelectedValue != "0")
            {
                using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
                {
                    baglan.Open();
                    // Ilceler tablosunda SehirID olduğunu varsayıyoruz (Standart yapı)
                    SqlDataAdapter daIlce = new SqlDataAdapter("SELECT IlceID, IlceAdi FROM Ilceler WHERE SehirID=@sid ORDER BY IlceAdi", baglan);
                    daIlce.SelectCommand.Parameters.AddWithValue("@sid", ddlSehir.SelectedValue);

                    DataTable dtIlce = new DataTable();
                    try
                    {
                        daIlce.Fill(dtIlce);
                        ddlIlce.DataSource = dtIlce;
                        ddlIlce.DataTextField = "IlceAdi";
                        ddlIlce.DataValueField = "IlceID";
                        ddlIlce.DataBind();
                        ddlIlce.Items.Insert(0, new ListItem("Seçiniz...", "0"));
                    }
                    catch
                    {
                        // Eğer Ilceler tablosu yoksa veya hata verirse
                        ddlIlce.Items.Clear();
                        ddlIlce.Items.Add(new ListItem("İlçe verisi yüklenemedi", "0"));
                    }
                }
            }
            else
            {
                ddlIlce.Items.Clear();
                ddlIlce.Items.Add(new ListItem("Önce Şehir Seçiniz", "0"));
            }
        }

        void IhbarVerileriniIsle()
        {
            // İhbar Hattından gelen verileri al
            string gelenTur = Request.QueryString["Tur"];
            string gelenKonum = Request.QueryString["Konum"]; // Örn: İstanbul - Beşiktaş
            string ihbarID = Request.QueryString["IhbarID"];

            // A. Şehri Yakalamaya Çalış
            // Gelen konum metninde dropdown'daki şehirlerden biri geçiyor mu?
            foreach (ListItem item in ddlSehir.Items)
            {
                if (!string.IsNullOrEmpty(gelenKonum) && gelenKonum.Contains(item.Text))
                {
                    ddlSehir.ClearSelection();
                    item.Selected = true;
                    // Şehir seçildi, tetikleyelim ki ilçeler de gelsin (Manuel tetikleme)
                    ddlSehir_SelectedIndexChanged(null, null);
                    break;
                }
            }

            // B. Suç Türünü Yakala
            foreach (ListItem item in ddlSucTuru.Items)
            {
                if (!string.IsNullOrEmpty(gelenTur) && item.Text.Contains(gelenTur))
                {
                    ddlSucTuru.ClearSelection();
                    item.Selected = true;
                    break;
                }
            }

            // C. Tutanak Metnine Resmi Bir Giriş Yap
            txtTutanak.Text = $"[112 İHBAR MERKEZİ KAYDI - REF NO: {ihbarID}]\n" +
                              $"Bildirilen Konum: {gelenKonum}\n" +
                              $"Bildirilen Vaka Türü: {gelenTur}\n" +
                              $"--------------------------------------------------\n" +
                              $"OLAY YERİ İNCELEME VE TUTANAK BAŞLANGICI:\n";
        }

        // ŞÜPHELİ SORGULAMA BUTONU
        protected void btnSorgula_Click(object sender, EventArgs e)
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                baglan.Open();
                // Suclular tablosundan TC ile sorgulama
                SqlCommand cmd = new SqlCommand("SELECT SucluID, Ad, Soyad FROM Suclular WHERE TCKimlikNo=@tc", baglan);
                cmd.Parameters.AddWithValue("@tc", txtTC.Text.Trim());

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    pnlSonuc.Visible = true;
                    lblHata.Visible = false;
                    lblAdSoyad.Text = dr["Ad"].ToString() + " " + dr["Soyad"].ToString();
                    lblSucluID.Text = dr["SucluID"].ToString();
                    hfSucluID.Value = dr["SucluID"].ToString();
                }
                else
                {
                    pnlSonuc.Visible = false;
                    lblHata.Visible = true;
                    lblHata.Text = "Sistemde bu T.C. kimlik numarasına ait sabıka kaydı bulunamadı.";
                }
            }
        }

        // KAYDET BUTONU
        protected void btnKaydet_Click(object sender, EventArgs e)
        {
            using (SqlConnection baglan = new SqlConnection(baglantiCumlesi))
            {
                baglan.Open();
                SqlTransaction transaction = baglan.BeginTransaction(); // Hata olursa her şeyi geri al

                try
                {
                    // 1. Olayı Kaydet (OlayKaydi Tablosu)
                    // IlceID'yi de ekliyoruz çünkü tasarımında var
                    string sqlOlay = @"INSERT INTO OlayKaydi 
                                   (DosyaNo, OlayTarihi, OlaySaat, OlayTurID, SehirID, IlceID, Aciklama, SonDurum, Oncelik) 
                                   VALUES 
                                   (@DosyaNo, @Tarih, @Saat, @TurID, @SehirID, @IlceID, @Aciklama, 'Açık', 'Normal'); 
                                   SELECT SCOPE_IDENTITY();";

                    SqlCommand cmdOlay = new SqlCommand(sqlOlay, baglan, transaction);

                    // Dosya No Üret: OLY-2026-X
                    string dosyaNo = "OLY-" + DateTime.Now.Year + "-" + new Random().Next(10000, 99999);

                    cmdOlay.Parameters.AddWithValue("@DosyaNo", dosyaNo);
                    cmdOlay.Parameters.AddWithValue("@Tarih", txtTarih.Text);
                    cmdOlay.Parameters.AddWithValue("@Saat", txtSaat.Text);
                    cmdOlay.Parameters.AddWithValue("@TurID", ddlSucTuru.SelectedValue);
                    cmdOlay.Parameters.AddWithValue("@SehirID", ddlSehir.SelectedValue);

                    // İlçe seçilmediyse NULL gönder (Hata almamak için)
                    if (ddlIlce.SelectedValue != "" && ddlIlce.SelectedValue != "0")
                        cmdOlay.Parameters.AddWithValue("@IlceID", ddlIlce.SelectedValue);
                    else
                        cmdOlay.Parameters.AddWithValue("@IlceID", DBNull.Value);

                    // Şüpheli bilgisini tutanağa ek not olarak düşelim
                    string sonTutanak = txtTutanak.Text;
                    if (!string.IsNullOrEmpty(lblAdSoyad.Text))
                    {
                        sonTutanak += $"\n\n[SİSTEM NOTU]: Olayla ilişkili tespit edilen şüpheli: {lblAdSoyad.Text} (TC: {txtTC.Text})";
                    }

                    cmdOlay.Parameters.AddWithValue("@Aciklama", sonTutanak);

                    // OlayID'yi al (İlişkili tablolar için lazım)
                    int yeniOlayID = Convert.ToInt32(cmdOlay.ExecuteScalar());

                    // 2. Seçilen Personelleri Kaydet (OlayPersonel Tablosu)
                    foreach (ListItem item in cblPersonel.Items)
                    {
                        if (item.Selected)
                        {
                            string sqlPersonel = "INSERT INTO OlayPersonel (OlayID, PersonelID, Gorev) VALUES (@OlayID, @PersonelID, 'Olay Yeri İnceleme Ekibi')";
                            SqlCommand cmdPers = new SqlCommand(sqlPersonel, baglan, transaction);
                            cmdPers.Parameters.AddWithValue("@OlayID", yeniOlayID);
                            cmdPers.Parameters.AddWithValue("@PersonelID", item.Value);
                            cmdPers.ExecuteNonQuery();
                        }
                    }

                    // 3. İhbar Hattından Geldiyse İhbarı Kapat
                    if (Request.QueryString["IhbarID"] != null)
                    {
                        string ihbarID = Request.QueryString["IhbarID"];
                        SqlCommand cmdIhbar = new SqlCommand("UPDATE Ihbarlar SET Durum='Sonuçlandı' WHERE IhbarID=@id", baglan, transaction);
                        cmdIhbar.Parameters.AddWithValue("@id", ihbarID);
                        cmdIhbar.ExecuteNonQuery();
                    }

                    transaction.Commit(); // Her şey başarılı, onayla

                    // Başarılı yönlendirmesi
                    Response.Redirect("OlayKayitlari.aspx");
                }
                catch (Exception ex)
                {
                    transaction.Rollback(); // Hata oldu, işlemleri geri al
                    // Hata mesajını geçici olarak tutanağa yazıp görebilirsin (Geliştirme aşaması için)
                    // txtTutanak.Text += "\n\nHATA OLUŞTU: " + ex.Message;
                }
            }
        }
    }
}