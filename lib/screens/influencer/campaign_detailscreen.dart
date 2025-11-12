
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../../utils/app_theme.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> campaign;
//   final String brandName; // Added brandName parameter

//   const CampaignDetailScreen({
//     Key? key,
//     required this.campaign,
//     required this.brandName,
//   }) : super(key: key);

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   bool _uploading = false;
//   String? _uploadedFileUrl;

//   final SupabaseClient supabase = Supabase.instance.client;

//   Future<void> _pickAndUploadFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _uploading = true;
//       });

//       final file = File(result.files.single.path!);
//       final fileName = '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

//       try {
//         final response = await supabase.storage
//             .from('campaign-reports')
//             .upload(fileName, file);

//         // response is just a String with the uploaded path if success
//         final publicUrl = supabase.storage.from('campaign-reports').getPublicUrl(fileName);
//         setState(() {
//           _uploadedFileUrl = publicUrl; // Now this is a String URL
//           _uploading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('File uploaded successfully')),
//         );
//       } catch (e) {
//         setState(() {
//           _uploading = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('File upload failed: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaign = widget.campaign;
//     final title = campaign['title'] ?? 'Untitled Campaign';
//     final description = campaign['description'] ?? 'No description';
//     final budget = campaign['budget'] ?? 'N/A';
//     final status = campaign['status'] ?? 'in_progress';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Campaign Details"),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Brand: ${widget.brandName}',
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Budget: \$$budget • Status: ${status.toString().toUpperCase()}',
//               style: const TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               description,
//               style: const TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.upload_file),
//               label: Text(_uploading ? "Uploading..." : "Upload Report"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppTheme.primaryColor,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               onPressed: _uploading ? null : _pickAndUploadFile,
//             ),
//             if (_uploadedFileUrl != null) ...[
//               const SizedBox(height: 16),
//               Text(
//                 "Uploaded File:",
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               GestureDetector(
//                 onTap: () {
//                   // Open the file in browser or preview
//                 },
//                 child: Text(
//                   _uploadedFileUrl!,
//                   style: const TextStyle(color: AppTheme.primaryColor, decoration: TextDecoration.underline),
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:open_filex/open_filex.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../utils/app_theme.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> campaign;
//   final String brandName;

//   const CampaignDetailScreen({
//     Key? key,
//     required this.campaign,
//     required this.brandName,
//   }) : super(key: key);

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> _reports = [];
//   bool _uploading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadReports();
//   }

//   Future<void> _loadReports() async {
//     try {
//       final response = await supabase
//           .from('campaign_reports')
//           .select()
//           .eq('campaign_id', widget.campaign['id'])
//           .order('uploaded_at', ascending: false);

//       setState(() {
//         _reports = List<Map<String, dynamic>>.from(response as List);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load reports: $e')));
//     }
//   }

//   Future<void> _pickAndUploadFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null && result.files.single.path != null) {
//       setState(() => _uploading = true);

//       final file = File(result.files.single.path!);
//       final originalFileName = result.files.single.name;
//       final fileName =
//           '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';

//       try {
//         // Upload to Supabase storage
//         await supabase.storage.from('campaign-reports').upload(fileName, file);

//         // Get public URL
//         final publicUrl =
//             supabase.storage.from('campaign-reports').getPublicUrl(fileName);

//         // Insert into campaign_reports table
//         final currentUserId = supabase.auth.currentUser?.id;
//         if (currentUserId == null) throw 'User not logged in';

//         await supabase.from('campaign_reports').insert({
//           'campaign_id': widget.campaign['id'],
//           'influencer_id': currentUserId,
//           'file_url': publicUrl,
//           'uploaded_at': DateTime.now().toIso8601String(),
//         });

//         // Update local state to show in app immediately
//         setState(() {
//           _reports.insert(0, {
//             'file_url': publicUrl,
//             'uploaded_at': DateTime.now().toIso8601String(),
//             'file_name': originalFileName, // store original file name
//           });
//           _uploading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('File uploaded successfully')));
//       } catch (e) {
//         setState(() => _uploading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('File upload failed: $e')));
//       }
//     }
//   }

//   Future<void> _viewReport(String fileUrl) async {
//     try {
//       if (await canLaunch(fileUrl)) {
//         await launch(fileUrl);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Could not open report')));
//       }
//     } catch (_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open report')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaign = widget.campaign;
//     final title = campaign['title'] ?? 'Untitled Campaign';
//     final description = campaign['description'] ?? 'No description';
//     final budget = campaign['budget'] ?? 'N/A';
//     final brandName = widget.brandName;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Brand: $brandName', style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 6),
//               Text('Budget: \$$budget', style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 12),
//               Text(description, style: const TextStyle(fontSize: 14)),
//               const SizedBox(height: 20),
//               const Divider(),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Reports',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   _uploading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton.icon(
//                           onPressed: _pickAndUploadFile,
//                           icon: const Icon(Icons.upload_file),
//                           label: const Text('Upload'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppTheme.primaryColor,
//                           ),
//                         ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               _reports.isEmpty
//                   ? const Text('No reports uploaded yet')
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: _reports.length,
//                       itemBuilder: (_, i) {
//                         final report = _reports[i];
//                         final fileUrl = report['file_url'] ?? '';
//                         final fileName =
//                             report['file_name'] ?? fileUrl.split('/').last;
//                         return ListTile(
//                           leading: const Icon(Icons.insert_drive_file),
//                           title: Text(fileName),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.remove_red_eye),
//                             onPressed: () => _viewReport(fileUrl),
//                           ),
//                         );
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../utils/app_theme.dart';

// class CampaignDetailScreen extends StatefulWidget {
//   final Map<String, dynamic> campaign;
//   final String brandName;

//   const CampaignDetailScreen({
//     Key? key,
//     required this.campaign,
//     required this.brandName,
//   }) : super(key: key);

//   @override
//   State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
// }

// class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
//   final supabase = Supabase.instance.client;
//   List<Map<String, dynamic>> _reports = [];
//   bool _uploading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadReports();
//   }

//   Future<void> _loadReports() async {
//     try {
//       final data = await supabase
//           .from('campaign_reports')
//           .select()
//           .eq('campaign_id', widget.campaign['id'])
//           .order('uploaded_at', ascending: false);

//       setState(() {
//         _reports = List<Map<String, dynamic>>.from(data ?? []);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to load reports: $e')));
//     }
//   }

//   Future<void> _pickAndUploadFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null && result.files.single.path != null) {
//       setState(() => _uploading = true);

//       final file = File(result.files.single.path!);
//       final fileName =
//           '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

//       try {
//         // Upload to Supabase storage
//         await supabase.storage.from('campaign-reports').upload(fileName, file);

//         // Get public URL
//         final publicUrl =
//             supabase.storage.from('campaign-reports').getPublicUrl(fileName);

//         // Insert into campaign_reports table
//         await supabase.from('campaign_reports').insert({
//           'campaign_id': widget.campaign['id'],
//           'influencer_id': supabase.auth.currentUser?.id,
//           'file_url': publicUrl,
//           'uploaded_at': DateTime.now().toIso8601String(),
//         });

//         // Update local state to show in app
//         setState(() {
//           _reports.insert(0, {
//             'file_url': publicUrl,
//             'uploaded_at': DateTime.now().toIso8601String(),
//           });
//           _uploading = false;
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('File uploaded successfully')));
//       } catch (e) {
//         setState(() => _uploading = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('File upload failed: $e')));
//       }
//     }
//   }

