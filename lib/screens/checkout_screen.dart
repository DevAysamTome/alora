import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aloraapp/data/models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import 'order_success.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  // الحقول النصية للبيانات الشخصية
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // الحقول النصية للعنوان
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  int _currentStep = 0; // مؤشر الخطوة الحالية في الـ Stepper

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _villageController.dispose();
    _areaController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  // دالة التحقق من البيانات في كل خطوة
  bool _validateStep(int step) {
    switch (step) {
      case 0:
        // تحقق من الاسم والهاتف
        if (_nameController.text.isEmpty) {
          _showError('يرجى إدخال الاسم');
          return false;
        }
        if (_phoneController.text.isEmpty) {
          _showError('يرجى إدخال رقم الهاتف');
          return false;
        }
        // يمكن إضافة تحقق إضافي لصحة رقم الهاتف
        return true;

      case 1:
        // تحقق من حقول العنوان
        if (_cityController.text.isEmpty) {
          _showError('يرجى إدخال المدينة');
          return false;
        }
        if (_villageController.text.isEmpty) {
          _showError('يرجى إدخال القرية أو المنطقة');
          return false;
        }
        if (_areaController.text.isEmpty) {
          _showError('يرجى إدخال الحي');
          return false;
        }
        if (_streetController.text.isEmpty) {
          _showError('يرجى إدخال اسم الشارع');
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  // دالة لعرض رسالة خطأ في حالة فشل التحقق
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  // دالة للتنقل للخطوة التالية
  void _onStepContinue() {
    if (_validateStep(_currentStep)) {
      if (_currentStep < 1) {
        // إذا لم تكن في آخر خطوة، انتقل للخطوة التالية
        setState(() {
          _currentStep++;
        });
      } else {
        // إذا كنت في آخر خطوة (الخطوة الثانية)، نفذ منطق إرسال الطلب
        _submitOrder();
      }
    }
  }

  // دالة للرجوع خطوة واحدة للخلف
  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context); // إذا كنت في الخطوة الأولى، رجوع للشاشة السابقة
    }
  }

  // دالة تنفيذ الطلب
  void _submitOrder() async {
    final ordersProvider = Provider.of<OrdersProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    try {
      // مثال على حفظ البيانات
      await ordersProvider.addOrder(
  cartItems: cartProvider.items,
  total: cartProvider.totalAmount,
  name: _nameController.text,
  phoneNumber: _phoneController.text,
  city: _cityController.text,
  village: _villageController.text,
  area: _areaController.text,
  street: _streetController.text,
  status: 'طلب جديد', // أو أي حالة أخرى
);


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) =>  OrderSuccessScreen()),

      );
      cartProvider.clearCart();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء إتمام الطلب: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لجعل الواجهة RTL
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إتمام الطلب'),
          backgroundColor: Colors.brown.shade300,
        ),
        body: Theme(
          // لتخصيص شكل الـStepper بشكل أجمل
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.brown.shade500, // لون مؤشرات الخطوات
                ),
          ),
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: _onStepContinue,
            onStepCancel: _onStepCancel,
            type: StepperType.vertical,
            steps: _buildSteps(),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              // تصميم مخصص لأزرار المتابعة والتراجع
              final isLastStep = _currentStep == _buildSteps().length - 1;
              return Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.shade500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(isLastStep ? 'إتمام الطلب' : 'التالي'),
                  ),
                  const SizedBox(width: 8),
                  if (_currentStep != 0)
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.brown.shade300,
                        side: const BorderSide(color: Colors.brown),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('السابق'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // بناء الخطوات (Steps) الخاصة بالـStepper
  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('البيانات الشخصية',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: _buildPersonalInfoForm(),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('عنوان التوصيل',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: _buildAddressForm(),
        isActive: _currentStep >= 1,
        state: _currentStep == 1 ? StepState.editing : StepState.indexed,
      ),
    ];
  }

  // النموذج الخاص بالبيانات الشخصية (الخطوة الأولى)
  Widget _buildPersonalInfoForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'الاسم الكامل',
          hint: 'أدخل اسمك الثلاثي',
          icon: Icons.person,
          keyboardType: TextInputType.name,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          hint: 'مثال: 059xxxxxxxx',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  // النموذج الخاص بعنوان التوصيل (الخطوة الثانية)
  Widget _buildAddressForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _cityController,
          label: 'المدينة',
          hint: 'مثال: غزة، رام الله...',
          icon: Icons.location_city,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _villageController,
          label: 'القرية / المنطقة',
          hint: 'مثال: القرية الفلانية...',
          icon: Icons.map,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _areaController,
          label: 'الحي',
          hint: 'مثال: حي النصر، حي الزيتون...',
          icon: Icons.location_on,
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: _streetController,
          label: 'الشارع',
          hint: 'اسم الشارع أو المعلم البارز',
          icon: Icons.streetview,
        ),
      ],
    );
  }

  // ودجت مساعدة لبناء TextField بتصميم متناسق
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.brown.shade300),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.brown, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
