
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
  "private_key_id": "f526c07f0d4be3081dbc88819986cad5bea701de",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCregDH912Ure4P\nuLl3vVgMobSEaVG8Df3TbOYyZrRBa4pceFe72QNwuS5HfENrcopIUrdaRNb9JrZv\n8WklFz6QYpElXGQ/y970kkTrMjbeFkpirRYKpkb8y1ol62u0cA4hfnNtHQgS/Z32\nCf2SoCu6ydVYQ3139WczTFejHWHQ7HRdYaDPgd2fiDhXbLTAWXSEsNFAsJ6uk2dS\npWw7NvBjAgtyxJ5hQdEH1cqvYjZSgSdsUWg28JQ3CaPkvAaiKYw6gW0Te4DZiCVQ\nKmcifIAE1IvGl9Ctf5K0tkl/J7R02L6wv90Bc6mBnkfCcF9DcFXmbEUYQJq3noM7\nSuWmqn8RAgMBAAECggEAAbdqfSCblFixx6DMuPn5YO4oXnQHhPFoKVA8z+ki/D2+\nBwx57C6ZKWfDeAStOqzXvTnNkxg52sioW6T2otVEK4nJYYlhVBmSUKpgk/Dhohib\npngXHqn2T2hJnZ7DxMzYxF1bB7mk8Pvj+NXLOYceoZuXe08jeR0zkFy0VXTOkSAn\nl0wdg/uespOuXkj51GXLbhC0uPW5d0N1P5p1np1/A9A8Ovd8pg9QjkwE10u6tYph\ntZwTwX6LRVmm5ruVRsHkJJXk0af1NljRSmzRU+NeleY9EB1byqu6a3/bpcVBAQoY\n2t3ZXviZg/CQe4KiWUZjywvtNyPXDOfFASoVWyPfIQKBgQDoi0x6KMkU/VnC6bIL\ngyEKO322MpXlV2tysNxrM1WKW0nu1r1L/knzLsDZmZT8o4j0wT7BtIVu6wJnmyh5\nFO4A3hcoX5TLwVuMSme44c5AZv4mAbmCx+Mr35JmqhJMTdu6FTDP3lhOTGSCiS6b\nNTCyTGJA4FiS/URkVPRAeLutoQKBgQC8xdTu8J4pSyJPS/QgblliRIdjmyD0vdt5\nQymOZUFN2Faoo9iUPotvRXa9C5h+TK9nS8TX9av9yWNBog8wDlFMTIXycSUXEecR\nCa9+Q2Z/LzXheQgQJceulkT9gUNQgpaXRpRVGW103dTaTsN3luhB7jHQvzKQMmsh\nhNoYtNb7cQKBgQDeBDCN6OaiXYgXaVsNVrJyvH23N/CYt6/kHiszRh2DLMkXeHne\nVfdwb9C7b8AovFGDrAQomBtU3Ja9KAuqHmtk9KUTbL35ErA+7sK8ZwmtvyciTj85\nN3ISby+tSO6TXzpLHPQvYc7ZYmILpsGSeWP2tqqP2iF2pMtpJxrTevFkQQKBgQCD\nCzaZNJInClBkCc8MIG6OaBIwlEUZgR71nCkh/6qI1rC52xwDNTPoZ6lY7M7MhoGR\nTKj2XkYqJH5x1oWCj73iIJEvz1m3HSdxzW51UWa6zdQylKmDRCbNTOXRscVAA5d0\npntcZA12/nO/pMPOpgTPmAIe7ku0jDuQhkA8vHUtEQKBgAMkWTz+qrdpdfyM4dJW\n2y39kMsR3NXL3vE75ijEZYZHBJ5IMKW2biFuHXdEXp7mctbcLJyDe7d5j909VJyy\ng9Rw+GPUoXJ4p2Luub1bwJrlV4QL+zemtZCmC8P2LPiBylhiPwDCGboShN9JKK3c\n6YQzzj+A1XSzwOYY0fWURzWn\n-----END PRIVATE KEY-----\n",
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