//   Future<void> _viewReport(String fileUrl) async {
//     try {
//       final uri = Uri.parse(fileUrl);
//       if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Could not open report')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open report')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final campaign = widget.campaign;
//     final title = campaign['title'] ?? 'Untitled Campaign';
//     final description = campaign['description'] ?? 'No description';
//     final budget = campaign['budget'] ?? 'N/A';
//     final brandName = widget.brandName;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         backgroundColor: AppTheme.primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(14.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Brand: $brandName', style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 6),
//               Text('Budget: \$$budget', style: const TextStyle(fontSize: 16)),
//               const SizedBox(height: 12),
//               Text(description, style: const TextStyle(fontSize: 14)),
//               const SizedBox(height: 20),
//               const Divider(),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Reports',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   _uploading
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton.icon(
//                           onPressed: _pickAndUploadFile,
//                           icon: const Icon(Icons.upload_file),
//                           label: const Text('Upload'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppTheme.primaryColor,
//                           ),
//                         ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               _reports.isEmpty
//                   ? const Text('No reports uploaded yet')
//                   : ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: _reports.length,
//                       itemBuilder: (_, i) {
//                         final report = _reports[i];
//                         final fileUrl = report['file_url'] ?? '';
//                         final fileName = fileUrl.split('/').last;
//                         return ListTile(
//                           leading: const Icon(Icons.insert_drive_file),
//                           title: Text(fileName),
//                           trailing: IconButton(
//                             icon: const Icon(Icons.remove_red_eye),
//                             onPressed: () => _viewReport(fileUrl),
//                           ),
//                         );
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_theme.dart';

class CampaignDetailScreen extends StatefulWidget {
  final Map<String, dynamic> campaign;
  final String brandName;

  const CampaignDetailScreen({
    Key? key,
    required this.campaign,
    required this.brandName,
  }) : super(key: key);

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _reports = [];
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  /// Load all reports for this campaign (both influencer and brand uploads)
  Future<void> _loadReports() async {
    try {
      final data = await supabase
          .from('campaign_reports')
          .select()
          .eq('campaign_id', widget.campaign['id'])
          .order('uploaded_at', ascending: false);

      setState(() {
        _reports = List<Map<String, dynamic>>.from(data ?? []);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reports: $e')));
    }
  }

  /// Influencer uploading a report
  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() => _uploading = true);

      final file = File(result.files.single.path!);
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';

      try {
        // Upload to Supabase storage
        await supabase.storage.from('campaign-reports').upload(fileName, file);

        // Get public URL
        final publicUrl =
            supabase.storage.from('campaign-reports').getPublicUrl(fileName);

        // Insert into campaign_reports table (influencer upload → uploaded_by_brand = false)
        await supabase.from('campaign_reports').insert({
          'campaign_id': widget.campaign['id'],
          'influencer_id': supabase.auth.currentUser?.id,
          'file_url': publicUrl,
          'uploaded_by_brand': false,
          'uploaded_at': DateTime.now().toIso8601String(),
        });

        // Update local state to show in app
        setState(() {
          _reports.insert(0, {
            'file_url': publicUrl,
            'uploaded_by_brand': false,
            'uploaded_at': DateTime.now().toIso8601String(),
          });
          _uploading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File uploaded successfully')));
      } catch (e) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File upload failed: $e')));
      }
    }
  }

  /// View a report in external browser
  Future<void> _viewReport(String fileUrl) async {
    try {
      final uri = Uri.parse(fileUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open report')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open report')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final campaign = widget.campaign;
    final title = campaign['title'] ?? 'Untitled Campaign';
    final description = campaign['description'] ?? 'No description';
    final budget = campaign['budget'] ?? 'N/A';
    final brandName = widget.brandName;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: $brandName', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 6),
              Text('Budget: \$$budget', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 12),
              Text(description, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Reports',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  _uploading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _pickAndUploadFile,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 12),
              _reports.isEmpty
                  ? const Text('No reports uploaded yet')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _reports.length,
                      itemBuilder: (_, i) {
                        final report = _reports[i];
                        final fileUrl = report['file_url'] ?? '';
                        final uploadedAt = report['uploaded_at'] ?? '';
                        final uploadedByBrand = report['uploaded_by_brand'] ?? false;
                        final uploadedByText =
                            uploadedByBrand ? 'Brand' : 'You';

                        final fileName = fileUrl.split('/').last;

                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.insert_drive_file),
                            title: Text(fileName),
                            subtitle: Text('Uploaded by: $uploadedByText\nUploaded at: $uploadedAt'),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_red_eye),
                              onPressed: () => _viewReport(fileUrl),
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
