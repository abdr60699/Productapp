import '../entities/template.dart';
import '../repositories/template_repository.dart';

class GetTemplate {
  final TemplateRepository repository;

  GetTemplate(this.repository);

  Future<Template?> call(String templateId) async {
    return await repository.getTemplate(templateId);
  }
}
