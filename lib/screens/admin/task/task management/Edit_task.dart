import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/task_a_controller/task_add_controller.dart';
import '../../../../models/get_task_model.dart';
import '../../../../models/task_model/addTask_model.dart';

class EditingTask extends StatefulWidget {
  final String salesmanId;
  final Get_Task_Model existingTask;

  const EditingTask({
    super.key,
    required this.salesmanId,
    required this.existingTask,
  });

  @override
  State<EditingTask> createState() => _EditingTaskState();
}

class _EditingTaskState extends State<EditingTask> {
  final TaskAddController controller = Get.put(TaskAddController());
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.selectedSalesmanId.value = widget.salesmanId;
    controller.isEditing.value = true;
    controller.editingTaskId.value = widget.existingTask.sId ?? '';
    controller.taskEdit.text = widget.existingTask.taskDescription ?? '';
    controller.selectedDateTime.value =
        DateTime.tryParse(widget.existingTask.deadline ?? '');
    controller.taskStatus.value = widget.existingTask.status ?? 'Pending';
    controller.address.value = widget.existingTask.address ?? '';

    // Prefill deadline controller
    if (controller.selectedDateTime.value != null) {
      deadlineController.text = DateFormat('dd-MM-yyyy – kk:mm')
          .format(controller.selectedDateTime.value!);
    }

    // Fetch geofences and set the matching one
    controller.fetchGeofences().then((_) {
      controller.selectedGeofence.value = controller.geofences.firstWhereOrNull(
        (geo) =>
            geo.companyId.id == widget.existingTask.companyId?.sId &&
            geo.branchId.id == widget.existingTask.branchId?.sId &&
            geo.supervisorId.id == widget.existingTask.supervisorId?.sId,
      );
    });

    // Keep deadline text updated
    ever(controller.selectedDateTime, (dateTime) {
      if (dateTime != null && dateTime is DateTime) {
        deadlineController.text =
            DateFormat('dd-MM-yyyy – kk:mm').format(dateTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller.taskEdit,
                    decoration:
                        const InputDecoration(labelText: 'Task Description'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: deadlineController,
                    readOnly: true,
                    onTap: () => controller.selectDateTime(context),
                    decoration: const InputDecoration(
                      labelText: 'Deadline',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: TextEditingController(
                      text: controller.address.value,
                    ),
                    onChanged: (val) => controller.address.value = val,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Geofence>(
                    value: controller.selectedGeofence.value,
                    hint: const Text('Select Geofence'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (Geofence? value) =>
                        controller.selectedGeofence.value = value,
                    items: controller.geofences.map((geo) {
                      return DropdownMenuItem<Geofence>(
                        value: geo,
                        child: Text(geo.shopName),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: controller.updateTaskApi,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'UPDATE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
