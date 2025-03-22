import 'package:flutter/material.dart';

class OrderForm extends StatefulWidget {
  final Function(String name, String phone, String address) onSubmit;

  const OrderForm({required this.onSubmit});

  @override
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _nameController.text,
        _phoneController.text,
        _addressController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'الاسم'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال الاسم';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'رقم الهاتف'),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال رقم الهاتف';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'العنوان'),
            maxLines: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال العنوان';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _submitForm,
              child: Text('تأكيد الطلب'),
            ),
          ),
        ],
      ),
    );
  }
}
