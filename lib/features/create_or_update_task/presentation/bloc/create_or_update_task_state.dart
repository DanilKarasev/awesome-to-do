part of 'create_or_update_task_cubit.dart';

final class CreateOrUpdateTaskState extends Equatable {
  const CreateOrUpdateTaskState({
    this.title = '',
    this.requestorId = '',
    this.ownerId = '',
    this.description = '',
    this.shortDescription = '',
    this.dueDate,
    this.status = TaskStatus.unchecked,
    this.isLoading = false,
    this.updatedSuccessfully = false,
    this.enableValidation = false,
    this.errorMessage,
  });

  final String title; //Required
  final String requestorId; //Ignore
  final String ownerId; //Ignore
  final String description;
  final String shortDescription; //Required

  final DateTime? dueDate;
  final TaskStatus status;

  final bool isLoading;
  final bool updatedSuccessfully;
  final bool enableValidation;
  final String? errorMessage;

  bool get fieldsAreNotEmpty => title.isNotEmpty && shortDescription.isNotEmpty;

  @override
  List<Object?> get props => [
        title,
        requestorId,
        ownerId,
        description,
        shortDescription,
        dueDate,
        status,
        isLoading,
        updatedSuccessfully,
        enableValidation,
        errorMessage,
      ];

  CreateOrUpdateTaskState copyWith({
    String? title,
    String? requestorId,
    String? ownerId,
    DateTime? dueDate,
    String? description,
    String? shortDescription,
    TaskStatus? status,
    bool? isLoading,
    bool? isCreate,
    bool? updatedSuccessfully,
    bool? enableValidation,
    String? errorMessage,
  }) {
    return CreateOrUpdateTaskState(
      title: title ?? this.title,
      requestorId: requestorId ?? this.requestorId,
      ownerId: ownerId ?? this.ownerId,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      updatedSuccessfully: updatedSuccessfully ?? this.updatedSuccessfully,
      enableValidation: enableValidation ?? this.enableValidation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
