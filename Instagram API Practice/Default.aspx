<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Instagram_API_Practice._Default" ClientIDMode="Static" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <script type="text/javascript">
        function GetSelf() {
            var AccessToken = $('#lblAccessToken').text();
            var URL = 'https://api.instagram.com/v1/users/self/?access_token=' + AccessToken;

            $.ajax({

                url: URL,
                data: {},
                type: 'GET',
                crossDomain: true,
                dataType: 'jsonp',
                success: GetSelfSuccess,
                error: function () { alert('Failed!'); }
            });
        }

        function GetSelfSuccess(data) {
            $('pre#GetSelfReturn').text(JSON.stringify(data, undefined, 4));
        }
    </script>

    <div class="jumbotron">
        <h1>Instagram API Practice</h1>
        <p class="lead">Testing Instagram API...</p>
    </div>

    <asp:Panel ID="authBegin" runat="server">
        <div class="row">
            <div class="col-md-4">
                <h2>Login to Instagram</h2>
                <asp:Button ID="btnLoginInstagram" runat="server" OnClick="btnLoginInstagram_Click" Text="Authenticate Me" />
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>
        </div>
    </asp:Panel>


    <asp:Panel ID="authSuccess" runat="server" Visible="false">
        <div class="row">
            <div class="col-md-4">
                <h2>API Response</h2>
                <table>
                    <tr>
                        <td>Access Token</td>
                        <td>
                            <asp:Label ID="lblAccessToken" runat="server" Text="Unknown"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>User ID
                        </td>
                        <td>
                            <asp:Label ID="lblUserID" runat="server" Text="Unknown"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Full name</td>
                        <td>
                            <asp:Label ID="lblFullname" runat="server" Text="Unknown"></asp:Label></td>
                    </tr>
                    <tr>
                        <td>Profile picture</td>
                        <td>
                            <asp:Image ID="imgProfilePicture" runat="server" /></td>
                    </tr>
                </table>
            </div>
        </div>

        <div class="ApiExample">
            <button id="btnGetSelf" class="button" type="button" onclick="GetSelf()">Get Self</button>
            <pre id="GetSelfReturn" class="return"></pre>
        </div>  
    </asp:Panel>

</asp:Content>
