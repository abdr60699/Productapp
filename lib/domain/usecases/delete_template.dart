import '../repositories/template_repository.dart';

class DeleteTemplate {
  final TemplateRepository repository;

  DeleteTemplate(this.repository);

  Future<void> call(String templateId) async {
    return await repository.deleteTemplate(templateId);
  }
}
