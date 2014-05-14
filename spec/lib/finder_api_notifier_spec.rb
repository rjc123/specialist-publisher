require 'fast_spec_helper'
require 'finder_api_notifier'

describe FinderAPINotifier do
  describe '#call(document)' do
    subject(:notifier) { FinderAPINotifier.new(api_client, markdown_renderer) }

    let(:api_client) { double(:finder_api, notify_of_publication: nil) }
    let(:markdown_renderer) { double(:markdown_renderer) }
    let(:document) { double(:document) }
    let(:markdown_document_slug) { "cma-cases/a-cma-case-document" }
    let(:markdown_document_attributes) { double(:document_attributes) }

    let(:markdown_document) {
      double(
        :markdown_document,
        attributes: markdown_document_attributes,
        slug: markdown_document_slug,
      )
    }

    before do
      allow(markdown_renderer).to receive(:call).and_return(markdown_document)
    end

    it "renders the document into plain markdown" do
      notifier.call(document)

      expect(markdown_renderer).to have_received(:call).with(document)
    end

    it "sends all the document's attributes to the Finder API" do
      notifier.call(document)

      expect(api_client).to have_received(:notify_of_publication).with(
        markdown_document_slug,
        markdown_document_attributes
      )
    end
  end
end