<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PersonelListesi.aspx.cs" Inherits="EmniyetOtomasyonu.PersonelListesi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">

        <div class="d-flex justify-content-between align-items-center mb-4 mt-2">
            <div>
                <h2 class="h3 mb-0 text-gray-800 fw-bold">
                    <i class="fas fa-user-shield text-primary me-2"></i>Personel Yönetimi
                </h2>
                <span class="text-muted small">Aktif personel listesi ve arama işlemleri</span>
            </div>
            
            <a href="PersonelEkle.aspx" class="btn btn-primary shadow-sm">
                <i class="fas fa-plus fa-sm text-white-50 me-1"></i> Yeni Personel Ekle
            </a>
        </div>

        <div class="card shadow mb-4 border-0 border-start border-primary border-4">
            <div class="card-body bg-white rounded">
                <h6 class="text-primary fw-bold mb-3"><i class="fas fa-filter me-1"></i> Detaylı Sorgulama</h6>
                
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted">T.C. Kimlik No</label>
                        <asp:TextBox ID="txtAraTC" runat="server" CssClass="form-control" placeholder="11 haneli no..."></asp:TextBox>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted">Ad veya Soyad</label>
                        <asp:TextBox ID="txtAraAd" runat="server" CssClass="form-control" placeholder="Personel adı..."></asp:TextBox>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small fw-bold text-muted">Görev Yeri / Birim</label>
                        <asp:DropDownList ID="ddlAraBirim" runat="server" CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-3 d-flex align-items-end">
                        <asp:LinkButton ID="btnAra" runat="server" CssClass="btn btn-primary w-100 fw-bold" OnClick="btnAra_Click">
                            <i class="fas fa-search me-1"></i> SORGULA
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>

        <div class="card shadow mb-4 border-0">
            <div class="card-header py-3 bg-white d-flex align-items-center justify-content-between">
                <h6 class="m-0 fw-bold text-dark">Personel Listesi</h6>
                <span class="badge bg-light text-dark border">EGM Veritabanı</span>
            </div>
            
            <div class="card-body p-0">
                <div class="table-responsive">
                    
                    <asp:GridView ID="gridPersonel" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover table-striped align-middle mb-0" GridLines="None" Width="100%"
                        DataKeyNames="PersonelID" OnRowCommand="gridPersonel_RowCommand">
                        
                        <Columns>
                            <asp:TemplateField HeaderText="" ItemStyle-Width="50px" ItemStyle-CssClass="text-center">
                                <ItemTemplate>
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 40px; height: 40px;">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="TCKimlikNo" HeaderText="T.C. KİMLİK" ItemStyle-Font-Bold="true" />
                            <asp:BoundField DataField="Ad" HeaderText="ADI" />
                            <asp:BoundField DataField="Soyad" HeaderText="SOYADI" />
                            
                            <asp:TemplateField HeaderText="RÜTBE">
                                <ItemTemplate>
                                    <span class="badge bg-secondary"><%# Eval("Rutbe") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="BirimAdi" HeaderText="GÖREV YERİ" ItemStyle-CssClass="text-primary fw-medium"/>

                            <asp:TemplateField HeaderText="İŞLEMLER" ItemStyle-Width="140px" ItemStyle-CssClass="text-end pe-4">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="Duzenle" CommandArgument='<%# Eval("PersonelID") %>' 
                                        CssClass="btn btn-sm btn-info text-white me-1" ToolTip="Düzenle">
                                        <i class="fas fa-pen"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="Sil" CommandArgument='<%# Eval("PersonelID") %>' 
                                        CssClass="btn btn-sm btn-danger" ToolTip="Sil"
                                        OnClientClick="return confirm('UYARI: Bu personel kaydı kalıcı olarak silinecek. Devam edilsin mi?');">
                                        <i class="fas fa-trash"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="text-center py-5">
                                <i class="fas fa-folder-open fa-3x text-muted mb-3"></i>
                                <h6 class="text-muted">Kriterlere uygun kayıt bulunamadı.</h6>
                            </div>
                        </EmptyDataTemplate>

                    </asp:GridView>
                </div>
            </div>
        </div>

    </div>

</asp:Content>