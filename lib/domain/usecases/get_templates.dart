import '../entities/template.dart';
import '../repositories/template_repository.dart';

class GetTemplates {
  final TemplateRepository repository;

  GetTemplates(this.repository);

  Future<List<Template>> call() async {
    return await repository.getTemplates();
  }
}
