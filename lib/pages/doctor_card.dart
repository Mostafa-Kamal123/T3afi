import 'package:flutter/material.dart';
import 'package:t3afy/pages/doctors_service.dart';
import 'package:t3afy/widgets/customCardWidget.dart';

class DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final VoidCallback? onDoctorDeleted;
  final VoidCallback? onDoctorEdited;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.onDoctorDeleted,
    this.onDoctorEdited,
  });

  @override
  Widget build(BuildContext context) {
    // استخراج الـ ID بطريقة آمنة جدًا
    final String docId = (doctor['docId'] ?? doctor['uid'] ?? '').toString().trim();

    return Customcardwidget(
      ontap: () {
        // اختياري: افتح صفحة تفاصيل الدكتور لو عايزة
        // Navigator.push(...);
      },
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctor['name']?.toString() ?? 'Unknown Doctor',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),

            Text(
              "Specialization: ${doctor['specialization']?.toString() ?? 'N/A'}",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),

            Text(
              "Email: ${doctor['email']?.toString() ?? 'N/A'}",
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              "Phone: ${doctor['phone']?.toString() ?? 'N/A'}",
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _getStatusColor(doctor['status'] ?? 'active'),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  (doctor['status'] ?? 'Active').toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(doctor['status'] ?? 'active'),
                  ),
                ),
                const Spacer(),

                // Edit Button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 22),
                  tooltip: "Edit Doctor",
                  onPressed: docId.isNotEmpty && onDoctorEdited != null
                      ? () {
                          DoctorsService.showEditDoctorDialog(
                            context: context,
                            doctor: doctor,
                            doctorId: docId,
                            onDoctorEdited: onDoctorEdited!,
                          );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cannot edit: Doctor ID missing"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                ),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 22),
                  tooltip: "Delete Doctor",
                  onPressed: docId.isNotEmpty && onDoctorDeleted != null
                      ? () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirm Deletion"),
                              content: const Text(
                                "Are you sure you want to delete this doctor?\nThis action cannot be undone.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            try {
                              await DoctorsService.deleteDoctor(
                                context: context,
                                doctorId: docId,
                                onDoctorDeleted: onDoctorDeleted!,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Delete failed: $e")),
                              );
                            }
                          }
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cannot delete: Doctor ID missing"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
      case 'pending':
        return Colors.orange;
      case 'suspended':
      case 'banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}