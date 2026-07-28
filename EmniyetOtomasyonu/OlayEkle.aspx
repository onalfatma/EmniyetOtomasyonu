<%@ Page Title="Yeni Vaka Dosyası" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OlayEkle.aspx.cs" Inherits="EmniyetOtomasyonu.OlayEkle" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .card-egm { border: none; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 8px; }
        .header-red { background: linear-gradient(45deg, #b71c1c, #d32f2f); color: white; padding: 10px 15px; border-radius: 8px 8px 0 0; font-weight: bold; }
        .header-blue { background: linear-gradient(45deg, #1a237e, #283593); color: white; padding: 10px 15px; border-radius: 8px 8px 0 0; font-weight: bold; }
        .tutanak-kagidi {
            background-color: #fffde7; 
            border: 1px solid #fbc02d;
            font-family: 'Courier New', Courier, monospace; 
            font-size: 14px;
            color: #212121;
            line-height: 1.6;
            padding: 15px;
            box-shadow: inset 0 0 10px rgba(0,0,0,0.05);
        }
        .personel-scroll { max-height: 200px; overflow-y: auto; border: 1px solid #dee2e6; border-radius: 4px; padding: 5px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

    <div class="container-fluid mt-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold text-dark"><i class="fas fa-file-contract text-danger me-2"></i>Yeni Vaka Dosyası Oluştur</h3>
            <a href="OlayKayitlari.aspx" class="btn btn-outline-secondary btn-sm">Listeye Dön</a>
        </div>

        <div class="row g-4">
            <div class="col-md-5">
                
                <div class="card card-egm mb-4">
                    <div class="header-red"><i class="fas fa-user-secret me-2"></i>ŞÜPHELİ / SANIK TESPİTİ</div>
                    <div class="card-body">
                        <asp:UpdatePanel ID="upSuclu" runat="server">
                            <ContentTemplate>
                                <div class="input-group mb-3">
                                    <asp:TextBox ID="txtTC" runat="server" CssClass="form-control" placeholder="T.C. Kimlik No Giriniz..." MaxLength="11"></asp:TextBox>
                                    <asp:Button ID="btnSorgula" runat="server" Text="SORGULA" CssClass="btn btn-dark" OnClick="btnSorgula_Click" />
                                </div>
                                
                                <asp:Panel ID="pnlSonuc" runat="server" Visible="false" CssClass="alert alert-success d-flex align-items-center">
                                    <i class="fas fa-id-card fa-2x me-3"></i>
                                    <div>
                                        <strong><asp:Label ID="lblAdSoyad" runat="server"></asp:Label></strong><br />
                                        <small>Kayıt Bulundu - ID: <asp:Label ID="lblSucluID" runat="server"></asp:Label></small>
                                        <asp:HiddenField ID="hfSucluID" runat="server" />
                                    </div>
                                </asp:Panel>
                                <asp:Label ID="lblHata" runat="server" CssClass="text-danger fw-bold small" Visible="false"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>

                <div class="card card-egm">
                    <div class="header-blue"><i class="fas fa-map-marked-alt me-2"></i>OLAY YERİ VE ZAMAN</div>
                    <div class="card-body">
                        <asp:UpdatePanel ID="upKonum" runat="server">
                            <ContentTemplate>
                                <div class="mb-2">
                                    <label class="form-label small fw-bold">Olayın Geçtiği Şehir</label>
                                    <asp:DropDownList ID="ddlSehir" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="ddlSehir_SelectedIndexChanged">
                                        <asp:ListItem Text="Seçiniz..." Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label small fw-bold">İlçe</label>
                                    <asp:DropDownList ID="ddlIlce" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Önce Şehir Seçiniz" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                        
                        <div class="row g-2 mt-2">
                            <div class="col-6">
                                <label class="form-label small fw-bold">Tarih</label>
                                <asp:TextBox ID="txtTarih" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold">Saat</label>
                                <asp:TextBox ID="txtSaat" runat="server" TextMode="Time" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                
                <div class="card card-egm h-100">
                    <div class="header-blue d-flex justify-content-between">
                        <span><i class="fas fa-file-alt me-2"></i>OLAY TUTANAĞI</span>
                        <span class="badge bg-danger">RESMİ EVRAK</span>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Suç Türü</label>
                                <asp:DropDownList ID="ddlSucTuru" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>
                        </div>

                        <label class="form-label small fw-bold">Tutanak Metni</label>
                        <asp:TextBox ID="txtTutanak" runat="server" TextMode="MultiLine" Rows="10" CssClass="form-control tutanak-kagidi" placeholder="Olayın oluş şekli, deliller ve şüpheli ifadelerini buraya daktilo formatında giriniz..."></asp:TextBox>
                        
                        <div class="mt-4">
                            <label class="form-label small fw-bold text-primary"><i class="fas fa-users me-2"></i>GÖREVLİ EKİP (Çoklu Seçim)</label>
                            <div class="personel-scroll bg-light">
                                <asp:CheckBoxList ID="cblPersonel" runat="server" CssClass="w-100 small"></asp:CheckBoxList>
                            </div>
                        </div>

                        <div class="mt-4 text-end">
                            <asp:Button ID="btnKaydet" runat="server" Text="DOSYAYI ONAYLA VE KAYDET" CssClass="btn btn-danger btn-lg w-100 shadow" OnClick="btnKaydet_Click" OnClientClick="return confirm('Bu işlem resmi kayıtlara geçecektir. Onaylıyor musunuz?');" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>