<%@ Page Title="İhbar Hattı" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Ihbarlar.aspx.cs" Inherits="EmniyetOtomasyonu.Ihbarlar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Kart Efektleri */
        .ihbar-card { border-left: 5px solid transparent; transition: all 0.2s; }
        .ihbar-card:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        
        /* Öncelik Renkleri */
        .badge-Acil { background-color: #dc3545; color: white; animation: blink 2s infinite; } /* Kırmızı & Yanıp Sönen */
        .badge-Normal { background-color: #ffc107; color: #333; } /* Sarı */
        .badge-Bilgi { background-color: #17a2b8; color: white; } /* Mavi */

        @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0.6; } 100% { opacity: 1; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4">

        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm bg-danger text-white">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-0 opacity-75">ACİL MÜDAHALE</h6>
                            <h2 class="fw-bold mb-0"><asp:Label ID="lblAcilSayi" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <i class="fas fa-exclamation-triangle fa-2x opacity-50"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm bg-white">
                    <div class="card-body d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="mb-0 text-muted">BUGÜN GELEN</h6>
                            <h2 class="fw-bold mb-0 text-dark"><asp:Label ID="lblBugunSayi" runat="server" Text="0"></asp:Label></h2>
                        </div>
                        <i class="fas fa-calendar-check fa-2x text-muted opacity-25"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex align-items-center gap-2">
                        <i class="fas fa-filter text-primary"></i>
                        <asp:DropDownList ID="ddlFiltre" runat="server" CssClass="form-select border-0 bg-light fw-bold text-secondary" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltre_SelectedIndexChanged">
                            <asp:ListItem Value="Tumu">Tüm İhbarlar</asp:ListItem>
                            <asp:ListItem Value="Yeni">🔴 Bekleyen / Yeni İhbarlar</asp:ListItem>
                            <asp:ListItem Value="Acil">🚨 Sadece Acil Olanlar</asp:ListItem>
                            <asp:ListItem Value="Sonuc">✅ Sonuçlananlar</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btnYenile" runat="server" Text="Yenile" CssClass="btn btn-primary" OnClick="btnYenile_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 border-bottom d-flex justify-content-between align-items-center">
                <h6 class="fw-bold text-dark mb-0"><i class="fas fa-list-ul me-2 text-primary"></i>112 İHBAR AKIŞ EKRANI</h6>
                <span class="badge bg-light text-dark border">Canlı Veri</span>
            </div>
            <div class="card-body p-0">
                <asp:GridView ID="gridIhbarlar" runat="server" CssClass="table table-hover align-middle mb-0" AutoGenerateColumns="false" GridLines="None" OnRowCommand="gridIhbarlar_RowCommand">
                    <HeaderStyle CssClass="bg-light text-muted small fw-bold text-uppercase" />
                    <Columns>
                        
                        <asp:TemplateField HeaderText="ÖNCELİK">
                            <ItemTemplate>
                                <span class='badge rounded-pill badge-<%# Eval("Oncelik") %>'>
                                    <%# Eval("Oncelik") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="IhbarTarihi" HeaderText="ZAMAN" DataFormatString="{0:dd.MM.yyyy HH:mm}" />
                        
                        <asp:TemplateField HeaderText="İHBARCI">
                            <ItemTemplate>
                                <div><%# Eval("IhbarciAd") %> <%# Eval("IhbarciSoyad") %></div>
                                <small class="text-muted"><i class="fas fa-phone-alt me-1"></i><%# Eval("IhbarciTelefon") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="OLAY / İÇERİK">
                            <ItemTemplate>
                                <strong class="text-dark d-block"><%# Eval("IhbarTuru") %></strong>
                                <div class="text-muted small text-truncate" style="max-width: 350px;">
                                    <%# Eval("IhbarDetayi") %>
                                </div>
                                <small class="text-primary"><i class="fas fa-map-pin me-1"></i><%# Eval("Konum") %></small>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="DURUM">
                            <ItemTemplate>
                                <span class='badge <%# Eval("Durum").ToString() == "Yeni" ? "bg-primary" : (Eval("Durum").ToString() == "Asılsız" ? "bg-secondary" : "bg-success") %>'>
                                    <%# Eval("Durum") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="OPERASYON">
                            <ItemTemplate>
                                <a href='OlayEkle.aspx?IhbarID=<%# Eval("IhbarID") %>&Tur=<%# Eval("IhbarTuru") %>&Konum=<%# Eval("Konum") %>' 
                                   class="btn btn-sm btn-danger shadow-sm <%# Eval("Durum").ToString() != "Yeni" ? "disabled" : "" %>" 
                                   title="Vakaya Dönüştür">
                                    <i class="fas fa-file-export"></i> Vaka Aç
                                </a>

                                <asp:LinkButton ID="btnAsilsiz" runat="server" CommandName="Asilsiz" CommandArgument='<%# Eval("IhbarID") %>' 
                                    CssClass="btn btn-sm btn-light border ms-1" title="Asılsız/İptal Et"
                                    Visible='<%# Eval("Durum").ToString() == "Yeni" %>'>
                                    <i class="fas fa-times text-muted"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-5">
                            <i class="fas fa-check-circle fa-3x text-success mb-3"></i>
                            <p class="h5 text-muted">Şu an bekleyen ihbar bulunmamaktadır.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>