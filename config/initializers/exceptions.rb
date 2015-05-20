module Oniwa
  class ApplicationError < StandardError; end

  class Forbidden < ApplicationError; end
  class BadRequest < ApplicationError; end
  class InternalServerError < ApplicationError; end

  class InvalidRequest < ApplicationError; end
end
