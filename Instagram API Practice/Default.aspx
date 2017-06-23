<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Instagram_API_Practice._Default" ClientIDMode="Static" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%--insta feed--%>
    <script src="Scripts/instafeed.js" type="text/javascript"></script>

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

        function InstaFeed() {
            var feed = new Instafeed({
                get: 'user',
                accessToken: $('#lblAccessToken').text(),
                userId: $('#lblUserID').text(),
                clientId: '2126fd843a7c4445b36098470692719d',
                resolution: 'standard_resolution',
                template: '<div class="eachImage"><a href="{{link}}"><img class="instagram" src="{{image}}" /></a></div>'
            });
            feed.run();
        }
    </script>

    <style type="text/css">
        img.instagram {
            width: 200px;
            height: 200px;
        }

        div#instafeed {
            width: 1000px;
        }

        .eachImage {
            display: inline-block;
            margin: 5px;
        }
    </style>

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
            <div>
                <h2>API Response</h2>
                <table id="returnData">
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
        <div class="row">
            <div class="col-md-4">
                <h2>Using instafeed.js</h2>
                <button id="btnInstaFeed" type="button" onclick="InstaFeed()">Fetch my post (last 20)</button>
                <div>
                    <div id="instafeed"></div>
                </div>
            </div>
        </div>
    </asp:Panel>

</asp:Content>
