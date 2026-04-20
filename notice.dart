import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'admin_dashboard.dart'; // এডমিন পেজ ইমপোর্ট

class NoticePage extends StatelessWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    // এখানে তোমার নিজের জিমেইল আইডি
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    const adminEmail = "shajib3444@gmail.com";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),

      // শুধুমাত্র এডমিন এই বাটনটি দেখতে পাবে
      floatingActionButton: currentUserEmail == adminEmail
          ? FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboard()));
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.security, color: Colors.white),
        label: const Text("Admin Panel", style: TextStyle(color: Colors.white)),
      )
          : null,

      body: Column(
        children: [
          // হেডার অংশ (আগের মতোই আছে)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('notices').snapshots(),
            builder: (context, snapshot) {
              int count = 0;
              if (snapshot.hasData) {
                count = snapshot.data!.docs.length;
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(25, 60, 25, 30),
                decoration: const BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "College Notices",
                          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "$count notices available",
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.notifications_active_outlined, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              );
            },
          ),

          // নোটিশ লিস্ট
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notices')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("কোনো নোটিশ পাওয়া যায়নি।"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var notice = snapshot.data!.docs[index];
                    String docId = notice.id; // ডকুমেন্টের ID

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4, height: 20,
                                    decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    notice['title'] ?? '',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              // --- ডিলিট বাটন (শুধুমাত্র এডমিনের জন্য) ---
                              if (currentUserEmail == adminEmail)
                                IconButton(
                                  icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                                  onPressed: () => _showDeleteDialog(context, docId),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(notice['body'] ?? '', style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 12),
                          Text(notice['date'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ডিলিট কনফার্মেশন ডায়ালগ
  void _showDeleteDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Notice?"),
        content: const Text("আপনি কি নিশ্চিত যে এই নোটিশটি মুছে ফেলতে চান?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('notices').doc(docId).delete();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Notice deleted!")),
                );
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
