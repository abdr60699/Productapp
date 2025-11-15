import '../entities/template.dart';

abstract class TemplateRepository {
  Future<List<Template>> getTemplates();
  Future<Template?> getTemplate(String templateId);
  Future<void> saveTemplate(Template template);
  Future<void> deleteTemplate(String templateId);
  Future<void> clearAllTemplates();
}
