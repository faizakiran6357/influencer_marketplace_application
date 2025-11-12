
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey{
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(ServiceAccountCredentials.fromJson(
{
  "type": "service_account",
  "project_id": "influencer-marketing-app-b76fc",
  "private_key_id": "02e6d97495dffcd1fb5968920a136f6f8dc50346",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDMpeO3L22/GhwM\naeQYW7FlIzMzGSIGXB2Gt7/2TNFAF8VDLe0yQXORnHuHH6fj4QDnqda8EunM3zTJ\nqN3cmAbeAOt3Lv5xXC7qLG3qGgeWOtWkoKnPcM+H/NvGxhgChab9zwIOdaDQ/rvT\nxmbgJAM77xDmKEKJ8u0WUS732A3MJBu/xCggxPOe1HVLpZp9rM253lhlXH2RwkZ0\n7PAcwQcfb5nbnfyupPK8WkKirbk7ISQQB536HhOH8g2Qgeo2M25kgWXsAkylg9PR\nkJ/CKYfzjC0i82KMcGR3I2L5kQyO4zQGrL1SwUtiJDM8JJlDxbGWj8ypZXT/36LD\nkrN+0JkTAgMBAAECggEAX6cKEI0ylqf1hDfaTShOeh9BxxhwNtjHVDh+mPi+tV5m\n7UeCHoNJKT4i3r2FE5YPfjh8DdwpO4D4g2lSidDlJM75P/PPKd0UcI/jsBAKi8Vk\nJlaSCEuKNN2TPA1LG6KssuUW6PtB922ZDRsm6ozqlhDfrTQUJbZN6qh3c5CgolFI\nExajq7F6If6cSP6KibBuf/8oIhdJ97e8HuPTcIR4s4qrxfpTZEFXOzkb2y15xs3r\nswg1Ri6AWWngsVur9frWiaAQRjehf1ETDfwK6JIqjcWN8v6IDggZU1UU66nPS99P\nb2jslTut76UlrtAa7LBBPlGEReekb/hT41bUR5C5AQKBgQDv3hiPMNu35geblKzB\nDWDdbd6eeNAZFACFf2oJjusPTYpMAY0u9C5owAwGg/34FPp5HbmU1m3+71KH51u7\nNKT6CJxN+m6k6j26elz8UTgS44Sk+KuX2yuoOy9EMvuo3ljfun1VQYcnUs5s/HUq\nTd6XdOQXYGTV6+ZjxZot1mkkIwKBgQDaaWc2PCc6n4WG8pYA4hCACdQzU/ucU3z9\nz7yliBY1ZWxuI48FO4bSwYjPcIKEVtOKx53coBRQKuPmgt6q8oX+HcuazKv+dJVO\nXfZBUli6IK0byJAsd8ToZhZqljBXinFdERRcyJ3vA3mzGB+sfzPwfaUAK9HNFGbc\nerSY7SjOUQKBgGwR3XDOK4AcVHslLfxAoc7BzJYLin5yA5YiBM1PpdocLl32KPzp\nqOsq84AQAeG+2eatnMpRHffJLZ7rfunGWzoHnRyI40bL/onAzZokoaXo+f81xmHB\nrla6a55HdhjsLJCIPiWmQ1VVOonh6Ivpz4rfcFCT7npvMTrscX2LZ42PAoGAYJY4\nNH3Jg11EOXdR6rYOQfEWzFQZcvpgzgVuEW3rFFXz64kCGHhImS9JByNkNI4JItg/\n8W9BTGqLOkcpnUN/Ce+3OI/Gh9KarHtVCXIXFsiYhS7ewyt8AqISy7P7UNtCYrvI\n23dEkIxi51aFu0zNdU67ByZZs22QR3RkJTTL1OECgYEAvupmQJOH07mzOuzgsMQJ\n2D70yjikvSU2IK25kCslswsSALCymblDDJZOnzThpW6g2FVcINjGuoHgnlr6D120\nhox8NcGZHvDFS/o2Y1XXJ2XtVx6CjU9jwMweu37mEuauNm4ByCUm6Jwiplap4YLS\n1oQgGko+KLpecAtWaSfex2M=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-fbsvc@influencer-marketing-app-b76fc.iam.gserviceaccount.com",
  "client_id": "100694854657684671838",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40influencer-marketing-app-b76fc.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
), 
scopes);

final accessToken = client.credentials.accessToken.data;
    print("Access Token: $accessToken"); // <--- see in console
    return accessToken;
  }
}