import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_form_field_w.dart';
import '../../../notes/presentation/widgets/color_secetions_sheet.dart';
import '../../domain/entities/folder_entity.dart';
import '../manager/folder_actions_cubit/folder_actions_cubit.dart';

class AddFolderDialogContentWidget extends StatefulWidget {
  const AddFolderDialogContentWidget({
    super.key,
    this.folderEntity,
  });

  final FolderEntity? folderEntity;

  @override
  State<AddFolderDialogContentWidget> createState() =>
      _AddFolderDialogContentWidgetState();
}

class _AddFolderDialogContentWidgetState
    extends State<AddFolderDialogContentWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _discriptionController;
  late int _colorIdx;

  @override
  void initState() {
    _nameController =
        TextEditingController(text: widget.folderEntity?.name ?? "");
    _discriptionController =
        TextEditingController(text: widget.folderEntity?.description ?? "");
    _colorIdx = widget.folderEntity?.color ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _discriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width - 10,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("add_new_folder".tr(context)),
              SpacingHelper.h3,
              CustomTextFormFieldWidget(
                controller: _nameController,
                hintText: 'name'.tr(context),
                validator: Validators.validateName,
              ),
              SpacingHelper.h2,
              CustomTextFormFieldWidget(
                controller: _discriptionController,
                hintText: 'discription'.tr(context),
              ),
              SpacingHelper.h2,
              ColorSelectionSheet(
                onColorSelected: (int idx) {
                  _colorIdx = idx;
                },
                idx: _colorIdx,
              ),
              SpacingHelper.h5,
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FolderEntity folder = FolderEntity(
                      userID: '',
                      description: _discriptionController.text.trim(),
                      id: widget.folderEntity == null
                          ? const Uuid().v1()
                          : widget.folderEntity!.id,
                      name: _nameController.text.trim(),
                      color: _colorIdx,
                    );

                    if (widget.folderEntity == null) {
                      _createFolder(folder);
                    } else {
                      _editFolder(folder);
                    }

                    context.read<FolderActionsCubit>().fetchAllFolders();
                    Navigator.pop(context);
                  }
                },
                child: Text(createOrEdit()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createFolder(FolderEntity folder) async {
    await context.read<FolderActionsCubit>().createFolder(folder: folder);
  }

  Future<void> _editFolder(FolderEntity folder) async {
    await context.read<FolderActionsCubit>().editFolder(folder: folder);
  }

  String createOrEdit() {
    if (widget.folderEntity == null) {
      return 'add'.tr(context);
    } else {
      return 'edit'.tr(context);
    }
  }
}
