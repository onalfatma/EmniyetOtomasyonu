<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SucluEkle.aspx.cs" Inherits="EmniyetOtomasyonu.SucluEkle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .form-section-title { color: #dc3545; font-weight: bold; border-bottom: 2px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4">

        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold text-dark"><i class="fas fa-file-signature text-danger me-2"></i>Suçlu Kayıt İşlemleri</h3>
            
            <a href="SucluListesi.aspx" class="btn btn-secondary shadow-sm">
                <i class="fas fa-search me-1"></i> Sorgu Ekranına Dön
            </a>
        </div>

        <div class="card shadow border-0">
            <div class="card-header bg-danger text-white fw-bold">
                <i class="fas fa-landmark me-2"></i> Şüpheli / Sanık Profil Oluşturma
            </div>
            <div class="card-body p-4">
                
                <div class="row">
                    <div class="col-md-6 border-end pe-4">
                        <h6 class="form-section-title"><i class="fas fa-id-card me-2"></i>KİMLİK BİLGİLERİ</h6>
                        <div class="row g-3">
                            <div class="col-md-6"><label class="form-label fw-bold small text-muted">T.C. Kimlik No</label><asp:TextBox ID="txtTC" runat="server" CssClass="form-control" MaxLength="11"></asp:TextBox></div>
                            <div class="col-md-6"><label class="form-label fw-bold small text-muted">Doğum Tarihi</label><asp:TextBox ID="txtDogumTarihi" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox></div>
                            <div class="col-md-6"><label class="form-label fw-bold small text-muted">Adı</label><asp:TextBox ID="txtAd" runat="server" CssClass="form-control"></asp:TextBox></div>
                            <div class="col-md-6"><label class="form-label fw-bold small text-muted">Soyadı</label><asp:TextBox ID="txtSoyad" runat="server" CssClass="form-control"></asp:TextBox></div>
                            <div class="col-md-12">
                                <label class="form-label fw-bold small text-muted">Cinsiyet</label>
                                <div class="ps-2">
                                    <asp:RadioButtonList ID="rblCinsiyet" runat="server" RepeatDirection="Horizontal">
                                        <asp:ListItem Value="E" Selected="True">Erkek &nbsp;&nbsp;</asp:ListItem>
                                        <asp:ListItem Value="K">Kadın</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 ps-4">
                        <h6 class="form-section-title"><i class="fas fa-gavel me-2"></i>SUÇ & OLAY DETAYLARI</h6>
                        <div class="row g-3">
                            <div class="col-md-12"><label class="form-label fw-bold small text-muted">Suç Türü</label><asp:DropDownList ID="ddlSucTuru" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="col-md-6"><label class="form-label fw-bold small text-muted">Olay Yeri (Şehir)</label><asp:DropDownList ID="ddlSehir" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSehir_SelectedIndexChanged"></asp:DropDownList></div>
                            <div class="col-md-6"><label class="form-label fw-bold small text-muted">Olay Yeri (İlçe)</label><asp:DropDownList ID="ddlIlce" runat="server" CssClass="form-select"></asp:DropDownList></div>
                            <div class="col-md-12"><label class="form-label fw-bold small text-muted">Olay Tarihi</label><asp:TextBox ID="txtSucTarihi" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox></div>
                            <div class="col-md-12"><label class="form-label fw-bold small text-muted">Açıklama</label><asp:TextBox ID="txtAciklama" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox></div>
                        </div>
                    </div>
                </div>

                <hr class="my-4"/>
                <div class="d-flex justify-content-end">
                    <asp:Button ID="btnKaydet" runat="server" Text="DOSYAYI OLUŞTUR VE KAYDET" CssClass="btn btn-danger btn-lg shadow fw-bold px-4" OnClick="btnKaydet_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>