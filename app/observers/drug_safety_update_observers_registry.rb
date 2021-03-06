require "email_alert_exporter"

class DrugSafetyUpdateObserversRegistry < AbstractSpecialistDocumentObserversRegistry
  # Overridden to not send publication alerts -- they're sent manually each month to the list
  def publication
    [
      publication_logger,
      content_api_exporter,
      panopticon_exporter,
      rummager_exporter,
    ]
  end

private
  def content_api_exporter
    SpecialistPublisherWiring.get(:drug_safety_update_content_api_exporter)
  end

  def panopticon_exporter
    SpecialistPublisherWiring.get(:drug_safety_update_panopticon_registerer)
  end

  def rummager_withdrawer
    SpecialistPublisherWiring.get(:drug_safety_update_rummager_deleter)
  end

  def rummager_exporter
    SpecialistPublisherWiring.get(:drug_safety_update_rummager_indexer)
  end

  def content_api_withdrawer
    SpecialistPublisherWiring.get(:specialist_document_content_api_withdrawer)
  end
end
