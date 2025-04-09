import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/utils/logger.dart';

import '../../../../core/helpers/colors/app_colors.dart';
import '../../../../core/helpers/functions/ui_functions.dart';
import '../../../../core/helpers/styles/fonts_h.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/services/image_storage_services.dart';
import '../../../../core/widgets/custtom_bottom_sheet._widget.dart';
import '../../../auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/required_data_entity.dart';
import '../manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import '../manager/fetch_notes_by_folder_cubit.dart/fetch_notes_by_folder_cubit.dart';
import '../manager/update_note_cubit/update_note_cubit.dart';
import '../manager/upload_note_cubit/upload_note_cubit.dart';
import '../views/image_view.dart';
import '../widgets/color_secetions_sheet.dart';
import '../widgets/folder_selection_sheet.dart';
import '../widgets/image_source_sheet.dart';
import '../widgets/save_options_sheet.dart';

class NoteDetailScreenLogic {
  // Controllers
  final TextEditingController titleController;
  final TextEditingController contentController;

  final BuildContext context;

  // State variables
  TextDirection titleTextDirection = TextDirection.ltr;
  TextDirection contentTextDirection = TextDirection.ltr;
  File? selectedImage;
  List<String> noteFolders;
  int noteColor;
  final NoteEntity? note;
  final String? folder;
  final VoidCallback onStateUpdate;

  // Services
  final ImagePickerService _imagePickerService = ImagePickerService();

  NoteDetailScreenLogic({
    required this.context,
    required this.note,
    required this.folder,
    required this.onStateUpdate,
  })  : titleController = TextEditingController(text: note?.title ?? ""),
        contentController = TextEditingController(text: note?.content ?? ""),
        noteFolders = note?.folders ?? [],
        noteColor = note?.color ?? 100,
        selectedImage = _initializeImage(note) {
    _initializeTextDirections();
  }

  static File? _initializeImage(NoteEntity? note) {
    return (note != null && note.imageUrl != null && note.imageUrl!.isNotEmpty)
        ? File(note.imageUrl!)
        : null;
  }

  void _initializeTextDirections() {
    if (note != null) {
      if (note!.title.isNotEmpty) {
        titleTextDirection = _determineTextDirection(note!.title[0]);
      }
      if (note!.content.isNotEmpty) {
        contentTextDirection = _determineTextDirection(note!.content[0]);
      }
    }
  }

  TextDirection _determineTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;

    // Remove markdown syntax characters
    final cleanText = text.replaceAll(RegExp(r'^[#*~`>|!\[\]]+'), '').trim();

    if (cleanText.isEmpty) return TextDirection.ltr;

