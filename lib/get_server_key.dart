
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
  "private_key_id": "237efc9aa98625ebbdf45d2c34536f4e2ce70edd",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDiByB4rf5VAqQQ\nhfUTOivR+wpeDqmsrFCt7hhZWKhrltYaOe8CTlbB0IUKfc+qiDNboKzWBcPirM9t\nJ//fdglRSQgB2cQDUOD57moDd9uET7mYzqdTTarU2RdevLwdr6sZsmoPpkUqMKZJ\nBp68DMIwxsT9j06DSgVRO4CDSAsPpPs41Elb8WxSPazmpH9R6Y7J8M/bsFbrWSU3\njShlW8zOKVKd6HaRXoV6/r1UQANNNjngiYvoyPCKQXdEzXRc/oGtJd1UBaGmQ2Sr\nXSp7Pt10NtMH85E5FE3O7toqdvvtms73rB3nJvc6h1P5Xl2pfSaPfT3q+1gzprjX\n0AUaKd29AgMBAAECggEALeeAosHDi4RTyb9K/LKtv6Gag2u67gS5Bfn7G/ozilZB\n+WWWswMx/37X5j+S83Fh7NP/BiB5ngm2vtaG0t1oGwgYBjgx5PKCHoBbK4UmIgMH\nEI+3z+VQMpY8dtMh6W2J9FgVzkPYfC8RNnePuWVl8v4Ld+uo6GUaG1tYSFFTXcOk\nQxcDtiHu77swg85tNOsUgvQdodsLaY49xGU3Bc11oTOaaRLryF3KGpxSCNXBoC5D\nbKMY0T5hLAnVphAgzPgROrWXbJR5Qc5xvzkk1PnRn2Dlt9AXSKlYmIkBwJivjC7G\n1OpBafHoZlY796GO46cCzQOml6zZwKHju4udvMt1yQKBgQDzViTPePz0CKXkYf1c\n4RSl4fm3iqH9+UOGAhKCrs+UaJGJrufmlId7OLIPHcRn7XYtn+QUljuOPDrHnq+t\nrg4SZYmClRiWQN1QwFm8lZdUdaMvyrbEcIOCvWpAffXo4ZaBPZ1NePQpQNLRraps\nZlPbMijzPo8RLGEspoyzyFQb5wKBgQDtymNVeXIpFvetdNz4I6klG1hxysrGQhpn\nplydk6/j8shgZ6YISeX00zKgMEFR8O2P8oJbHo9WfL6auYIVDwOMk67uftdj+x6J\nhN2TjeXhD8L4RtumG/01Wx0URt14WmgvCSoK73YxVO/5PT+Rm/v4nvIhcxQyxB1X\nnlSQlyskuwKBgCdlANyd58XSSJkqzAvnXKJmbTkrtoIZgrcFSt3hUzXhn/48VMrd\nrPlj+l+8H/n7VbCZPCGhGM80LQf4RtTFYv3TdmmvnaVlpu7V1TFUvoUr7llkZiZz\nWLcn1zXNrqwfKXCO+xJ5zH2JQxgzF24pOtY3zq1iqWLMXocOB6Vrf0JtAoGAUj9K\nlGnpPqUfDfP56ioLezY2JUXLVT/P+kHkjuxiTinPfOjc2MkWrNPQEvAd58W5paxv\nwiyTz4peMw4vHDGRPLJoMz3UKlTVfyNhsIPIG0xkV5PKrW3I6weUy0qnl9VNa9dz\nn0ysSOvkBQVWU3rscFYp0cAIIHcM3x14inp/BbkCgYBidJWlOLL8B7syYVhwy8cf\nMJxb2B5M8p61dEMBBv1u6MKG0KzN53zEfco2D7ZluSFAHzkNe8bm4wek0VtAhhxs\nt0hNuna/uGlRFdyko/2g20tGO+Vsm2zAjzZ5qdbMHIziWHLiQbSxo/kf55hQoSVa\n/8Yt4jMj0nKUA5TRapGiuQ==\n-----END PRIVATE KEY-----\n",
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