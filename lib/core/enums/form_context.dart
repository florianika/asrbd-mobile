enum FormContext {
  view,
  edit,
  add,
}

extension FormContextExtension on FormContext {
  String get displayName {
    switch (this) {
      case FormContext.view:
        return 'View';
      case FormContext.edit:
        return 'Edit';
      case FormContext.add:
        return 'Add';
    }
  }

  bool get isReadOnly {
    return this == FormContext.view;
  }

  bool get showEditButton {
    return this == FormContext.view;
  }

  bool get showSaveButton {
    return this == FormContext.edit || this == FormContext.add;
  }

  bool get showCancelButton {
    return this == FormContext.edit;
  }
}
