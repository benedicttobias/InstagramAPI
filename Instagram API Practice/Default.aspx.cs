using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using Newtonsoft.Json;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Instagram_API_Practice
{
    public partial class _Default : Page
    {
		// Global variable
		public string myClientID = "2126fd843a7c4445b36098470692719d";
		public string myClientSecret = "4920771ea8074e07bc5a08352d99194d";
		public string instagramCode;

        protected void Page_Load(object sender, EventArgs e)
        {

			if (!IsPostBack)
			{
				// This part assumed that user already auth the app
				if (!string.IsNullOrEmpty(Request.QueryString["code"]))
				{
					lblMessage.Text = "Authentication Successful";

					// Save instagram code
					instagramCode = Request.QueryString["code"];

					// Post
					exchangeCode();

				}
				else if (!string.IsNullOrEmpty(Request.QueryString["error"]))
				{
					lblMessage.Text = Request.QueryString["error"].ToString() + " because " +
						Request.QueryString["error_reason"].ToString() + ": " +
						Request.QueryString["error_description"].ToString();
				}
			}
            
        }

		private void exchangeCode()
		{
			// Parameter
			string postData = "client_id=" + myClientID +
			                  "&client_secret=" + myClientSecret +
			                  "&grant_type=" + "authorization_code" +
			                  "&redirect_uri=" + GetMyAddress() +
			                  "&code=" + instagramCode;
			byte[] byteArray = Encoding.ASCII.GetBytes(postData);

			WebRequest request = WebRequest.Create("https://api.instagram.com/oauth/access_token");
			request.Method = "POST";

			request.ContentLength = postData.Length;
			request.ContentType = "application/x-www-form-urlencoded";

			Stream stream = request.GetRequestStream();
			stream.Write(byteArray, 0, byteArray.Length);
			stream.Close();

			// Actual POSTing
			HttpWebResponse response = (HttpWebResponse) request.GetResponse();

			// Read data
			stream = response.GetResponseStream();
			// Open the stream using a StreamReader for easy access.
			StreamReader reader = new StreamReader(stream);

			// Store data
			if (response.StatusCode == HttpStatusCode.OK)
			{
				lblMessage.Text = "Succes exchange data";

				// Read the content
				string responseFromInstagram = reader.ReadToEnd();
				dynamic instagramAccessToken = JsonConvert.DeserializeObject(responseFromInstagram);

				// Example of Structure of JSON
				//{
				//	"access_token": "fb2e77d.47a0479900504cb3ab4a1f626d174d2d",
				//	"user": {
				//		"id": "1574083",
				//		"username": "snoopdogg",
				//		"full_name": "Snoop Dogg",
				//		"profile_picture": "..."
				//	}
				//}

				lblAccessToken.Text = instagramAccessToken["access_token"];
				lblUserID.Text = instagramAccessToken["user"]["id"];
				lblFullname.Text = instagramAccessToken["user"]["full_name"];
				imgProfilePicture.ImageUrl = instagramAccessToken["user"]["profile_picture"];

				// hide panel
				authBegin.Visible = false;
				authSuccess.Visible = true;
			}
			else
			{
				authBegin.Visible = true;
				authSuccess.Visible = false;
			}

			// Clean up the streams.
			reader.Close();
			response.Close();
		}

        protected void btnLoginInstagram_Click(object sender, EventArgs e)
        {
            // Return current localhost + its port
			string myURI = GetMyAddress(); 
            string redirectInstagram = "https://api.instagram.com/oauth/authorize/?client_id=" + myClientID + "&redirect_uri=" + myURI + "&response_type=code";

            // Ask the user to auth this apps
            Response.Redirect(redirectInstagram);

        }

		private string GetMyAddress()
		{
			return Request.Url.GetLeftPart(UriPartial.Authority) + Request.Path;
		}
    }
}