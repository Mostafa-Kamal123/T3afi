import 'package:flutter/material.dart';
import 'package:t3afy/services/patients_management.dart';
import 'package:t3afy/widgets/customCardWidget.dart';

import 'patient_logic.dart';

class PatientCard extends StatelessWidget {
  final Map<String, dynamic> patient;
  final VoidCallback? onPatientDeleted;
  final VoidCallback? onPatientEdited;   // ← جديد // ← بدون late، ومش required (اختياري)

  const PatientCard({
    super.key,
    required this.patient,
    this.onPatientDeleted,
    this.onPatientEdited, // ← هنا بدون late و بدون فاصلة زيادة
  });

  @override
  Widget build(BuildContext context) {
    return Customcardwidget(
      ontap: () {
        // ممكن هنا نضيف تفاصيل المريض أو نافذة جديدة
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patient['name']?.toString() ?? 'No name',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              "ID: ${patient['customId']?.toString() ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),

            Text(
              "Email: ${patient['email']?.toString() ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),

            Text(
              "Phone: ${patient['phone']?.toString() ?? 'N/A'}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),

            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor(patient['riskLevel']?.toString() ?? ''),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  patient['riskLevel']?.toString() ?? 'Unknown',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: statusColor(patient['riskLevel']?.toString() ?? ''),
                  ),
                ),
                const Spacer(),
                IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: onPatientEdited != null
          ? () {
              final patientId = patient['docId']?.toString() ?? '';
              if (patientId.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("معرف المريض غير موجود")),
                );
                return;
              }

              PatientsManagement.editPatientDialog(
                context: context,
                patient: patient,           // بنمرر كل البيانات
                patientId: patientId,
                onPatientEdited: onPatientEdited!,
              );
            }
          : null,
    ),
      const Spacer(), // ← عشان تدفع الأيقونة لليمين
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onPatientDeleted != null
                      ? () {
                        PatientsManagement.deletePatient(
                      context: context,
                     patientId: patient['docId'] ?? '',
                      onPatientDeleted: onPatientDeleted ?? () {},
                          );
                        }
                      : null, // لو مفيش callback، الأيقونة معطلة
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}