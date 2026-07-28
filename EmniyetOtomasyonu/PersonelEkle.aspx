<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PersonelEkle.aspx.cs" Inherits="EmniyetOtomasyonu.PersonelEkle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">
        
        <div class="d-flex align-items-center justify-content-between mb-4 mt-2">
            <h1 class="h3 mb-0 text-gray-800 fw-bold">
                <i class="fas fa-user-plus text-primary me-2"></i>Personel Kayıt Ekranı
            </h1>
            <a href="PersonelListesi.aspx" class="btn btn-secondary btn-sm shadow-sm">
                <i class="fas fa-arrow-left me-1"></i> Listeye Dön
            </a>
        </div>

        <div class="card shadow mb-4 border-0 border-top border-primary border-4">
            <div class="card-header py-3">
                <h6 class="m-0 fw-bold text-primary">Personel Bilgileri</h6>
            </div>
            
            <div class="card-body">
                
                <asp:Label ID="lblMesaj" runat="server" CssClass="d-block mb-3 fw-bold"></asp:Label>

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">T.C. Kimlik No</label>
                        <asp:TextBox ID="txtTC" runat="server" CssClass="form-control" MaxLength="11" placeholder="11 haneli..."></asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Doğum Tarihi</label>
                        <asp:TextBox ID="txtDogumTarihi" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Adı</label>
                        <asp:TextBox ID="txtAd" runat="server" CssClass="form-control" placeholder="Ad giriniz..."></asp:TextBox>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Soyadı</label>
                        <asp:TextBox ID="txtSoyad" runat="server" CssClass="form-control" placeholder="Soyad giriniz..."></asp:TextBox>
                    </div>

                     <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Cinsiyet</label>
                        <asp:DropDownList ID="ddlCinsiyet" runat="server" CssClass="form-select">
                            <asp:ListItem Value="E">Erkek</asp:ListItem>
                            <asp:ListItem Value="K">Kadın</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Rütbesi</label>
                         <asp:DropDownList ID="ddlRutbe" runat="server" CssClass="form-select">
                            <asp:ListItem>Polis Memuru</asp:ListItem>
                            <asp:ListItem>Komiser Yardımcısı</asp:ListItem>
                            <asp:ListItem>Komiser</asp:ListItem>
                            <asp:ListItem>Başkomiser</asp:ListItem>
                            <asp:ListItem>Emniyet Amiri</asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Bağlı Olduğu Birim</label>
                        <asp:DropDownList ID="ddlBirim" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-muted">Maaş (TL)</label>
                        <asp:TextBox ID="txtMaas" runat="server" CssClass="form-control" TextMode="Number" placeholder="0.00"></asp:TextBox>
                    </div>

                    <div class="col-12 mt-4">
                        <div class="p-3 bg-light rounded border">
                            <h6 class="text-dark fw-bold mb-3"><i class="fas fa-map-marker-alt text-danger me-2"></i>Görev Yeri Atama</h6>
                            <div class="row">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">Şehir Seçimi</label>
                                    <asp:DropDownList ID="ddlSehir" runat="server" CssClass="form-select" 
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlSehir_SelectedIndexChanged">
                                        <asp:ListItem Text="Şehir Seçiniz..." Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold">İlçe Seçimi</label>
                                    <asp:DropDownList ID="ddlIlce" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Önce Şehir Seçiniz" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <div class="mt-4 text-end">
                    <asp:Button ID="btnKaydet" runat="server" Text="💾 KAYDI TAMAMLA" CssClass="btn btn-primary btn-lg fw-bold px-5 shadow" OnClick="btnKaydet_Click" />
                </div>

            </div>
        </div>
    </div>

</asp:Content>