class PublishManualService
  def initialize(dependencies)
    @manual_id = dependencies.fetch(:manual_id)
    @manual_repository = dependencies.fetch(:manual_repository)
    @listeners = dependencies.fetch(:listeners)
  end

  def call
    publish
    persist

    manual
  end

  private

  attr_reader :manual_id, :manual_repository, :listeners

  def publish
    manual.publish

    listeners.each { |o| o.call(manual) }
  end

  def persist
    manual_repository.store(manual)
  end

  def notify_listeners
    listeners.each do |listener|
      listener.call(manual)
    end
  end

  def manual
    @manual ||= manual_repository.fetch(manual_id)
  end
end
