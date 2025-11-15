import '../entities/template.dart';
import '../repositories/template_repository.dart';

class SaveTemplate {
  final TemplateRepository repository;

  SaveTemplate(this.repository);

  Future<void> call(Template template) async {
    return await repository.saveTemplate(template);
  }
}
