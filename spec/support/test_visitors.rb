class Arel::Visitors::Test < Arel::Visitors::ToSql
end

class Arel::Visitors::TestStubbed
  def initialize(connection); end
  def accept(ast);            end
end
