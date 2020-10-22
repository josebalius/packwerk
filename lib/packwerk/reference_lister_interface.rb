# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

require "packwerk/reference"
require "packwerk/violation_type"

module Packwerk
  module ReferenceListerInterface
    extend T::Sig
    extend T::Helpers

    interface!

    sig do
      params(reference: Packwerk::Reference, violation_type: ViolationType)
        .returns(T::Boolean)
        .abstract
    end
    def listed?(reference, violation_type:); end
  end
end
