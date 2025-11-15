import '../../domain/entities/template.dart';
import '../../domain/repositories/template_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/template_model.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final LocalDataSource dataSource;

  TemplateRepositoryImpl(this.dataSource);

  @override
  Future<List<Template>> getTemplates() async {
    return await dataSource.getTemplates();
  }

  @override
  Future<Template?> getTemplate(String templateId) async {
    final templates = await dataSource.getTemplates();
    try {
      return templates.firstWhere((template) => template.id == templateId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTemplate(Template template) async {
    final templateModel = TemplateModel.fromEntity(template);
    await dataSource.saveTemplate(templateModel);
  }

  @override
  Future<void> deleteTemplate(String templateId) async {
    await dataSource.deleteTemplate(templateId);
  }

  @override
  Future<void> clearAllTemplates() async {
    await dataSource.clearAllTemplates();
  }
}
