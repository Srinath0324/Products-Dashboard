import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assets_dashboard/core/constants/app_colors.dart';
import 'package:assets_dashboard/core/constants/app_sizes.dart';
import 'package:assets_dashboard/core/utils/date_formatter.dart';
import 'package:assets_dashboard/core/utils/responsive_helper.dart';
import 'package:assets_dashboard/data/models/employee_model.dart';
import 'package:assets_dashboard/providers/employee_provider.dart';
import 'package:assets_dashboard/screens/employees/add_employee_screen.dart';

/// Employees Screen - Employee Data Table
class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  @override
  void initState() {
    super.initState();
    // Load employees on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeeProvider>().streamEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<EmployeeProvider>(
        builder: (context, employeeProvider, child) {
          // Show loading indicator
          if (employeeProvider.isLoading && employeeProvider.employees.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error message
          if (employeeProvider.error != null && employeeProvider.employees.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading employees',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    employeeProvider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      employeeProvider.loadEmployees();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveHelper.getPadding(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                _buildHeader(),

                SizedBox(height: ResponsiveHelper.getSpacing(context)),

                // Data Table
                _buildDataTable(employeeProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = ResponsiveHelper.isMobile(context);
    final titleFontSize = ResponsiveHelper.getTitleFontSize(context);

    if (isMobile) {
      // Stack layout for mobile
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Employee List',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEmployeeScreen(),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing24,
                vertical: AppSizes.spacing12,
              ),
            ),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Employee'),
          ),
        ],
      );
    }

    // Desktop/Tablet layout
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Employee List',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
        ),
        OutlinedButton.icon(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddEmployeeScreen(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing24,
              vertical: AppSizes.spacing12,
            ),
          ),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Employee'),
        ),
      ],
    );
  }


  Widget _buildDataTable(EmployeeProvider employeeProvider) {
    final employees = employeeProvider.employees;

    if (employees.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: AppColors.border,
            width: AppSizes.borderThin,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.people_outline,
                size: 64,
                color: AppColors.gray400,
              ),
              const SizedBox(height: 16),
              Text(
                'No employees found',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first employee to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.gray600,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.border,
          width: AppSizes.borderThin,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.gray100),
          dataRowColor: WidgetStateProperty.all(AppColors.background),
          border: TableBorder.all(
            color: AppColors.border,
            width: AppSizes.borderThin,
          ),
          headingTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          dataTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue,
              ),
          columns: const [
            DataColumn(label: Text('Employee Id')),
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Phone')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Department')),
            DataColumn(label: Text('Designation')),
            DataColumn(label: Text('Branch')),
            DataColumn(label: Text('Date of join')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('')), // Delete column
          ],
          rows: employees.map((EmployeeModel employee) {
            return DataRow(
              cells: [
                DataCell(Text(employee.employeeId)),
                DataCell(Text(employee.employeeName)),
                DataCell(Text(employee.employeePhoneNo)),
                DataCell(Text(employee.employeeEmail)),
                DataCell(Text(employee.employeeDepartment)),
                DataCell(Text(employee.employeeDesignation)),
                DataCell(Text(employee.employeeBranch)),
                DataCell(Text(DateFormatter.formatDate(employee.employeeDateOfJoining))),
                DataCell(Text(employee.employeeType)),
                DataCell(Text('Active')), // Status - could be added to model
                DataCell(
                  OutlinedButton(
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Employee'),
                          content: Text('Are you sure you want to delete ${employee.employeeName}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true && context.mounted) {
                        final success = await context.read<EmployeeProvider>().deleteEmployee(employee.id);
                        
                        if (success && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Employee deleted successfully')),
                          );
                        } else if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.read<EmployeeProvider>().error ?? 'Failed to delete employee',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.spacing16,
                        vertical: AppSizes.spacing8,
                      ),
                      minimumSize: const Size(60, 32),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