    final firstChar = cleanText.characters.first;
    return isArbic(firstChar) ? TextDirection.rtl : TextDirection.ltr;
  }

  void detectTitleTextDirection(String text) {
    titleTextDirection = _determineTextDirection(text);
    onStateUpdate();
  }

  void detectContentTextDirection(String text) {
    contentTextDirection = _determineTextDirection(text);
    onStateUpdate();
  }

  Color getNoteBackgroundColor(ThemeData theme) {
    final colorIndex = noteColor == 100
        ? (theme.brightness == Brightness.light ? 1 : 0)
        : noteColor;
    return AppColors.cardColors[colorIndex];
  }

  Widget buildAppBarTitle(BuildContext context) {
    return ListTile(
      title: Text(
        note != null ? "edit_note".tr(context) : "new_note".tr(context),
      ),
      subtitle: note != null
          ? Text(
              "${'last_update'.tr(context)} : ${formatDateTime(note!.uploadedAt)}",
              style: FontsStylesHelper.textStyle10,
            )
          : null,
    );
  }

  Future<bool> handleBackNavigation() async {
    // Save the note before navigating back
    await saveNote();

    // Only proceed with navigation if the context is still mounted
    if (!context.mounted) return true;

    // Refresh the notes list
    await context.read<FetchAllNotesCubit>().fetchAllNotes();

    // If we're in a folder view, refresh that too
    if (folder != null && context.mounted) {
      await context
          .read<FetchNotesByFolderCubit>()
          .fetchNotesByFolder(folderName: folder!);
    }

    return true;
  }

  Future<void> saveNote() async {
    Log.info("save note");
    final getUserState = context.read<GetUserCubit>().state;

    if (getUserState is! GetUserSuccess) return;

    final data = _prepareNoteData(getUserState);

    // Skip saving empty notes
    if (data.title.isEmpty && data.content.isEmpty) return;

    await _persistNote(data);
  }

  RequiredDataEntity _prepareNoteData(GetUserSuccess getUserState) {
    return RequiredDataEntity(
      imageUrl: note?.imageUrl ?? '',
      color: noteColor == 100
          ? (Theme.of(context).brightness == Brightness.light ? 1 : 0)
          : noteColor,
      id: note?.id ?? '',
      userId: getUserState.user.id,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      image: selectedImage,
      folders: noteFolders,
      inSynced: note?.isSynced ?? 0,
    );
  }

  Future<void> _persistNote(RequiredDataEntity data) async {
    final insertNoteCubit = context.read<UploadNoteCubit>();
    final updateNoteCubit = context.read<UpdateNoteCubit>();
    final fetchAllNotesCubit = context.read<FetchAllNotesCubit>();

    if (note == null) {
      await insertNoteCubit.uploadNote(data: data);
    } else {
      await updateNoteCubit.updateNote(data: data);
      if (folder != null && context.mounted) {
        context
            .read<FetchNotesByFolderCubit>()
            .fetchNotesByFolder(folderName: folder!);
      }
    }

    if (context.mounted) {
      await fetchAllNotesCubit.fetchAllNotes();
    }
  }

  // Image-related methods
  Future<void> pickImage(ImageSource source) async {
    final pickedImage = await _imagePickerService.pickImage(source);
    if (pickedImage != null) {
      selectedImage = pickedImage;
      onStateUpdate();
    }
  }

  void showImageOptions() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: '',
        contentWidgets: [
          ImageOptionsSheet(
            onPickImage: showImageSourceDialog,
            onDeleteImage: deleteImage,
          ),
        ],
      ),
    );
  }

  void deleteImage() {
    ImageService.instance.deleteImage(selectedImage!);
    selectedImage = null;
    onStateUpdate();
  }

  void showImageSourceDialog() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: "chose_image_source".tr(context),
        contentWidgets: [
          ImageSourceSheet(
            onCameraPressed: () => pickImage(ImageSource.camera),
            onGalleryPressed: () => pickImage(ImageSource.gallery),
          )
        ],
      ),
    );
  }

  void showColorSelectionSheet() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: "select_color".tr(context),
        contentWidgets: [
          ColorSelectionSheet(
            onColorSelected: (int index) {
              noteColor = index;
              onStateUpdate();
              Navigator.of(context).pop();
            },
            idx: noteColor,
          ),
        ],
      ),
    );
  }

  void showFolderSelectionSheet() {
    customShowModelBottomSheetMethod(
      context: context,
      child: CustomModalBottomSheet(
        title: "chose_folder".tr(context),
        contentWidgets: [
          FolderSelectionSheet(
            currentNoteFolders: noteFolders,
            onFolderToggled: (String name, bool value) {
              toggleFolder(name, value);
              Navigator.of(context).pop();
            },
          ),
          _buildAddFolderButton(),
        ],
      ),
    );
  }

  void toggleFolder(String name, bool value) {
    value ? noteFolders.add(name) : noteFolders.remove(name);
    onStateUpdate();
  }

  Widget _buildAddFolderButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () {
          Navigator.of(context).pop();
          showAddFolderDialog(context: context);
        },
        child: Text(
          "add_new_folder".tr(context),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void openFullImageView() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageView(
          image: selectedImage!,
        ),
      ),
    );
  }

  void dispose() {
    titleController.dispose();
    contentController.dispose();
  }
}
