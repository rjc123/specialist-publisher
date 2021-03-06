class PublishDocumentService
  def initialize(document_repository, listeners, document_id, bulk_publish = false)
    @document_repository = document_repository
    @listeners = listeners
    @document_id = document_id
    @bulk_publish = bulk_publish
  end

  def call
    publish
    persist

    document
  end

  private

  attr_reader :document_repository, :listeners, :document_id, :bulk_publish

  def publish
    unless document.minor_update
      document.update(bulk_published: bulk_publish)
      document.update(public_updated_at: Time.current)
    end

    document.publish!

    listeners.each { |o| o.call(document) }
  end

  def persist
    document_repository.store(document)
  end

  def notify_listeners
    listeners.each do |listener|
      listener.call(document)
    end
  end

  def document
    @document ||= document_repository.fetch(document_id)
  end
end
