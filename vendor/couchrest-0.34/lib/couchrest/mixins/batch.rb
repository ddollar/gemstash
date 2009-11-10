module CouchRest::Mixins::Batch

  def self.included(base)
    base.send(:alias_method, :save_doc_without_batch, :save_doc)
  end

  def batch
    class << self
      alias_method :save_doc, :save_doc_with_batch
    end
    yield self
  ensure
    class << self
      alias_method :save_doc, :save_doc_without_batch
    end
    self.bulk_save
  end

  def save_doc_with_batch(document)
    self.save_doc_without_batch(document, true)
  end

end
