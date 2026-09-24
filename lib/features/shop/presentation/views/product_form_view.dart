import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';

import '../../domain/entities/product.dart';
import '../state/shop_providers.dart';

/// Form to create a new product or edit an existing one.
/// Pass [product] to edit; leave null to create.
class ProductFormView extends ConsumerStatefulWidget {
  const ProductFormView({super.key, this.product});

  final Product? product;

  bool get isEditing => product != null;

  @override
  ConsumerState<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends ConsumerState<ProductFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _sizesController;
  late final TextEditingController _colorsController;
  late final TextEditingController _imageUrlController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController =
        TextEditingController(text: p != null ? p.price.toString() : '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _sizesController = TextEditingController(text: p?.sizes.join(', ') ?? '');
    _colorsController = TextEditingController(
      text: p != null
          ? p.colors.map((c) => c.toARGB32().toString()).join(', ')
          : '',
    );
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _sizesController.dispose();
    _colorsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: const Color(0xFF1E2229),
        title: Text(
          widget.isEditing ? 'Editar producto' : 'Nuevo producto',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2229),
          ),
        ),
        actions: [
          if (widget.isEditing)
            IconButton(
              onPressed: _isSaving ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626)),
              tooltip: 'Eliminar',
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _field(
                controller: _nameController,
                label: 'Nombre',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              _field(
                controller: _priceController,
                label: 'Precio',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Requerido';
                  if (double.tryParse(v.trim()) == null) {
                    return 'Debe ser un número';
                  }
                  return null;
                },
              ),
              _field(
                controller: _descriptionController,
                label: 'Descripción',
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              _field(
                controller: _sizesController,
                label: 'Tallas (separadas por coma)',
                hint: 'XS, S, M, L, XL',
              ),
              _field(
                controller: _colorsController,
                label: 'Colores ARGB (separados por coma)',
                hint: '4278190080, 4282203453',
                keyboardType: TextInputType.number,
              ),
              _field(
                controller: _imageUrlController,
                label: 'URL de imagen',
                hint: 'https://...',
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              AppFilledButton(
                text: _isSaving
                    ? 'Guardando...'
                    : (widget.isEditing ? 'Guardar cambios' : 'Crear producto'),
                onPressed: _isSaving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  List<String> _parseCsv(String raw) => raw
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final sizes = _parseCsv(_sizesController.text);
    final colorInts = _parseCsv(_colorsController.text)
        .map(int.tryParse)
        .whereType<int>()
        .toList();

    final product = Product(
      // Keep the existing id when editing; empty when creating (Firestore
      // will assign one via addProduct).
      id: widget.product?.id ?? '',
      name: _nameController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      description: _descriptionController.text.trim(),
      sizes: sizes,
      colors: colorInts.map(Color.new).toList(),
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
    );

    setState(() => _isSaving = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final controller = ref.read(shopControllerProvider.notifier);
      if (widget.isEditing) {
        await controller.updateProduct(product);
      } else {
        await controller.createProduct(product);
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing ? 'Producto actualizado' : 'Producto creado',
          ),
        ),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  Future<void> _confirmDelete() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Eliminar producto'),
        content: Text('¿Seguro que deseas eliminar "${widget.product!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(shopControllerProvider.notifier)
          .deleteProduct(widget.product!.id);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
      navigator.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }
}
