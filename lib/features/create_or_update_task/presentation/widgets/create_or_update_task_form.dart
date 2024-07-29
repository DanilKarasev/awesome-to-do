import 'package:awesome_to_do/core/widgets/generic_text_form_field.dart';
import 'package:awesome_to_do/features/create_or_update_task/presentation/bloc/create_or_update_task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/generic_date_picker.dart';

class CreateOrUpdateTaskForm extends StatelessWidget {
  const CreateOrUpdateTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: BlocBuilder<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
            builder: (context, state) {
          return Form(
            key: context.read<CreateOrUpdateTaskCubit>().formKey,
            autovalidateMode: state.enableValidation
                ? AutovalidateMode.onUserInteraction
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TitleInput(),
                const SizedBox(height: 8),
                _ShortDescriptionInput(),
                const SizedBox(height: 8),
                _DescriptionInput(),
                const SizedBox(height: 8),
                _DueDateInput(),
                const SizedBox(height: 8),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (val) =>
              context.read<CreateOrUpdateTaskCubit>().titleChange(val),
          label: 'Title',
          isRequired: true,
          maxLength: 30,
          initialValue: state.title,
        );
      },
    );
  }
}

class _ShortDescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
      buildWhen: (previous, current) =>
          previous.shortDescription != current.shortDescription,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (val) => context
              .read<CreateOrUpdateTaskCubit>()
              .shortDescriptionChange(val),
          label: 'Short Description',
          isRequired: true,
          maxLength: 60,
          initialValue: state.shortDescription,
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
      buildWhen: (previous, current) =>
          previous.description != current.description,
      builder: (context, state) {
        return GenericTextFormField(
          onChanged: (val) =>
              context.read<CreateOrUpdateTaskCubit>().descriptionChange(val),
          label: 'Full Description',
          isRequired: true,
          maxLength: 200,
          initialValue: state.description,
        );
      },
    );
  }
}

class _DueDateInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrUpdateTaskCubit, CreateOrUpdateTaskState>(
      buildWhen: (previous, current) => previous.dueDate != current.dueDate,
      builder: (context, state) {
        return GenericDatePicker(
          isRequired: false,
          lastDate: DateTime(2050),
          firstDate: DateTime.now().add(const Duration(hours: 2)),
          onChanged: (val) => val != null
              ? context.read<CreateOrUpdateTaskCubit>().dueDateChange(val)
              : null,
          initialValue: state.dueDate,
          label: 'Due Date',
          icon: Icons.today,
        );
      },
    );
  }
}
