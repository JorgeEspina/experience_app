import 'package:flutter/material.dart';
import 'package:experience_app/system_design/widgets/app_filled_button.dart';

class AddCardBottomSheet extends StatefulWidget {
  const AddCardBottomSheet({super.key, this.onCardAdded});

  final void Function(String holder, String number, String expiry, String cvv)?
      onCardAdded;

  static Future<void> show(
    BuildContext context, {
    void Function(String holder, String number, String expiry, String cvv)?
        onCardAdded,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddCardBottomSheet(onCardAdded: onCardAdded),
    );
  }

  @override
  State<AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<AddCardBottomSheet> {
  final _holderController = TextEditingController();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Add new card',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2229),
            ),
          ),
          const SizedBox(height: 20),
          _CardTextField(
            controller: _holderController,
            label: 'Card holder name',
            hint: 'John Doe',
          ),
          const SizedBox(height: 14),
          _CardTextField(
            controller: _numberController,
            label: 'Card number',
            hint: '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _CardTextField(
                  controller: _expiryController,
                  label: 'Expiry date',
                  hint: 'MM/YY',
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CardTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  hint: '123',
                  keyboardType: TextInputType.number,
                  obscure: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          AppFilledButton(
            text: 'Add card',
            onPressed: () {
              widget.onCardAdded?.call(
                _holderController.text,
                _numberController.text,
                _expiryController.text,
                _cvvController.text,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _CardTextField extends StatelessWidget {
  const _CardTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1E6EF2)),
            ),
          ),
        ),
      ],
    );
  }
}
