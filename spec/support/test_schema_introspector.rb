class TestSchemaIntrospector
  def initialize(url)
  end

  def columns(table)
    # DataObjects::Arel::Column.new(:name => 'id'),
    # DataObjects::Arel::Column.new(:name => 'author')
    []
  end

  def tables
    %w(ebooks tweets music)
  end
end
