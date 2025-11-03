
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class YouTubeService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );

  Future<Map<String, dynamic>?> connectYouTube() async {
    try {
      print("🎬 Starting YouTube connection...");

      // Step 1: Trigger Google OAuth Sign-In
      final account = await _googleSignIn.signIn();
      if (account == null) {
        print("🚫 User cancelled YouTube login.");
        return null;
      }

      // Step 2: Get authentication headers and access token
      final authHeaders = await account.authHeaders;
      final auth = await account.authentication;
      final accessToken = auth.accessToken;
      final refreshToken = auth.idToken; // pseudo refresh token

      if (accessToken == null) {
        print("❌ No access token received from Google.");
        return null;
      }

      // Step 3: Create authenticated client
      final client = _AuthClient(authHeaders);

      // Step 4: Fetch YouTube channel info
      final yt.YouTubeApi youtubeApi = yt.YouTubeApi(client);
      final channels = await youtubeApi.channels.list(
        ['snippet', 'statistics'],
        mine: true,
      );

      if (channels.items == null || channels.items!.isEmpty) {
        print("⚠️ No YouTube channels found for this user.");
        return null;
      }

      final channel = channels.items!.first;

      // 🧩 Debug Prints
      print("🎥 Channel Info Fetched:");
      print("➡️ Title: ${channel.snippet?.title}");
      print("➡️ Thumbnail: ${channel.snippet?.thumbnails?.default_?.url}");
      print("➡️ Subscribers: ${channel.statistics?.subscriberCount}");

      // Step 5: Return structured data with safe defaults
      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'channelId': channel.id ?? '',
        'title': channel.snippet?.title ?? '',
        'description': channel.snippet?.description ?? '',
        'thumbnail': channel.snippet?.thumbnails?.default_?.url ?? '',
        'subscriberCount': channel.statistics?.subscriberCount ?? '0',
      };
    } catch (e) {
      print("❌ YouTube connect error: $e");
      return null;
    }
  }

  /// ✅ Refresh the user's YouTube access token if expired
  Future<String?> refreshToken(String oldToken) async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account == null) return null;

      final auth = await account.authentication;
      final newAccessToken = auth.accessToken;

      print("🔄 YouTube access token refreshed successfully.");
      return newAccessToken;
    } catch (e) {
      print("❌ YouTube token refresh failed: $e");
      return null;
    }
  }
}

// ✅ Authenticated client helper
class _AuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = IOClient();

  _AuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
