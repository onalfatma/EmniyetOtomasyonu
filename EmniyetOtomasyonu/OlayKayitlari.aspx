<%@ Page Title="Olay Kayıtları" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OlayKayitlari.aspx.cs" Inherits="EmniyetOtomasyonu.OlayKayitlari" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Rozet Tasarımları */
        .badge-durum { padding: 6px 12px; border-radius: 4px; font-weight: bold; font-size: 0.85rem; letter-spacing: 0.5px; }
        .durum-acik { background-color: #ffebee; color: #c62828; border: 1px solid #ef9a9a; }
        .durum-inceleme { background-color: #fff8e1; color: #f57f17; border: 1px solid #ffe082; }
        .durum-kapali { background-color: #e8f5e9; color: #2e7d32; border: 1px solid #a5d6a7; }
        
        .table-hover tbody tr:hover { background-color: #f5f5f5; }
        .search-box { border-radius: 20px 0 0 20px; border-right: none; }
        .search-btn { border-radius: 0 20px 20px 0; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="text-dark fw-bold mb-0"><i class="fas fa-folder-open text-primary me-2"></i>Vaka Dosyaları</h2>
                <small class="text-muted">Sistemdeki olay kayıtlarının yönetim paneli</small>
            </div>
            <a href="OlayEkle.aspx" class="btn btn-primary px-4 shadow-sm">
                <i class="fas fa-plus me-2"></i>Yeni Dosya Aç
            </a>
        </div>

        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body bg-light rounded">
                <div class="row g-2">
                    <div class="col-md-5">
                        <div class="input-group">
                            <asp:TextBox ID="txtAra" runat="server" CssClass="form-control search-box" placeholder="Dosya No, Şehir veya Suç Türü Ara..."></asp:TextBox>
                            <asp:Button ID="btnAra" runat="server" Text="🔍" CssClass="btn btn-dark search-btn" OnClick="btnAra_Click" />
                        </div>
                    </div>
                    <div class="col-md-3">
                        <asp:DropDownList ID="ddlDurum" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Tüm Durumlar" Value=""></asp:ListItem>
                            <asp:ListItem Text="Açık" Value="Açık"></asp:ListItem>
                            <asp:ListItem Text="İncelemede" Value="İncelemede"></asp:ListItem>
                            <asp:ListItem Text="Sonuçlandı" Value="Sonuçlandı"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-2">
                         <asp:Button ID="btnFiltrele" runat="server" Text="Filtrele" CssClass="btn btn-outline-dark w-100" OnClick="btnFiltrele_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <asp:GridView ID="gvOlaylar" runat="server" CssClass="table table-hover align-middle mb-0" 
                    AutoGenerateColumns="false" GridLines="None" 
                    OnRowDataBound="gvOlaylar_RowDataBound" EmptyDataText="Kayıtlı vaka bulunamadı.">
                    <HeaderStyle CssClass="bg-white border-bottom text-muted text-uppercase small" Height="50px" />
                    <RowStyle Height="60px" />
                    <Columns>
                        <asp:BoundField DataField="DosyaNo" HeaderText="DOSYA NO" ItemStyle-Font-Bold="true" ItemStyle-CssClass="text-primary" />
                        
                        <asp:BoundField DataField="OlayTarihi" HeaderText="TARİH" DataFormatString="{0:dd.MM.yyyy}" />
                        
                        <asp:BoundField DataField="SehirAdi" HeaderText="OLAY YERİ" />
                        
                        <asp:BoundField DataField="IlceAdi" HeaderText="İLÇE" />
                        
                        <asp:BoundField DataField="SucAdi" HeaderText="SUÇ TÜRÜ" />

                        <asp:TemplateField HeaderText="DURUM">
                            <ItemTemplate>
                                <asp:Label ID="lblDurum" runat="server" Text='<%# Eval("SonDurum") %>' CssClass="badge-durum"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="İŞLEMLER" ItemStyle-CssClass="text-end pe-3">
                            <ItemTemplate>
                                <a href='OlayEkle.aspx?id=<%# Eval("OlayID") %>' class="btn btn-sm btn-light border" title="Düzenle"><i class="fas fa-edit text-primary"></i></a>
                                <asp:LinkButton ID="btnSil" runat="server" CommandArgument='<%# Eval("OlayID") %>' OnClick="btnSil_Click" OnClientClick="return confirm('Dosyayı silmek istiyor musunuz?')" CssClass="btn btn-sm btn-light border ms-1" title="Sil"><i class="fas fa-trash-alt text-danger"></i></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

</asp:Content>