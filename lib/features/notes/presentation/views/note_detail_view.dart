import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/services/image_storage_services.dart';
import 'package:note/features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_notes_by_folder_cubit.dart/fetch_notes_by_folder_cubit.dart';
import 'package:note/features/notes/presentation/manager/update_note_cubit/update_note_cubit.dart';
import 'package:note/features/notes/presentation/manager/upload_note_cubit/upload_note_cubit.dart';
import 'package:note/features/notes/presentation/views/image_view.dart';
import '../../../../core/helpers/functions/ui_functions.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/widgets/custtom_bottom_sheet._widget.dart';
import '../widgets/color_secetions_sheet.dart';
import '../widgets/fab_menu.dart';
import '../widgets/folder_selection_sheet.dart';
import '../widgets/image_display.dart';
import '../widgets/image_source_sheet.dart';
import '../widgets/save_options_sheet.dart';
import '../widgets/title_and_content_text_fields.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key, this.note, this.folder});
  final NoteEntity? note;
  static const String id = 'note_detail_screen';
  final String? folder;

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  TextDirection titleTextDirection = TextDirection.ltr;
  TextDirection contentTextDirection = TextDirection.ltr;

  final ImagePickerService _imagePickerService = ImagePickerService();
  late List<String> noteFolders;

  late int color;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.note != null &&
        widget.note!.imageUrl != '' &&
        widget.note!.imageUrl != null) {
      _selectedImage = File(widget.note!.imageUrl!);
    }
    noteFolders = widget.note?.folders ?? [];
    color = widget.note?.color ?? 0;

    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController =
        TextEditingController(text: widget.note?.content ?? "");

    if (widget.note != null) {
      _detectContentTextDirection(widget.note!.content[0]);
      _detectTitleTextDirection(widget.note!.title[0]);
    }
  }

  void _detectTitleTextDirection(String text) {
    if (text.isEmpty) {
      setState(() => titleTextDirection = TextDirection.ltr);
      return;
    }

    final firstChar = text.trim().characters.first;

    setState(() {
      titleTextDirection =
          isArbic(firstChar) ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  void _detectContentTextDirection(String text) {
    if (text.isEmpty) {
      setState(() => contentTextDirection = TextDirection.ltr);
      return;
    }

    final firstChar = text.trim().characters.first;

    setState(() {
      contentTextDirection =
          isArbic(firstChar) ? TextDirection.rtl : TextDirection.ltr;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColors[color],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // ignore: deprecated_member_use
    return SizedBox(
      child: Stack(
        children: <Widget>[
          // ignore: deprecated_member_use
          WillPopScope(
            onWillPop: () async {
              _saveNote();
              return true;
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        if (_selectedImage != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ImageView(image: _selectedImage!),
                              ));
                            },
                            child: ImageDisplay(
                              image: _selectedImage!,
                              onLongPress: _showImageOptions,
                            ),
                          ),
                        TitleField(
                          controller: _titleController,
                          direction: titleTextDirection,
                          onChanged: _detectTitleTextDirection,
                        ),
                        const SizedBox(height: 10),
                        ContentField(
                          controller: _contentController,
                          direction: contentTextDirection,
                          onChanged: _detectContentTextDirection,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          FabMenu(
            onColorPressed: _showColorsDialog,
            onFolderPressed: _showFolderBottomSheet,
            onImagePressed: _showImageSourceDialog,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.cardColors[color],
      title: Text(
        widget.note == null ? "edit_note".tr(context) : "new_note".tr(context),
      ),
    );
  }

  Future<void> _saveNote() async {
    final getUserState = context.read<GetUserCubit>().state;
    final uploadNoteCubit = context.read<UploadNoteCubit>();
    final updateNoteCubit = context.read<UpdateNoteCubit>();
    final fetchAllNotesCubit = context.read<FetchAllNotesCubit>();
    final fetchNotesByFolderCubit = context.read<FetchNotesByFolderCubit>();
    final pop = Navigator.pop(context);

    if (getUserState is GetUserSuccess) {
      RequiredDataEntity data = RequiredDataEntity(
        imageUrl: widget.note?.imageUrl ?? '',
        color: color,
        id: (widget.note == null) ? '' : widget.note!.id,
        userId: getUserState.user.id,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        image: _selectedImage,
        folders: noteFolders,
        inSynced: widget.note?.isSynced ?? 0,
      );

      if (data.title == '' && data.content == '') {
        pop;
        return;
      }

      if (widget.note == null) {
        await uploadNoteCubit.uploadNote(data: data);
      } else {
        await updateNoteCubit.updateNote(data: data);
        if (widget.folder != null) {
          fetchNotesByFolderCubit.fetchNotesByFolder(
              folderName: widget.folder!);
        }
      }

      if (mounted) {
        await fetchAllNotesCubit.fetchAllNotes();
        pop;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await _imagePickerService.pickImage(source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
    }
  }

  void _showImageOptions() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: '',
        contentWidgets: [
          ImageOptionsSheet(
            onPickImage: _showImageSourceDialog,
            onDeleteImage: () {
              Navigator.pop(context);
              setState(() {
                ImageService.instance.deleteImage(_selectedImage!);
                _selectedImage = null;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: "chose_image_source".tr(context),
        contentWidgets: [
          ImageSourceSheet(
            onCameraPressed: () => _pickImage(ImageSource.camera),
            onGalleryPressed: () => _pickImage(ImageSource.gallery),
          )
        ],
      ),
    );
  }

  void _showColorsDialog() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: "select_color".tr(context),
        contentWidgets: [
          ColorSelectionSheet(
            onColorSelected: (int index) {
              setState(() {
                color = index;
              });
            },
            idx: color,
          ),
        ],
      ),
    );
  }

  void _showFolderBottomSheet() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: "chose_folder".tr(context),
        contentWidgets: [
          FolderSelectionSheet(
            currentNoteFolders: noteFolders,
            onFolderToggled: (String name, bool value) {
              setState(
                () {
                  value ? noteFolders.add(name) : noteFolders.remove(name);
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.secondary),
              ),
              onPressed: () {
                showAddFolderDialog(context);
              },
              child: Text(
                "add_new_folder".tr(context),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
